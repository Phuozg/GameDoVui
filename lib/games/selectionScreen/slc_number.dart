import 'package:flutter/material.dart';

class slc_numbers extends StatefulWidget {
  const slc_numbers({super.key});

  @override
  State<slc_numbers> createState() => _slc_numbersState();
}

class _slc_numbersState extends State<slc_numbers> {
  int _questionCount = 10;
  final List<int> _questionOptions = [10, 20, 30];

  void _changeQuestionCount() {
    setState(() {
      int currentIndex = _questionOptions.indexOf(_questionCount);
      int nextIndex = (currentIndex + 1) % _questionOptions.length;
      _questionCount = _questionOptions[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    
        Text(
          'Số Câu Hỏi',
          style: TextStyle(decoration: TextDecoration.none,
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: _changeQuestionCount,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_questionCount',
              style: TextStyle(fontSize: 24, color: Colors.white, decoration: TextDecoration.none),
            ),
          ),
        ),
      ],
    );
  }
}
