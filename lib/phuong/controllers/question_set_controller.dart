import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/phuong/models/question_model.dart';
import 'package:dadd/phuong/models/question_set_model.dart';
import 'package:get/get.dart';

class QuestionSetController extends GetxController {
  static QuestionSetController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  RxList<QuestionSetModel> questionSets = <QuestionSetModel>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    db.collection('QuestionSet').snapshots().listen((snapshot) {
      questionSets.clear();
      for (var questionSet in snapshot.docs) {
        questionSets.add(QuestionSetModel.fromSnapshot(questionSet));
      }
    });
  }

  int getQuantityQuestion(String questionSetID) {
    QuestionSetModel filteredQuestionSet = QuestionSetModel.empty();
    for (var questionSet in questionSets) {
      if (questionSet.ID == questionSetID) {
        filteredQuestionSet = questionSet;
      }
    }
    return filteredQuestionSet.Quantity;
  }

  void createQuestionSetDetail(
      int quantityQuestion, String idTopic, String idQuestionSet) async {
    List<QuestionModel> questions = [];
    db
        .collection('Question')
        .where('IDTopic', isEqualTo: idTopic)
        .get()
        .then((querySnapshot) {
      for (var question in querySnapshot.docs) {
        questions.add(QuestionModel.fromSnapshot(question));
      }
    });
    List<QuestionModel> questionsRandom = [];
    Random random = Random();

    while (questionsRandom.length < quantityQuestion && questions.isNotEmpty) {
      int randomIndex = random.nextInt(questions.length);
      questionsRandom.add(questions.removeAt(randomIndex));
    }

    for (var question in questionsRandom) {
      try {
        await db
            .collection('QuestionSetDetail')
            .add({'IDQuestion': question.ID, 'IDQuestionSet': idQuestionSet});
      } catch (e) {
        print('Lỗi khi thêm dữ liệu: $e');
      }
    }
  }
}
