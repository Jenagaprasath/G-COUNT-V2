import 'package:flutter/material.dart';

class StartStopButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onTap;

  const StartStopButton({
    super.key,
    required this.isRunning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF2979FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            isRunning ? 'STOP' : 'START',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}