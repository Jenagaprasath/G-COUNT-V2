import 'package:flutter/material.dart';

class VoiceControlButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isListening;

  const VoiceControlButton({
    super.key,
    required this.onTap,
    this.isListening = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isListening
                  ? const Color(0xFF2979FF)
                  : const Color(0xFF1A2E45),
              shape: BoxShape.circle,
              border: Border.all(
                color: isListening
                    ? const Color(0xFF2979FF)
                    : const Color(0xFF2979FF).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: isListening
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2979FF).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: isListening ? Colors.white : const Color(0xFF2979FF),
              size: 32,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isListening
                  ? const Color(0xFF2979FF)
                  : const Color(0xFF8A9BB0),
              fontSize: 12,
              fontWeight: isListening ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 1.5,
            ),
            child: Text(isListening ? 'LISTENING...' : 'VOICE CONTROL'),
          ),
        ],
      ),
    );
  }
}