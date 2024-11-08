import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data() != null) {
      final data = doc.data()!;
      return UserModel(
          ID: data['ID'] ?? "",
          UserName: data["UserName"] ?? "",
          Password: data['Password'] ?? '',
          Name: data['Name'] ?? '',
          Avatar: data['Avatar'] ?? '',
          Exp: data['Exp'] ?? 0,
          CreatedAt: data['CreatedAt'] ?? Timestamp.now(),
          Role: data['Role'] ?? false);
    } else {
      return UserModel.empty();
    }
  }

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
