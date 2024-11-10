import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModel {
  String ID;
  String UserName;
  String Password;
  String Name;
  String Avatar;
  int Exp;
  Timestamp CreatedAt;
  bool Role;
  UserModel(
      {required this.ID,
      required this.UserName,
      required this.Password,
      required this.Name,
      required this.Avatar,
      required this.Exp,
      required this.CreatedAt,
      required this.Role});
  static UserModel empty() => UserModel(
      ID: '',
      UserName: '',
      Password: '',
      Name: '',
      Avatar: '',
      Exp: 0,
      CreatedAt: Timestamp.now(),
      Role: false);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
        ID: data['ID'] ?? "",
        UserName: data["UserName"] ?? "",
        Password: data['Password'] ?? '',
        Name: data['Name'] ?? '',
        Avatar: data['Avatar'] ?? '',
        Exp: data['Exp'] ?? 0,
        CreatedAt: data['CreatedAt'] ?? Timestamp.now(),
        Role: data['Role'] ?? false);
  }
}

class TopicModel {
  String ID;
  String TopicName;

  TopicModel({required this.ID, required this.TopicName});

  static TopicModel empty() => TopicModel(ID: '', TopicName: '');

  Map<String, dynamic> toJson() {
    return {'ID': ID, 'TopicName': TopicName};
  }

  factory TopicModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return TopicModel(ID: data['ID'], TopicName: data['TopicName']);
    } else {
      return TopicModel.empty();
    }
  }
  factory TopicModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TopicModel(ID: data['ID'], TopicName: data['TopicName']);
  }
}

class QuestionModel {
  String ID;
  String IDTopic;
  String Content;

  QuestionModel(
      {required this.ID, required this.IDTopic, required this.Content});

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
        ID: data['ID'], Content: data['Content'], IDTopic: data['IDTopic']);
  }
}

class Option {
  String ID;
  String IDQuestion;
  String Content;
  bool Accuracy;

  Option(
      {required this.ID,
      required this.IDQuestion,
      required this.Content,
      required this.Accuracy});
  factory Option.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Option(
        ID: data['ID'],
        Content: data['Content'],
        IDQuestion: data['IDQuestion'],
        Accuracy: data['Accuracy']);
  }
}

class Controller extends GetxController {
  static Controller get instance => Get.find();
  final db = FirebaseFirestore.instance;
  RxList<TopicModel> topics = <TopicModel>[].obs;
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    db.collection('Topic').snapshots().listen((snapshot) {
      topics.clear();
      for (var topic in snapshot.docs) {
        topics.add(TopicModel.fromSnapshot(topic));
      }
    });
  }

  Future<List<Option>> getOptions(String questionID) async {
    List<Option> options = [];
    final db = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
          .collection('Option')
          .where('IDQuestion', isEqualTo: questionID)
          .get();
      for (var doc in querySnapshot.docs) {
        options.add(Option.fromFirestore(doc));
      }
    } catch (e) {}
    return options;
  }

  Future<RxList<UserModel>> getUsers() async {
    List<UserModel> users = [];
    final db = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('User').get();
      for (var doc in querySnapshot.docs) {
        users.add(UserModel.fromFirestore(doc));
      }
    } catch (e) {}
    return users.obs;
  }

  Future<List<TopicModel>> getTopics() async {
    List<TopicModel> topic = [];
    final db = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('Topic').get();
      for (var doc in querySnapshot.docs) {
        topic.add(TopicModel.fromFirestore(doc));
      }
    } catch (e) {}
    return topic;
  }

  Future<List<QuestionModel>> getQuestion() async {
    List<QuestionModel> question = [];
    final db = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('Question').get();
      for (var doc in querySnapshot.docs) {
        question.add(QuestionModel.fromFirestore(doc));
      }
    } catch (e) {}
    return question;
  }

  Future<void> deleteUser(String userID) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('User').doc(userID).delete();
      await getUsers();
    } catch (e) {}
  }

  Future<void> editUser(String userID, String name, int exp) async {
    final db = FirebaseFirestore.instance;
    try {
      await db
          .collection('User')
          .doc(userID)
          .update({'Name': name, 'Exp': exp});
      await getUsers();
    } catch (e) {}
  }

  Future<void> editOption(String optionID, String content) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Option').doc(optionID).update({
        'Content': content,
      });
    } catch (e) {}
  }

  Future<void> editQuestion(String questionID, String content) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Question').doc(questionID).update({
        'Content': content,
      });
    } catch (e) {}
  }

  Future<void> editTopic(String name, String topicID) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Topic').doc(topicID).update({
        'TopicName': name,
      });
      await getTopics();
    } catch (e) {}
  }

  Future<void> deleteTopic(String topicID) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Topic').doc(topicID).delete();
      await getTopics();
    } catch (e) {}
  }

  String getTopicName(String topicID) {
    TopicModel topic = topics.firstWhere((topic) => topic.ID == topicID,
        orElse: () => TopicModel(ID: '', TopicName: ''));
    return topic.TopicName;
  }

  Future<void> addQuestion(
      String content, String topicID, String questionID) async {
    final db = FirebaseFirestore.instance;
    try {
      final optionID1 = generateRandomString();
      final optionID2 = generateRandomString();
      final optionID3 = generateRandomString();
      final optionID4 = generateRandomString();

      await db
          .collection('Question')
          .doc(questionID)
          .set({'ID': questionID, 'IDTopic': topicID, 'Content': content});
      await db.collection('Option').doc(optionID1).set({
        'ID': optionID1,
        'IDQuestion': questionID,
        'Content': 'A',
        'Accuracy': true
      });
      await db.collection('Option').doc(optionID2).set({
        'ID': optionID2,
        'IDQuestion': questionID,
        'Content': 'B',
        'Accuracy': false
      });
      await db.collection('Option').doc(optionID3).set({
        'ID': optionID3,
        'IDQuestion': questionID,
        'Content': 'C',
        'Accuracy': false
      });
      await db.collection('Option').doc(optionID4).set({
        'ID': optionID4,
        'IDQuestion': questionID,
        'Content': 'D',
        'Accuracy': false
      });
      await getQuestion();
      await getOptions(questionID);
    } catch (e) {}
  }

  Future<void> addTopic(String name) async {
    final db = FirebaseFirestore.instance;
    try {
      final topicID = generateRandomString();
      await db
          .collection('Topic')
          .doc(topicID)
          .set({'ID': topicID, 'TopicName': name});
      await getTopics();
    } catch (e) {}
  }

  Future<void> deleteQuestion(String questionID) async {
    try {
      await db.collection('Question').doc(questionID).delete();
      QuerySnapshot querySnapshot = await db
          .collection('Option')
          .where('IDQuestion', isEqualTo: questionID)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await db.collection('Option').doc(doc.id).delete();
      }
    } catch (e) {
      print('Error deleting question document: $e');
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

  Uint8List displayImageFromBase64(String base64String) {
    Uint8List decodedBytes = base64Decode(base64String);
    return decodedBytes;
  }
}
