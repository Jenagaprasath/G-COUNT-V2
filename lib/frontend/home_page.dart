import 'package:flutter/material.dart';
import '../backend/counter_logic.dart';
import 'widgets/counter_display.dart';
import 'widgets/start_stop_button.dart';
import 'widgets/voice_control_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CounterLogic _counterLogic = CounterLogic();
  bool _isRunning = false;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initCounter();
  }

  Future<void> _initCounter() async {
    await _counterLogic.init();

    _counterLogic.onCountChanged = (count) {
      setState(() {
        _counter = count;
      });
    };

    _counterLogic.onLimitReached = () {
      setState(() {
        _isRunning = false;
      });
      _showLimitDialog();
    };
  }

  Future<void> _toggleCounter() async {
    if (_isRunning) {
      await _counterLogic.stop();
      setState(() {
        _isRunning = false;
      });
    } else {
      await _counterLogic.start();
      setState(() {
        _isRunning = true;
      });
    }
  }

  Future<void> _resetCounter() async {
    await _counterLogic.reset();
    setState(() {
      _counter = 0;
      _isRunning = false;
    });
  }

  void _showLimitDialog() {
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
          'Counter has reached the limit of ${_counterLogic.getLimit()}.\n\nYOU HAVE REACHED!!!',
          style: const TextStyle(
            color: Color(0xFF8A9BB0),
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          // RESET BUTTON
          TextButton(
            onPressed: () async {
              _counterLogic.stopLimitAlert();
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
          // OK BUTTON
          TextButton(
            onPressed: () {
              _counterLogic.stopLimitAlert();
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
    );
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
                  // BACK BUTTON
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: Color(0xFF8A9BB0),
                          size: 28,
                        ),
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
                  ),

                  // SET LIMIT BUTTON
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
                              horizontal: 8,
                              vertical: 2,
                            ),
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
              child: Center(
                child: CounterDisplay(counter: _counter),
              ),
            ),

            // START/STOP/RESET BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StartStopButton(
                isRunning: _isRunning,
                onTap: _toggleCounter,
                onReset: _resetCounter,
              ),
            ),

            const SizedBox(height: 40),

            // VOICE CONTROL BUTTON
            VoiceControlButton(
              onTap: () {
                Navigator.pushNamed(context, '/permission');
              },
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}