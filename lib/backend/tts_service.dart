import 'package:flutter_tts/flutter_tts.dart';
import 'g_log.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    GLog.i('TtsService', 'Initializing TTS...');
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    GLog.i('TtsService', 'TTS ready');
  }

  Future<void> speak(String text) async {
    GLog.d('TtsService', 'Speaking: "$text"');
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    GLog.d('TtsService', 'TTS stopped');
    await _flutterTts.stop();
  }

  void dispose() {
    GLog.i('TtsService', 'Disposing TTS');
    _flutterTts.stop();
  }
}