import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'g_log.dart';

enum VoiceCommand { start, stop, reset, ok, unknown }

class SttService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  bool _shouldKeepListening = false;
  bool _isMuted = false; // muted while TTS is speaking

  bool get isListening => _isListening && !_isMuted;
  bool get shouldKeepListening => _shouldKeepListening;

  Function(VoiceCommand)? onCommandDetected;
  Function(bool)? onListeningStateChanged;

  Future<bool> init() async {
    GLog.i('SttService', 'Requesting microphone permission...');
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      GLog.e('SttService', 'Microphone permission DENIED');
      return false;
    }
    GLog.i('SttService', 'Microphone permission GRANTED');

    if (_isInitialized) {
      GLog.i('SttService', 'Already initialized');
      return true;
    }

    _isInitialized = await _speech.initialize(
      onError: (error) {
        GLog.e('SttService', 'STT Error: ${error.errorMsg} | permanent: ${error.permanent}');
        _isListening = false;

        // Only restart if not muted and should keep listening
        if (_shouldKeepListening && !_isMuted) {
          final delay = error.errorMsg == 'error_busy'
              ? const Duration(milliseconds: 800)
              : const Duration(milliseconds: 400);
          Future.delayed(delay, () {
            if (!_isMuted) _restartListening();
          });
        }
      },
      onStatus: (status) {
        GLog.i('SttService', 'STT Status: $status');
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          onListeningStateChanged?.call(false);

          // Only restart if not muted
          if (_shouldKeepListening && !_isMuted) {
            Future.delayed(const Duration(milliseconds: 400), () {
              if (!_isMuted) _restartListening();
            });
          }
        }
      },
    );

    GLog.i('SttService', 'STT initialized: $_isInitialized');
    return _isInitialized;
  }

  // Called by TTS before speaking — pause STT
  void muteWhileSpeaking() {
    if (!_shouldKeepListening) return;
    GLog.d('SttService', 'MUTED — TTS speaking, STT paused');
    _isMuted = true;
    if (_isListening) {
      _speech.stop();
      _isListening = false;
      onListeningStateChanged?.call(false);
    }
  }

  // Called by TTS after speaking — resume STT
  void unmuteAfterSpeaking() {
    if (!_shouldKeepListening) return;
    GLog.d('SttService', 'UNMUTED — TTS done, STT resuming');
    _isMuted = false;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_isMuted) _restartListening();
    });
  }

  Future<void> startForeverListening() async {
    if (!_isInitialized) {
      GLog.e('SttService', 'Cannot start — not initialized');
      return;
    }
    GLog.i('SttService', 'Starting FOREVER listening mode...');
    _shouldKeepListening = true;
    _isMuted = false;
    await _restartListening();
  }

  Future<void> _restartListening() async {
    if (!_shouldKeepListening || _isListening || _isMuted) {
      GLog.d('SttService',
          'Skip restart — shouldKeep:$_shouldKeepListening isListening:$_isListening isMuted:$_isMuted');
      return;
    }

    GLog.i('SttService', 'Listening started...');
    _isListening = true;
    onListeningStateChanged?.call(true);

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          final words = result.recognizedWords.toUpperCase().trim();
          GLog.i('SttService', 'Final words detected: "$words"');

          if (words.isNotEmpty) {
            final command = _parseCommand(words);
            GLog.i('SttService', 'Command parsed: ${command.name}');
            if (command != VoiceCommand.unknown) {
              onCommandDetected?.call(command);
            } else {
              GLog.w('SttService', 'Unknown command: "$words"');
            }
          }

          _isListening = false;
          if (_shouldKeepListening && !_isMuted) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (!_isMuted) _restartListening();
            });
          }
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 8),
      partialResults: false,
      cancelOnError: false,
      listenMode: ListenMode.confirmation,
    );
  }

  void stopForeverListening() {
    GLog.i('SttService', 'Stopping forever listening...');
    _shouldKeepListening = false;
    _isMuted = false;
    _isListening = false;
    _speech.stop();
    onListeningStateChanged?.call(false);
  }

  void stopListening() => stopForeverListening();

  VoiceCommand _parseCommand(String words) {
    if (words.contains('START')) return VoiceCommand.start;
    if (words.contains('STOP')) return VoiceCommand.stop;
    if (words.contains('RESET')) return VoiceCommand.reset;
    if (words.contains('OK') || words.contains('OKAY')) return VoiceCommand.ok;
    return VoiceCommand.unknown;
  }

  void dispose() {
    GLog.i('SttService', 'Disposing STT service — MIC OFF');
    stopForeverListening();
    _speech.cancel();
  }
}