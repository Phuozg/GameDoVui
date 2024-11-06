import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String ID;
  String Code;
  String IDTopic;
  String IDQuestionSet;
  String IDOwner;
  bool Status;

  RoomModel(
      {required this.ID,
      required this.Code,
      required this.IDTopic,
      required this.IDQuestionSet,
      required this.IDOwner,
      required this.Status});

  //EmptyRoom
  static RoomModel empty() => RoomModel(
      ID: '',
      Code: '',
      IDTopic: '',
      IDQuestionSet: '',
      IDOwner: '',
      Status: false);

  Map<String, dynamic> toJson() {
    return {
      'ID': ID,
      'Code': Code,
      'IDTopic': IDTopic,
      'IDQuestionSet': IDQuestionSet,
      'IDOwner': IDOwner,
      'Status': Status
    };
  }

  factory RoomModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return RoomModel(
          ID: data['ID'] ?? '',
          Code: data['Code'] ?? '',
          IDTopic: data['IDTopic'] ?? '',
          IDQuestionSet: data['IDQuestionSet'] ?? '',
          IDOwner: data['IDOwner'] ?? '',
          Status: data['Status'] ?? false);
    } else {
      return RoomModel.empty();
    }
  }
}
