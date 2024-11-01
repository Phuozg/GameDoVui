import 'package:flutter/material.dart';

Widget playerTemplate(
    BuildContext context, String name, int level, String userID) {
  return Container(
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
        Text('Tên: $name'),
        Text('Cấp độ: $level'),
        Builder(builder: (_) {
          if (userID == '1') {
            return const Text('Chủ phòng');
          } else {
            return const Text('');
          }
        })
      ],
    ),
  );
}
