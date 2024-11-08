import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/games/gameController.dart';
import 'package:dadd/games/gameScreen/game_Sceen.dart';
import 'package:dadd/games/selectionScreen/home_btn.dart';
import 'package:dadd/games/selectionScreen/topic_Btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class slc_Screen extends StatefulWidget {
  const slc_Screen({super.key});

  @override
  State<slc_Screen> createState() => _slc_ScreenState();
}

//class chủ đề
class Topic {
  final String ID;
  final String TopicName;
  Topic({required this.ID, required this.TopicName});
  factory Topic.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Topic(
      ID: doc.id,
      TopicName: data['TopicName'],
    );
  }
}

//Lấy danh sách chủ đề từ Firestore
Future<List<Topic>> getTopics() async {
  List<Topic> topics = [];
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Topic').get();
    for (var doc in querySnapshot.docs) {
      topics.add(Topic.fromFirestore(doc));
    }
  } catch (e) {
    print('Lỗi: $e');
  }
  return topics;
}

class _slc_ScreenState extends State<slc_Screen> {
  int _questionCount = 10;
  final List<int> _questionOptions = [10, 20, 30];

  void _changeQuestionCount() {
    setState(() {
      int currentIndex = _questionOptions.indexOf(_questionCount);
      int nextIndex = (currentIndex + 1) % _questionOptions.length;
      _questionCount = _questionOptions[nextIndex];
    });
  }

  List<int> listQuantity = [10, 20, 30];
  int dropdownQuantityValue = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      // ngăn xếp

      children: [
        SizedBox.expand(
            child: Image.asset(
          'assets/image/background.jpg',
          fit: BoxFit.cover,
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                trangcu_btn()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    'Số Câu Hỏi',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  color: Colors.white,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: dropdownQuantityValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black54,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        dropdownQuantityValue = value!;
                      });
                    },
                    items: listQuantity.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  Text(
                    'Chọn Chủ Đề',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.6, // 60% of screen height
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal.shade300,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: EdgeInsets.all(10),
                      child: FutureBuilder<List<Topic>>(
                        future: getTopics(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<Topic> topics = snapshot.data!;
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: topics.length,
                              itemBuilder: (context, index) {
                                Topic topic = topics[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: btn_Topic(
                                      topic: topic.TopicName,
                                      onTap: () {
                                        try {
                                          GameController().createRoom(
                                              context,
                                              topic.ID,
                                              dropdownQuantityValue,
                                              FirebaseAuth
                                                  .instance.currentUser!.uid);
                                        } catch (e) {}
                                      }),
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: Text('No topics found.'));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
