import 'package:dadd/phuong/views/waiting_room_screen.dart';
import 'package:flutter/material.dart';

Widget roomTemplate(BuildContext context, String roomName, int quantityPlayer,
    int quantityQuestion, String topic) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => WaitingRoomScreen(
                  roomName: roomName,
                  quantityPlayer: quantityPlayer,
                  quantityQuestion: quantityQuestion,
                  topic: topic)));
    },
    child: Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(border: Border.all(width: 1), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/image/avatar.jpg'),
            maxRadius: 30,
            minRadius: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phòng: $roomName'),
              Text('Người chơi: $quantityPlayer/4')
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
