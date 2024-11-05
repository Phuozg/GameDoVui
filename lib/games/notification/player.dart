import 'package:flutter/material.dart';

class caPlayer extends StatefulWidget {
  const caPlayer(
      {super.key,
      required this.rank,
      required this.name,
      required this.score,
      required this.color});
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
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
                child: Text(widget.rank,
                    style: const TextStyle(
                        color: Colors.white, decoration: TextDecoration.none)),
              ),
              const SizedBox(width: 10),
              Text(
                widget.name,
                style: const TextStyle(
                    fontSize: 15, decoration: TextDecoration.none),
              ),
            ],
          ),
          Text(widget.score,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  decoration: TextDecoration.none)),
        ],
      ),
    );
  }
}
