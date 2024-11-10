import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/controllers/topic_controller.dart';
import 'package:dadd/phuong/models/topic_model.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:dadd/phuong/views/count_down_screen.dart';
import 'package:dadd/phuong/views/player_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen(
      {super.key,
      required this.roomName,
      required this.quantityQuestion,
      required this.topic,
      required this.roomID,
      required this.idOwner,
      required this.questionSetID});
  final String roomName;
  final int quantityQuestion;
  final String topic;
  final String roomID;
  final String idOwner;
  final String questionSetID;
  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  final roomController = Get.put(RoomController());
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<DocumentSnapshot> roomStream;
  @override
  void initState() {
    super.initState();
    roomStream = FirebaseFirestore.instance
        .collection('Room')
        .doc(widget.roomID)
        .snapshots();
  }

  void startGame() async {
    await roomController.generateRandomQuestion(
        widget.topic, widget.quantityQuestion);
    await FirebaseFirestore.instance
        .collection('Room')
        .doc(widget.roomID)
        .update({'Status': false});
  }

  @override
  Widget build(BuildContext context) {
    List<int> listQuantity = [10, 20, 30];
    int dropdownQuantityValue = widget.quantityQuestion;
    final topicController = Get.put(TopicController());
    List<TopicModel> topics = topicController.topics;
    TopicModel selectedTopic = topics[0];
    roomController.fetchDataRoom(widget.roomID);

    showConfirm() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text(
                  'Bạn là chủ phòng, nếu bạn thoát sẽ đóng phòng chơi'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    const Text('Bạn có chắc chắn muốn thoát?'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  roomController.ownerOutRoom(widget.roomID);
                                  roomController.fetchData();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  SnackBar snackBar = const SnackBar(
                                      content: Text(
                                          "Có lỗi xảy ra vui lòng thử lại"));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              child: const Text(
                                'Xác nhận',
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
                        ])
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('Phòng ${widget.roomName}'),
        leading: IconButton(
            onPressed: () async {
              try {
                if (FirebaseAuth.instance.currentUser!.uid == widget.idOwner) {
                  showConfirm();
                } else {
                  await roomController.deletePlayerWhenUserOutRoom(
                      FirebaseAuth.instance.currentUser!.uid, widget.idOwner);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              } catch (e) {
                SnackBar snackBar = const SnackBar(
                    content: Text("Có lỗi xảy ra vui lòng thử lại"));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            icon: const Icon(Icons.arrow_back)),
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
      body: PopScope(
          canPop: false,
          child: StreamBuilder(
              stream: roomStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var roomData = snapshot.data!.data() as Map<String, dynamic>;
                var gameState = roomData['Status'];
                if (gameState == false) {
                  return CountdownScreen(
                    questionSetID: widget.questionSetID,
                    roomID: roomData['ID'],
                  );
                }
                return Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image/background.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  if (FirebaseAuth.instance.currentUser!.uid ==
                                      widget.idOwner) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: DropdownButton<TopicModel>(
                                              isExpanded: true,
                                              value: selectedTopic,
                                              icon: const Icon(
                                                  Icons.arrow_downward),
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.black54,
                                              ),
                                              onChanged: (TopicModel? value) {
                                                setState(() {
                                                  selectedTopic = value!;
                                                  roomController.changeTopic(
                                                      selectedTopic.ID,
                                                      widget.questionSetID);
                                                });
                                              },
                                              items: topics
                                                  .map((TopicModel topic) {
                                                return DropdownMenuItem<
                                                    TopicModel>(
                                                  value: topic,
                                                  child: Text(topic.TopicName),
                                                );
                                              }).toList()),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: 30,
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            value: dropdownQuantityValue,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            onChanged: (int? value) {
                                              setState(() {
                                                dropdownQuantityValue = value!;
                                                roomController
                                                    .changeQuantityQuestion(
                                                        dropdownQuantityValue,
                                                        widget.questionSetID);
                                              });
                                            },
                                            items: listQuantity
                                                .map<DropdownMenuItem<int>>(
                                                    (int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }))
                          ],
                        ),
                        Obx(() {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: ListView.builder(
                                  itemCount: roomController.userIDs.length,
                                  itemBuilder: (builder, index) {
                                    return playerTemplate(
                                        context,
                                        roomController.allusers[index],
                                        widget.idOwner);
                                  }));
                        }),
                        Builder(builder: (context) {
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              widget.idOwner) {
                            return ElevatedButton(
                                onPressed: startGame,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(200, 40)),
                                child: const Text(
                                  'Bắt đầu',
                                  style: TextStyle(color: Colors.white),
                                ));
                          } else {
                            return Container();
                          }
                        })
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
