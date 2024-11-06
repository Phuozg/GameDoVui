import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/room_model.dart';
import 'package:get/get.dart';

class RoomController extends GetxController {
  static RoomController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  RxList<RoomModel> rooms = <RoomModel>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    db
        .collection('Room')
        .where('Status', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      rooms.clear();
      for (var room in snapshot.docs) {
        rooms.add(RoomModel.fromSnapshot(room));
      }
    });
  }

  void createRoom(String topicID, int quantityQuestion, String idOwner) async {
    try {
      final roomID = generateRandomString();
      final questionSetID = generateRandomString();
      await db.collection('QuestionSet').doc(questionSetID).set({
        'ID': questionSetID,
        'IDTopic': topicID,
        'Quantity': quantityQuestion
      });
      await db.collection('Room').doc(roomID).set({
        'ID': roomID,
        'Code': roomID.substring(roomID.length - 6),
        'IDTopic': topicID,
        'IDQuestionSet': questionSetID,
        'IDOwner': idOwner,
        'Status': true
      });
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
    }
  }

  String generateRandomString() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      20,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }
}
