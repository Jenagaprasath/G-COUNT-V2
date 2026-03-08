import 'package:flutter/material.dart';

class VoiceControlButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoiceControlButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2E45),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2979FF).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.mic,
              color: Color(0xFF2979FF),
              size: 32,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'VOICE CONTROL',
            style: TextStyle(
              color: Color(0xFF8A9BB0),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}