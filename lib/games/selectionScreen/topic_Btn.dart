import 'package:flutter/material.dart';

class btn_Topic extends StatefulWidget {
  final String topic;
  final bool isSelected;
  final VoidCallback onTap;

  const btn_Topic({
    super.key,
    required this.topic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<btn_Topic> createState() => _btn_TopicState();
}

class _btn_TopicState extends State<btn_Topic> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap, // Call the onTap callback passed from the parent
        child: LayoutBuilder(builder: (context, constraints) {
          double size = constraints.maxWidth; // Set size based on max width

          return Container(
            width: size, // Set width
            height: size, // Set height equal to width for a square
            alignment: Alignment.center,
            padding:
                EdgeInsets.all(size * 0.1), // Adjust padding proportionally
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.yellow.shade700
                  : Colors.orange.shade300,
              borderRadius: BorderRadius.circular(8),
              border: widget.isSelected
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            ),
            child: Text(
              widget.topic,
              style: TextStyle(fontSize: size * 0.2, color: Colors.black, decoration: TextDecoration.none),
              textAlign: TextAlign.center, 
            ),
          );
        }));
  }
}
