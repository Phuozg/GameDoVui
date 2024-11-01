import 'package:flutter/material.dart';


class caPlayer extends StatefulWidget {
  const caPlayer({super.key, required this.rank, required this.name, required this.score, required this.color});
  final String rank;
  final String name;
  final String score;
  final Color color;

  @override
  State<caPlayer> createState() => _caPlayerState();
}

class _caPlayerState extends State<caPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.color,
                child: Text(widget.rank, style: TextStyle(color: Colors.white,  decoration: TextDecoration.none)),
              ),
              SizedBox(width: 10),
              Text(widget.name, style: TextStyle(fontSize: 15,  decoration: TextDecoration.none),),
            ],
          ),
          Text(widget.score, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,  decoration: TextDecoration.none)),
        ],
      ),
    );
  }
}