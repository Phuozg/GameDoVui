import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/controllers/room_controller.dart';
import 'package:dadd/phuong/views/waiting_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget roomTemplate(BuildContext context, String roomID, String roomName,
    int quantityQuestion, String topic, String userIDOwner) {
  final roomController = Get.put(RoomController());
  int quantityPlayer = 0;
  return GestureDetector(
    onTap: () {
      if (quantityPlayer < 4) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => WaitingRoomScreen(
                    roomName: roomName,
                    quantityQuestion: quantityQuestion,
                    topic: topic,roomID: roomID,)));
      } else {
        SnackBar snackBar = const SnackBar(content: Text('Phòng đã đủ người'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    },
    child: Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(border: Border.all(width: 1), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<Uint8List>(
            future: roomController.displayImageFromBase64(userIDOwner),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return CircleAvatar(
                  backgroundImage: MemoryImage(snapshot.data!),
                  minRadius: 30,
                  maxRadius: 30,
                );
              } else {
                return const CircleAvatar(
                  backgroundImage: AssetImage('assets/image/avatar.jpg'),
                  minRadius: 30,
                  maxRadius: 30,
                );
              }
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phòng: $roomName'),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Player')
                    .where('IDRoom', isEqualTo: roomID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    int count = snapshot.data!.docs.length;
                    quantityPlayer = count;
                    return Text('Người chơi:: $count/4');
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Số lượng câu hỏi: $quantityQuestion'),
              Text('Chủ đề: $topic')
            ],
          ),
        ],
      ),
    ),
  );
}
