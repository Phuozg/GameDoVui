import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  static PlayerController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final db = FirebaseFirestore.instance;

  Future<void> fetchUser(String userID) async {
    DocumentSnapshot doc = await db.collection('User').doc(userID).get();
    if (doc.exists) {
      user.value = UserModel.fromFirestore(doc);
    }
  }

  Uint8List displayImageFromBase64(String base64String) {
    Uint8List decodedBytes = base64Decode(base64String);
    return decodedBytes;
  }

  
}
