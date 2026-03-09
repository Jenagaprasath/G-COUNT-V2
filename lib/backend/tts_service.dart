import 'package:flutter_tts/flutter_tts.dart';
import 'g_log.dart';
import 'stt_service.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  // Reference to STT so TTS can mute/unmute it
  SttService? sttService;

  Future<void> init() async {
    GLog.i('TtsService', 'Initializing TTS...');
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // When TTS finishes speaking → unmute STT
    _flutterTts.setCompletionHandler(() {
      GLog.d('TtsService', 'TTS completed — unmuting STT');
      sttService?.unmuteAfterSpeaking();
    });

    GLog.i('TtsService', 'TTS ready');
  }

  Future<void> speak(String text) async {
    GLog.d('TtsService', 'Speaking: "$text"');

    // Mute STT before speaking
    sttService?.muteWhileSpeaking();

    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    GLog.d('TtsService', 'TTS stopped');
    await _flutterTts.stop();
    // Unmute STT when TTS stops
    sttService?.unmuteAfterSpeaking();
  }

  void dispose() {
    GLog.i('TtsService', 'Disposing TTS');
    _flutterTts.stop();
  }
}