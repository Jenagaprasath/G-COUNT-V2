import 'package:flutter/material.dart';
import 'widgets/counter_display.dart';
import 'widgets/start_stop_button.dart';
import 'widgets/voice_control_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRunning = false;
  int counter = 0;

  void toggleCounter() {
    setState(() {
      isRunning = !isRunning;
    });
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
                    onTap: () {
                      Navigator.pushNamed(context, '/set-limit');
                    },
                    child: const Text(
                      'SET LIMIT',
                      style: TextStyle(
                        color: Color(0xFF2979FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // COUNTER DISPLAY
            Expanded(
              child: Center(
                child: CounterDisplay(counter: counter),
              ),
            ),

            // START/STOP BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StartStopButton(
                isRunning: isRunning,
                onTap: toggleCounter,
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