import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

enum VoiceCommand { start, stop, reset, ok, unknown }

class SttService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;

  // Callback when command detected
  Function(VoiceCommand)? onCommandDetected;

  Future<bool> init() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    _isInitialized = await _speech.initialize(
      onError: (error) {
        _isListening = false;
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
    );

    return _isInitialized;
  }

  Future<void> startListening() async {
    if (!_isInitialized || _isListening) return;

    _isListening = true;

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          final words = result.recognizedWords.toUpperCase().trim();
          final command = _parseCommand(words);
          if (command != VoiceCommand.unknown) {
            onCommandDetected?.call(command);
          }
          // Audio is processed and discarded — never saved
          stopListening();
        }
      },
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 2),
      partialResults: false,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
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
    _speech.stop();
  }
}