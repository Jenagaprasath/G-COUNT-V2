import 'g_log.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

enum VoiceCommand { start, stop, reset, ok, unknown }

class SttService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  bool _shouldKeepListening = false;

  bool get isListening => _isListening;
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
        if (_shouldKeepListening) {
          GLog.i('SttService', 'Auto-restarting after error...');
          Future.delayed(const Duration(milliseconds: 500), () {
            _restartListening();
          });
        }
      },
      onStatus: (status) {
        GLog.i('SttService', 'STT Status: $status');
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          onListeningStateChanged?.call(false);
          if (_shouldKeepListening) {
            GLog.i('SttService', 'Auto-restarting after status: $status');
            Future.delayed(const Duration(milliseconds: 300), () {
              _restartListening();
            });
          }
        }
      },
    );

    GLog.i('SttService', 'STT initialized: $_isInitialized');
    return _isInitialized;
  }

  Future<void> startForeverListening() async {
    if (!_isInitialized) {
      GLog.e('SttService', 'Cannot start — not initialized');
      return;
    }
    GLog.i('SttService', 'Starting FOREVER listening mode...');
    _shouldKeepListening = true;
    await _restartListening();
  }

  Future<void> _restartListening() async {
    if (!_shouldKeepListening || _isListening) {
      GLog.d('SttService', 'Skip restart — shouldKeep:$_shouldKeepListening isListening:$_isListening');
      return;
    }

    GLog.i('SttService', 'Listening started...');
    _isListening = true;
    onListeningStateChanged?.call(true);

    await _speech.listen(
      onResult: (result) {
        GLog.d('SttService', 'Result received — final:${result.finalResult} words:"${result.recognizedWords}"');
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
          if (_shouldKeepListening) {
            GLog.i('SttService', 'Restarting mic after command...');
            Future.delayed(const Duration(milliseconds: 300), () {
              _restartListening();
            });
          }
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: false,
      cancelOnError: false,
      listenMode: ListenMode.confirmation,
    );
  }

  void stopForeverListening() {
    GLog.i('SttService', 'Stopping forever listening...');
    _shouldKeepListening = false;
    _isListening = false;
    _speech.stop();
    onListeningStateChanged?.call(false);
  }

  Future<void> startListening() async {
    await startForeverListening();
  }

  void stopListening() {
    stopForeverListening();
  }

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