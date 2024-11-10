import 'dart:async';
import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/views/game_multi_sceen.dart';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen(
      {super.key, required this.questionSetID, required this.roomID});
  final String questionSetID;
  final String roomID;
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late int _counter;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _counter = 5;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 1) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GameScreen(
                      questions: RoomController.instance.questions,
                      questionSetID: widget.questionSetID,
                      roomID: widget.roomID,
                    )));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$_counter',
          style: TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
