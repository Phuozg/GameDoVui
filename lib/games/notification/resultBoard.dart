import 'package:dadd/games/notification/player.dart';
import 'package:flutter/material.dart';

class rsBoard extends StatefulWidget {
  const rsBoard({super.key});

  @override
  State<rsBoard> createState() => _rsBoardState();
}

class _rsBoardState extends State<rsBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Kết quả',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
          SizedBox(height: 16),
          caPlayer(
              rank: 'I', name: 'Nguyễn Văn A', score: '123', color: Colors.red),
          caPlayer(
              rank: 'II',
              name: 'Nguyễn Văn B',
              score: '120',
              color: Colors.green),
          caPlayer(
              rank: 'III',
              name: 'Nguyễn Văn C',
              score: '110',
              color: Colors.yellow),
          caPlayer(
              rank: 'IV',
              name: 'Nguyễn Văn D',
              score: '100',
              color: Colors.blue)
        ],
      ),
    );
  }
}
