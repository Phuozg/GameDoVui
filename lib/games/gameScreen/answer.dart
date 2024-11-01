import 'package:flutter/material.dart';

class AnswerOption extends StatefulWidget {
  const AnswerOption({super.key,required this.ans, required this.isSelected,
    required this.onSelected,});
  final String ans;
  final bool isSelected;
  final VoidCallback onSelected;
  @override
  State<AnswerOption> createState() => _AnswerOptionState();
}

class _AnswerOptionState extends State<AnswerOption> {
  @override
  Widget build(BuildContext context) {
   
   return GestureDetector(
      onTap: widget.onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.purple[300] : Colors.purple[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              widget.ans,
              style: TextStyle(
                fontSize: 18,
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}