import 'dart:math';

import 'package:dadd/admin/controller.dart';
import 'package:dadd/admin/detail_screen.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    //Hiển thị họp thoại thêm câu hỏi
    showAddDialog() {
      List<TopicModel> topics = controller.topics;
      TopicModel selectedTopic = topics[0];
      TextEditingController content = TextEditingController();
      showDialog(
          context: context,
          builder: (_) => StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text('Tạo câu hỏi mới')),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: DropdownButton<TopicModel>(
                              isExpanded: true,
                              value: selectedTopic,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black54,
                              ),
                              onChanged: (TopicModel? value) {
                                setState(() {
                                  selectedTopic = value!;
                                });
                              },
                              items: topics.map((TopicModel topic) {
                                return DropdownMenuItem<TopicModel>(
                                  value: topic,
                                  child: Text(topic.TopicName),
                                );
                              }).toList()),
                        ),
                        TextField(
                          controller: content,
                          decoration: InputDecoration(
                              label: Text(
                                'Nội dung câu hỏi',
                              ),
                              border: OutlineInputBorder()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  final questionID = generateRandomString();
                                  setState(() {
                                    controller.addQuestion(content.text,
                                        selectedTopic.ID, questionID);
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => DetailQuestion(
                                                questionID: questionID,
                                                questionContent: content.text,
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text(
                                  'Tạo câu hỏi',
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text('Quản lý câu hỏi'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountScreen()));
                },
                icon: const Icon(Icons.person_outline))
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover)),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      showAddDialog();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'Thêm câu hỏi',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: FutureBuilder<List<QuestionModel>>(
                      future: Controller().getQuestion(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          Controller().getQuestion();
                          List<QuestionModel> questions = snapshot.data!;
                          return ListView.builder(
                            itemCount: questions.length,
                            itemBuilder: (context, index) {
                              QuestionModel question = questions[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => DetailQuestion(
                                              questionID: question.ID,
                                              questionContent:
                                                  question.Content)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Column(
                                          children: [
                                            Text(
                                                "Chủ đề: ${controller.getTopicName(question.IDTopic)}"),
                                            Text(
                                              question.Content,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Không tìm thấy chủ đề nào.'));
                        }
                      },
                    ))
              ],
            ),
          ),
        ));
  }

  String generateRandomString() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      20,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }
}
