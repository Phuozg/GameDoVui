import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/games/gameController.dart';
import 'package:dadd/games/gameScreen/btn_Home.dart';
import 'package:dadd/games/gameScreen/question.dart';
import 'package:dadd/games/notification/rsOneScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class gameScreen extends StatefulWidget {
  gameScreen({super.key, required this.questions, required this.questionSetID});
  List<Question> questions;
  String questionSetID;
  @override
  State<gameScreen> createState() => _gameScreenState();
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

class _gameScreenState extends State<gameScreen> {
  PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _score = 0;
  int time = 15;
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
      });
    } else {
      try {
        GameController().createGame(context, _score,
            FirebaseAuth.instance.currentUser!.uid, widget.questionSetID);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => rsOnescreen(
                      topicID: widget.questions[0].IDTopic,
                      score: _score,
                      quantity: widget.questions.length,
                    )));
      } catch (e) {}
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
              Question question = widget.questions[index];
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
                                  Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        shape:
                                            BoxShape.circle, // Circular shape
                                      ),
                                      child: Text(time.toString(),
                                          style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.none))),
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
                              future: GameController().getOptions(question.ID),
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
