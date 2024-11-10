import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/games/gameScreen/btn_Home.dart';
import 'package:dadd/games/gameScreen/question.dart';
import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/models/question_model.dart';
import 'package:dadd/phuong/views/result_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(
      {super.key,
      required this.questions,
      required this.questionSetID,
      required this.roomID});
  final List<QuestionModel> questions;
  final String questionSetID;
  final String roomID;
  @override
  State<GameScreen> createState() => _gameScreenState();
}

class OptionModel {
  String ID;
  String IDQuestion;
  String Content;
  bool Accuracy;
  OptionModel(
      {required this.ID,
      required this.IDQuestion,
      required this.Content,
      required this.Accuracy});
  factory OptionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OptionModel(
        ID: data['ID'],
        IDQuestion: data['IDQuestion'],
        Content: data['Content'],
        Accuracy: data['Accuracy']);
  }
}

class _gameScreenState extends State<GameScreen> {
  PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _time = 15;
  late StreamController<int> _timerStreamController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timerStreamController = StreamController<int>.broadcast();
    startTimer();
  }

  @override
  void dispose() {
    _timerStreamController.close();
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_time > 0) {
        _time--;
        _timerStreamController.add(_time);
      } else {
        _nextQuestion(false);
        _time = 15; // Reset timer for the next question
        _timerStreamController.add(_time);
      }
    });
  }

  void _nextQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _score++;
      });
    }
    if (_currentQuestionIndex < widget.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentQuestionIndex++;
        _time = 15; // Reset timer for the next question
      });
      _timerStreamController.add(_time);
    } else {
      try {
        RoomController().createGame(
            context,
            _score,
            FirebaseAuth.instance.currentUser!.uid,
            widget.questionSetID,
            Timestamp.now());
        RoomController().changeStatusPlayer(
            FirebaseAuth.instance.currentUser!.uid, widget.roomID);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Result(
                      roomID: widget.roomID,
                      questionSetID: widget.questionSetID,
                    )));
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  String? _selectedOptionId;
  void _selectOption(OptionModel option) {
    setState(() {
      _selectedOptionId = option.ID;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _selectedOptionId = null;
        _nextQuestion(option.Accuracy);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Image.asset(
            'assets/image/background.jpg',
            fit: BoxFit.cover,
          )),
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              QuestionModel question = widget.questions[index];
              return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  btn_Home()
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  StreamBuilder<int>(
                                    stream: _timerStreamController.stream,
                                    initialData: _time,
                                    builder: (context, snapshot) {
                                      return Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              snapshot.data.toString(),
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ));
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          QuestionContent(ques: question.Content),
                          SizedBox(
                            height: 400,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FutureBuilder<List<OptionModel>>(
                              future: RoomController().getOptions(question.ID),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  List<OptionModel> options = snapshot.data!;
                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      OptionModel option = options[index];
                                      Color backgroundColor =
                                          const Color.fromARGB(
                                              255, 228, 163, 240);
                                      if (_selectedOptionId == option.ID) {
                                        backgroundColor = option.Accuracy
                                            ? Colors.green
                                            : Colors.red;
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (_selectedOptionId == null) {
                                            _selectOption(option);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.5),
                                          child: Container(
                                            height: 80,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                                child: Text(
                                              option.Content,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child:
                                          Text('Không tìm thấy câu trả lời.'));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ));
            },
          ),
        ],
      ),
    );
  }
}
