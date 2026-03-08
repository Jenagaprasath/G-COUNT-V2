import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspace;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onBackspace,
  });

  Widget _buildKey(String label, {VoidCallback? onTap, bool isBackspace = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF112233),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isBackspace
                ? const Icon(
                    Icons.backspace_outlined,
                    color: Colors.white,
                    size: 22,
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _buildKey('1', onTap: () => onNumberTap('1')),
              _buildKey('2', onTap: () => onNumberTap('2')),
              _buildKey('3', onTap: () => onNumberTap('3')),
            ],
          ),
          Row(
            children: [
              _buildKey('4', onTap: () => onNumberTap('4')),
              _buildKey('5', onTap: () => onNumberTap('5')),
              _buildKey('6', onTap: () => onNumberTap('6')),
            ],
          ),
          Row(
            children: [
              _buildKey('7', onTap: () => onNumberTap('7')),
              _buildKey('8', onTap: () => onNumberTap('8')),
              _buildKey('9', onTap: () => onNumberTap('9')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              _buildKey('0', onTap: () => onNumberTap('0')),
              _buildKey('', onTap: onBackspace, isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }
}