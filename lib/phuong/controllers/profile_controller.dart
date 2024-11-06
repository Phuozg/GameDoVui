import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
}
