import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String ID;
  String IDTopic;
  String Content;

  QuestionModel(
      {required this.ID, required this.IDTopic, required this.Content});

  static QuestionModel empty() =>
      QuestionModel(ID: '', IDTopic: '', Content: '');

  factory QuestionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return QuestionModel(
          ID: data['ID'] ?? '',
          IDTopic: data['IDTopic'] ?? '',
          Content: data['Content'] ?? '');
    } else {
      return QuestionModel.empty();
    }
  }
  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
        ID: data['ID'], Content: data['Content'], IDTopic: data['IDTopic']);
  }
}
