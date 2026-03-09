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

  // Callback when command detected
  Function(VoiceCommand)? onCommandDetected;
  Function(bool)? onListeningStateChanged;

  Future<bool> init() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onError: (error) {
        // Auto restart on error if should keep listening
        if (_shouldKeepListening) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _restartListening();
          });
        }
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          onListeningStateChanged?.call(false);
          // Auto restart if should keep listening
          if (_shouldKeepListening) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _restartListening();
            });
          }
        }
      },
    );

    return _isInitialized;
  }

  // Start forever listening mode
  Future<void> startForeverListening() async {
    if (!_isInitialized) return;
    _shouldKeepListening = true;
    await _restartListening();
  }

  Future<void> _restartListening() async {
    if (!_shouldKeepListening || _isListening) return;

    _isListening = true;
    onListeningStateChanged?.call(true);

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          final words = result.recognizedWords.toUpperCase().trim();
          if (words.isNotEmpty) {
            final command = _parseCommand(words);
            if (command != VoiceCommand.unknown) {
              onCommandDetected?.call(command);
            }
          }
          // After result — restart listening immediately
          _isListening = false;
          if (_shouldKeepListening) {
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

  // Stop forever listening — only called when user leaves app
  void stopForeverListening() {
    _shouldKeepListening = false;
    _isListening = false;
    _speech.stop();
    onListeningStateChanged?.call(false);
  }

  // Legacy single listen — kept for compatibility
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
    if (words.contains('OK') || words.contains('OKAY')) {
      return VoiceCommand.ok;
    }
    return VoiceCommand.unknown;
  }

  void dispose() {
    stopForeverListening();
    _speech.cancel();
  }
}