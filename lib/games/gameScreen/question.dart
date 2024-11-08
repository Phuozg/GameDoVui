import 'package:flutter/material.dart';

class QuestionContent extends StatefulWidget {
  const QuestionContent({super.key, required this.ques});
  final String ques;
  @override
  State<QuestionContent> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionContent> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.2,
      width: screenwidth * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue, // Adjust color accordingly
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.teal, // Border color
          width: 6.0, // Border width
        ),
      ),
      child: Text(
        widget.ques, // Example question text
        style: TextStyle(
            fontSize: 20, color: Colors.white, decoration: TextDecoration.none),
      ),
    );
  }
}
