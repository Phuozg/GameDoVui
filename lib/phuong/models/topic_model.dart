import 'package:cloud_firestore/cloud_firestore.dart';

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
}
