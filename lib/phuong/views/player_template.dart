import 'package:dadd/phuong/controllers/profile_controller.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget playerTemplate(BuildContext context, UserModel user, String idOwner) {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(8),
    decoration:
        BoxDecoration(border: Border.all(width: 1), color: Colors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(builder: (context) {
          if (user.Avatar.isEmpty) {
            return const CircleAvatar(
              backgroundImage: AssetImage('assets/image/avatar.jpg'),
              minRadius: 30,
              maxRadius: 30,
            );
          } else {
            return CircleAvatar(
              backgroundImage: MemoryImage(ProfileController.instance
                  .displayImageFromBase64(user.Avatar)),
              minRadius: 30,
              maxRadius: 30,
            );
          }
        }),
        Column(
          children: [
            Text('Tên: ${user.Name}'),
            Text('Cấp độ: ${user.Exp ~/ 1000}'),
          ],
        ),
        Builder(builder: (context) {
          if (user.ID == idOwner) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          } else {
            return const Text('');
          }
        })
      ],
    ),
  );
}
