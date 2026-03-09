import 'package:flutter/material.dart';
import '../backend/counter_logic.dart';
import '../backend/g_log.dart';
import 'widgets/counter_display.dart';
import 'widgets/start_stop_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CounterLogic _counterLogic = CounterLogic();
  bool _isRunning = false;
  bool _isLimitDialogOpen = false;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    GLog.i('HomePage', 'Initializing services...');
    await _counterLogic.init();

    _counterLogic.onCountChanged = (count) {
      if (mounted) {
        setState(() {
          _counter = count;
        });
      }
    };

    _counterLogic.onLimitReached = () {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
        _showLimitDialog();
      }
    };

    GLog.i('HomePage', 'Services initialized');
  }

  Future<void> _toggleCounter() async {
    if (_isRunning) {
      await _counterLogic.stop();
      setState(() => _isRunning = false);
    } else {
      await _counterLogic.start();
      setState(() => _isRunning = true);
    }
  }

  Future<void> _resetCounter() async {
    await _counterLogic.reset();
    if (mounted) {
      setState(() {
        _counter = 0;
        _isRunning = false;
      });
    }
  }

  void _showLimitDialog() {
    _isLimitDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF112233),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '🎯 Limit Reached!!!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Counter reached ${_counterLogic.getLimit()}.',
          style: const TextStyle(
            color: Color(0xFF8A9BB0),
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              _counterLogic.stopLimitAlert();
              _isLimitDialogOpen = false;
              Navigator.pop(context);
              await _resetCounter();
            },
            child: const Text(
              'RESET',
              style: TextStyle(
                color: Color(0xFF2979FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _counterLogic.stopLimitAlert();
              _isLimitDialogOpen = false;
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).then((_) => _isLimitDialogOpen = false);
  }

  Future<void> _openSetLimit() async {
    final result = await Navigator.pushNamed(context, '/set-limit');
    if (result != null && result is int) {
      _counterLogic.setLimit(result);
      setState(() {});
    }
  }

  @override
  void dispose() {
    GLog.i('HomePage', 'Disposing HomePage');
    _counterLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chevron_left,
                          color: Color(0xFF8A9BB0), size: 28),
                      Text(
                        'BACK',
                        style: TextStyle(
                          color: Color(0xFF8A9BB0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _openSetLimit,
                    child: Row(
                      children: [
                        const Text(
                          'SET LIMIT',
                          style: TextStyle(
                            color: Color(0xFF2979FF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        if (_counterLogic.isLimitSet())
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2979FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_counterLogic.getLimit()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // COUNTER DISPLAY
            Expanded(
              child: Center(child: CounterDisplay(counter: _counter)),
            ),

            // START / STOP / RESET
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StartStopButton(
                isRunning: _isRunning,
                onTap: _toggleCounter,
                onReset: _resetCounter,
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}