import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/controllers/profile_controller.dart';
import 'package:dadd/phuong/controllers/result_controller.dart';
import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Result extends StatefulWidget {
  const Result({super.key, required this.roomID, required this.questionSetID});
  final String roomID;
  final String questionSetID;
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Stream<QuerySnapshot> playerStream;
  @override
  void initState() {
    super.initState();
    playerStream = FirebaseFirestore.instance.collection('Player').snapshots();
  }

  void markAsFinished(String playerID) async {
    final db = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await db
          .collection('Player')
          .where('IDUser', isEqualTo: playerID)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await db.collection('Player').doc(doc.id).delete();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void checkIfAllFinished(QuerySnapshot snapshot) {
    bool allFinished = snapshot.docs.every((doc) => doc['Status'] == true);
    if (allFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultScreen(questionSetID: widget.questionSetID)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: playerStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            checkIfAllFinished(snapshot.data!);
          });
          return const Center(
              child: Column(
            children: [
              CircularProgressIndicator(),
              Text('Đợi tất cả người chơi hoàn thành để hiển thị kết quả')
            ],
          ));
        },
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.questionSetID});

  final String questionSetID;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultController());
    controller.fetchData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kết quả'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/background.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 80),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Game')
                .where('IDQuestionset', isEqualTo: widget.questionSetID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var games = snapshot.data!.docs.map((doc) => doc.data()).toList();
              return ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  var game = games[index] as Map<String, dynamic>;
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all()),
                      child: Row(
                        children: [
                          Builder(builder: (context) {
                            if (controller
                                .getUserName(game['IDUser'])
                                .Avatar
                                .isEmpty) {
                              return const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/image/avatar.jpg'),
                                minRadius: 50,
                                maxRadius: 100,
                              );
                            } else {
                              return CircleAvatar(
                                backgroundImage: MemoryImage(ProfileController()
                                    .displayImageFromBase64(controller
                                        .getUserName(game['IDUser'])
                                        .Avatar)),
                                minRadius: 30,
                                maxRadius: 30,
                              );
                            }
                          }),
                          Column(
                            children: [
                              Text(
                                  'Người chơi: ${controller.getUserName(game['IDUser']).Name}'),
                              Text('Số câu đúng: ${game['Point']}'),
                            ],
                          ),
                        ],
                      ));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
