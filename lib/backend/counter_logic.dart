import 'dart:async';
import 'tts_service.dart';
import 'limit_service.dart';

class CounterLogic {
  final TtsService _tts = TtsService();
  final LimitService _limitService = LimitService();

  Timer? _timer;
  Timer? _alertTimer;
  int _counter = 0;
  bool _isRunning = false;
  bool _isAlertActive = false;

  int get counter => _counter;
  bool get isRunning => _isRunning;

  // Callbacks
  Function(int)? onCountChanged;
  Function()? onLimitReached;

  Future<void> init() async {
    await _tts.init();
  }

  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;

    // Speak current counter immediately on start
    await _tts.speak(_counter.toString());

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      _counter++;
      onCountChanged?.call(_counter);

      // Speak the number
      await _tts.speak(_counter.toString());

      // Check limit
      if (_limitService.isLimitSet() &&
          _counter >= _limitService.getLimit()) {
        await stop();
        onLimitReached?.call();
        _startLimitAlert();
      }
    });
  }

  Future<void> stop() async {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    await _tts.stop();
  }

  Future<void> reset() async {
    await stop();
    stopLimitAlert();
    _counter = 0;
    onCountChanged?.call(_counter);
  }

  // Start repeating "YOU HAVE REACHED" alert
  void _startLimitAlert() {
    _isAlertActive = true;
    _speakAlert();
    _alertTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isAlertActive) {
        _speakAlert();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _speakAlert() async {
    if (_isAlertActive) {
      await _tts.speak('YOU HAVE REACHED!!!');
    }
  }

  // Call this when user clicks OK or RESET on the dialog
  void stopLimitAlert() {
    _isAlertActive = false;
    _alertTimer?.cancel();
    _alertTimer = null;
    _tts.stop();
  }

  void setLimit(int limit) {
    _limitService.setLimit(limit);
  }

  int getLimit() {
    return _limitService.getLimit();
  }

  bool isLimitSet() {
    return _limitService.isLimitSet();
  }

  void dispose() {
    _timer?.cancel();
    _alertTimer?.cancel();
    _tts.dispose();
  }
}