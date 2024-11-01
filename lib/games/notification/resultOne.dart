import 'package:flutter/material.dart';


class rsBoardone extends StatefulWidget {
  const rsBoardone({super.key, required this.rScore, required this.wScore, required this.score});
  final String rScore;
  final String wScore;
  final String score;

  @override
  State<rsBoardone> createState() => _rsBoardoneState();
}

class _rsBoardoneState extends State<rsBoardone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Kết quả',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
          ),
          SizedBox(height: 16),
          Text(
            'Chúc mừng bạn đã hoàn thành trò chơi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black,  decoration: TextDecoration.none),
          ),SizedBox(height: 16),
          Text(
            'Số câu đúng: ${widget.rScore}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,  decoration: TextDecoration.none),
          ),
          Text(
            'Số câu sai: ${widget.wScore}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,  decoration: TextDecoration.none),
          ),
          Text(
            'Số điểm: ${widget.score}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,  decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
