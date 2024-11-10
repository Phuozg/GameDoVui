import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/question_model.dart';
import 'package:dadd/phuong/models/room_model.dart';
import 'package:dadd/phuong/models/user_model.dart';
import 'package:dadd/phuong/views/game_multi_sceen.dart';
import 'package:dadd/phuong/views/waiting_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomController extends GetxController {
  static RoomController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  RxList<RoomModel> rooms = <RoomModel>[].obs;
  RxList<UserModel> allusers = <UserModel>[UserModel.empty()].obs;
  RxList<String> userIDs = [''].obs;
  List<QuestionModel> questions = <QuestionModel>[];
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
    db.collection('User').snapshots().listen((snapshot) {
      allusers.clear();
      for (var user in snapshot.docs) {
        allusers.add(UserModel.fromSnapshot(user));
      }
    });
  }

  Future<void> changeQuantityQuestion(
      int quantity, String questionSetID) async {
    await db
        .collection('QuestionSet')
        .doc(questionSetID)
        .update({'Quantity': quantity});
  }

  Future<void> changeTopic(String IDTopic, String questionSetID) async {
    await db
        .collection('QuestionSet')
        .doc(questionSetID)
        .update({'IDTopic': IDTopic});
  }

  void createRoom(BuildContext context, String topicID, int quantityQuestion,
      String idOwner) async {
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
      await addUserIntoRoom(FirebaseAuth.instance.currentUser!.uid, roomID);
      await fetchDataRoom(roomID);
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => WaitingRoomScreen(
                    roomName: roomID.substring(roomID.length - 6),
                    quantityQuestion: quantityQuestion,
                    topic: topicID,
                    roomID: roomID,
                    idOwner: idOwner,
                    questionSetID: questionSetID,
                  )));
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
    }
  }

  Future<Uint8List> displayImageFromBase64(String userIDOwner) async {
    UserModel owner = UserModel.empty();
    DocumentSnapshot doc = await db.collection('User').doc(userIDOwner).get();
    if (doc.exists) {
      owner = UserModel.fromFirestore(doc);
    }
    Uint8List decodedBytes = base64Decode(owner.Avatar);
    return decodedBytes;
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

  Future<int> countDocumentsWithRoom(String roomID) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('Player')
          .where('IDRoom', isEqualTo: roomID)
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('Lỗi: $e');
      return 0;
    }
  }

  Future<void> generateRandomQuestion(String idTopic, int quantity) async {
    questions.clear();
    QuerySnapshot querySnapshot = await db
        .collection('Question')
        .where('IDTopic', isEqualTo: idTopic)
        .get();
    List<DocumentSnapshot> allDocs = querySnapshot.docs;
    allDocs.shuffle();
    List<DocumentSnapshot> selectedDocs = allDocs.take(quantity).toList();
    for (var doc in selectedDocs) {
      questions.add(QuestionModel.fromFirestore(doc));
    }
  }

  Future<void> fetchDataRoom(String roomID) async {
    db
        .collection('Player')
        .where('IDRoom', isEqualTo: roomID)
        .snapshots()
        .listen((snapshot) {
      userIDs.clear();
      for (var user in snapshot.docs) {
        userIDs.add(user['IDUser']);
      }
    });
  }

  Future<UserModel> getUserbyID(String userID) async {
    UserModel user = allusers.firstWhere(
      (user) => user.ID == userID,
      orElse: () => UserModel.empty(),
    );
    return user;
  }

  Rx<UserModel> getUserrr(String userID) {
    try {
      UserModel user = UserModel.empty();
      db.collection('User').doc(userID).get().then((userr) {
        user = UserModel.fromFirestore(userr);
      });
      return user.obs;
    } catch (e) {
      return UserModel.empty().obs;
    }
  }

  Future<void> addUserIntoRoom(String userID, String roomID) async {
    db
        .collection('Player')
        .add({'IDRoom': roomID, 'IDUser': userID, 'Status': false});
  }

  Future<void> deletePlayerWhenUserOutRoom(
      String userID, String ownerID) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('Player')
          .where('IDUser', isEqualTo: userID)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await db.collection('Player').doc(doc.id).delete();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> ownerOutRoom(String idRoom) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('Player')
          .where('IDRoom', isEqualTo: idRoom)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await db.collection('Player').doc(doc.id).delete();
      }
      await db.collection('Room').doc(idRoom).delete();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<UserModel>> getUsers(List<String> userIds) async {
    List<UserModel> users = [];
    final db = FirebaseFirestore.instance;
    try {
      for (String id in userIds) {
        DocumentSnapshot doc = await db.collection('User').doc(id).get();
        if (doc.exists) {
          users.add(UserModel.fromFirestore(doc));
        }
      }
    } catch (e) {
      print('Lỗi: $e');
    }
    return users;
  }

  Future<List<OptionModel>> getOptions(String idQuestion) async {
    List<OptionModel> answers = [];
    final db = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await db
          .collection('Option')
          .where('IDQuestion', isEqualTo: idQuestion)
          .get();
      for (var doc in querySnapshot.docs) {
        answers.add(OptionModel.fromFirestore(doc));
      }
    } catch (e) {
      print('Lỗi: $e');
    }
    return answers;
  }

  void createGame(BuildContext context, int score, String IDUser,
      String IDQuestionSet,Timestamp create) async {
    try {
      await db.collection('Game').add({
        'IDQuestionset': IDQuestionSet,
        'Point': score,
        'IDUser': IDUser,
        'GameType': 'Multiple',
        'CreatedAt': create,
        'CompletedAt': Timestamp.now()
      });
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
    }
  }

  void changeStatusPlayer(String IDUser, String IDRoom) async {
    QuerySnapshot querySnapshot = await db
        .collection('Player')
        .where('IDUser', isEqualTo: IDUser)
        .where('IDRoom', isEqualTo: IDRoom)
        .get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await db.collection('Player').doc(doc.id).update({'Status': true});
    }
  }
}
