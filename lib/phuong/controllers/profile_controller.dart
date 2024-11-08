import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser!.uid;
  Rx<UserModel> user = UserModel.empty().obs;
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    DocumentSnapshot doc = await db.collection('User').doc(userID).get();
    if (doc.exists) {
      user.value = UserModel.fromFirestore(doc);
    }
  }

  Future<void> pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File file = File(image.path);
        List<int> imageBytes = await file.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        await db.collection('User').doc(userID).update({'Avatar': base64Image});
        await fetchData();
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Uint8List displayImageFromBase64(String base64String) {
    Uint8List decodedBytes = base64Decode(base64String);
    return decodedBytes;
  }
}
