import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionSetModel {
  String ID;
  String IDTopic;
  int Quantity;

  QuestionSetModel(
      {required this.ID, required this.IDTopic, required this.Quantity});

  static QuestionSetModel empty() =>
      QuestionSetModel(ID: '', IDTopic: '', Quantity: 0);

  factory QuestionSetModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return QuestionSetModel(
          ID: data['ID'] ?? '',
          IDTopic: data['IDTopic'] ?? '',
          Quantity: data['Quantity'] ?? '');
    } else {
      return QuestionSetModel.empty();
    }
  }
}
