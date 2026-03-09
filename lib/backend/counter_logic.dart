import 'dart:async';
import 'g_log.dart';
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

  Function(int)? onCountChanged;
  Function()? onLimitReached;

  Future<void> init() async {
    GLog.i('CounterLogic', 'Initializing TTS...');
    await _tts.init();
    GLog.i('CounterLogic', 'TTS initialized');
  }

  Future<void> start() async {
    if (_isRunning) {
      GLog.w('CounterLogic', 'Already running — ignoring start()');
      return;
    }
    GLog.i('CounterLogic', 'Counter STARTED at $_counter');
    _isRunning = true;

    await _tts.speak(_counter.toString());

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      _counter++;
      GLog.d('CounterLogic', 'Counter tick → $_counter');
      onCountChanged?.call(_counter);
      await _tts.speak(_counter.toString());

      if (_limitService.isLimitSet() &&
          _counter >= _limitService.getLimit()) {
        GLog.i('CounterLogic',
            'LIMIT REACHED at $_counter (limit: ${_limitService.getLimit()})');
        await stop();
        onLimitReached?.call();
        _startLimitAlert();
      }
    });
  }

  Future<void> stop() async {
    GLog.i('CounterLogic', 'Counter STOPPED at $_counter');
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    await _tts.stop();
  }

  Future<void> reset() async {
    GLog.i('CounterLogic', 'Counter RESET from $_counter to 0');
    await stop();
    stopLimitAlert();
    _counter = 0;
    onCountChanged?.call(_counter);
  }

  void _startLimitAlert() {
    GLog.i('CounterLogic', 'Starting limit alert audio loop...');
    _isAlertActive = true;
    _speakAlert();
    _alertTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isAlertActive) {
        GLog.d('CounterLogic', 'Alert repeating...');
        _speakAlert();
      } else {
        GLog.i('CounterLogic', 'Alert stopped — cancelling timer');
        timer.cancel();
      }
    });
  }

  Future<void> _speakAlert() async {
    if (_isAlertActive) {
      GLog.d('CounterLogic', 'Speaking alert: YOU HAVE REACHED!!!');
      await _tts.speak('YOU HAVE REACHED!!!');
    }
  }

  void stopLimitAlert() {
    GLog.i('CounterLogic', 'Stopping limit alert');
    _isAlertActive = false;
    _alertTimer?.cancel();
    _alertTimer = null;
    _tts.stop();
  }

  void setLimit(int limit) {
    GLog.i('CounterLogic', 'Limit set to: $limit');
    _limitService.setLimit(limit);
  }

  int getLimit() => _limitService.getLimit();
  bool isLimitSet() => _limitService.isLimitSet();

  void dispose() {
    GLog.i('CounterLogic', 'Disposing CounterLogic');
    _timer?.cancel();
    _alertTimer?.cancel();
    _tts.dispose();
  }
}