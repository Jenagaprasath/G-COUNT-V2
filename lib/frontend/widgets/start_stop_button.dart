import 'package:flutter/material.dart';

class StartStopButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onTap;
  final VoidCallback? onReset;

  const StartStopButton({
    super.key,
    required this.isRunning,
    required this.onTap,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    if (isRunning) {
      // RUNNING STATE — STOP + RESET side by side
      return Row(
        children: [
          // STOP BUTTON
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2979FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'STOP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // RESET BUTTON
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onReset,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2E45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2979FF).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'RESET',
                    style: TextStyle(
                      color: Color(0xFF2979FF),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // STOPPED STATE — START button full width
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF2979FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'START',
            style: TextStyle(
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