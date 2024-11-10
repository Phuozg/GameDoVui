import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:get/get.dart';

class ResultController extends GetxController {
  static ResultController get instance => Get.find();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  final db = FirebaseFirestore.instance;

  RxList<UserModel> users = <UserModel>[].obs;

  void fetchData() {
    db.collection('User').snapshots().listen((snapshot) {
      users.clear();
      for (var user in snapshot.docs) {
        users.add(UserModel.fromSnapshot(user));
      }
    });
  }

  UserModel getUserName(String userID) {
    try {
      UserModel user = users.firstWhere((user) {
        return user.ID == userID;
      }, orElse: () => UserModel.empty());
      return user;
    } catch (e) {
      return UserModel.empty();
    }
  }
}
