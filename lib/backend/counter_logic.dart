import 'dart:async';
import 'tts_service.dart';
import 'limit_service.dart';

class CounterLogic {
  final TtsService _tts = TtsService();
  final LimitService _limitService = LimitService();

  Timer? _timer;
  int _counter = 0;
  bool _isRunning = false;

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
    _counter = 0;
    onCountChanged?.call(_counter);
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
    _tts.dispose();
  }
}