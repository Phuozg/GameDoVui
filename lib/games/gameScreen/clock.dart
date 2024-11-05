import 'package:dadd/games/gameScreen/timer.dart';
import 'package:flutter/material.dart';

class cdTimer extends StatefulWidget {
  const cdTimer({super.key});

  @override
  State<cdTimer> createState() => _cdTimerState();
}

class _cdTimerState extends State<cdTimer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle, // Circular shape
      ),
      child: const CountdownTimer(),
    );
  }
}
