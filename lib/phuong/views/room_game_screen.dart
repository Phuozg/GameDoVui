import 'package:dadd/phuong/controllers/question_set_controller.dart';
import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/controllers/topic_controller.dart';
import 'package:dadd/phuong/models/room_model.dart';
import 'package:dadd/phuong/models/topic_model.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:dadd/phuong/views/room_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomGameScreen extends StatelessWidget {
  const RoomGameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final RoomController roomController = Get.put(RoomController());
    final TopicController topicController = Get.put(TopicController());
    final QuestionSetController questionSetController =
        Get.put(QuestionSetController());
    final userID = FirebaseAuth.instance.currentUser!.uid;
    showSearchRoomDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(child: Text('Tìm phòng')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                            labelText: 'Nhập mã phòng',
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              child: const Text(
                                'Tìm',
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
              ));
    }

    showCreateRoomDialog(BuildContext context) {
      List<TopicModel> topics = topicController.topics;
      TopicModel selectedTopic = topics[0];
      List<int> listQuantity = [10, 20, 30];
      int dropdownQuantityValue = listQuantity.first;
      showDialog(
          context: context,
          builder: (_) => StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text('Tạo phòng')),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
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
                            items: listQuantity
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  roomController.createRoom(
                                      context,
                                      selectedTopic.ID,
                                      dropdownQuantityValue,
                                      userID);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text(
                                  'Tạo phòng',
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
        title: const Text('Phòng'),
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
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 80),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Obx(() {
                    if (roomController.rooms.isEmpty) {
                      return const Center(
                        child: Text('Không có phòng chơi nào'),
                      );
                    }
                    return ListView.builder(
                      itemCount: roomController.rooms.length,
                      itemBuilder: (_, index) {
                        RoomModel room = roomController.rooms[index];
                        return roomTemplate(
                            context,
                            room.ID,
                            room.Code,
                            questionSetController
                                .getQuantityQuestion(room.IDQuestionSet),
                            topicController.getTopicName(room.IDTopic),
                            room.IDOwner,
                            room.IDQuestionSet);
                      },
                    );
                  })),
              ElevatedButton(
                  onPressed: () {
                    showSearchRoomDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text(
                    'Tìm phòng',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
              ElevatedButton(
                  onPressed: () {
                    showCreateRoomDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text(
                    'Tạo phòng',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
