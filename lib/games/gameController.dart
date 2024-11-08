import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/games/gameScreen/game_Sceen.dart';
import 'package:flutter/material.dart';

class GameController {
  final database = FirebaseFirestore.instance;
  String roomID = "";
  List<Question> questions = [];
  final db = FirebaseFirestore.instance;
  void createRoom(
      BuildContext context, String IDTopic, int quantity, String IDUser) async {
    try {
      roomID = generateRandomString();
      final questionSetID = generateRandomString();

      //Tạo bộ đề
      await database
          .collection('QuestionSet')
          .doc(questionSetID)
          .set({'ID': questionSetID, 'IDTopic': IDTopic, 'Quantity': quantity});

      //Lấy ngẫu nhiên câu hỏi
      QuerySnapshot querySnapshot = await database
          .collection('Question')
          .where('IDTopic', isEqualTo: IDTopic)
          .get();
      List<DocumentSnapshot> allDocs = querySnapshot.docs;
      allDocs.shuffle();
      List<DocumentSnapshot> selectedDocs = allDocs.take(quantity).toList();
      for (var doc in selectedDocs) {
        questions.add(Question.fromFirestore(doc));
      }

      //Tạo phòng chơi đơn
      await database.collection('Room').doc(roomID).set({
        'ID': roomID,
        'Code': roomID.substring(roomID.length - 6),
        'IDTopic': IDTopic,
        'IDQuestionSet': questionSetID,
        'IDOwner': IDUser,
        'Status': false
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => gameScreen(
                    questions: questions,
                    questionSetID: questionSetID,
                  )));
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
      String IDQuestionSet) async {
    try {
      //Tạo bộ đề
      await database.collection('Game').add({
        'IDQuestionset': IDQuestionSet,
        'Point': score,
        'IDUser': IDUser,
        'GameType': 'Single',
        'CreatedAt': Timestamp.now(),
        'CompletedAt': Timestamp.now()
      });
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
    }
  }
}

class Question {
  String ID;
  String Content;
  String IDTopic;
  Question({required this.ID, required this.Content, required this.IDTopic});
  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Question(
        ID: data['ID'], Content: data['Content'], IDTopic: data['IDTopic']);
  }
}
