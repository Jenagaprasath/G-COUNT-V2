import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int counter;

  const CounterDisplay({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$counter',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 120,
        fontWeight: FontWeight.bold,
        height: 1.0,
      ),
    );
  }
}