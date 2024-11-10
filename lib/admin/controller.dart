import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// tạo model user để tương tác dữ liệu với user
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

  //làm điều này thì khi gọi UserModel.empty() thì sẽ tạo ra một user trống dữ liệu
  static UserModel empty() => UserModel(
      ID: '',
      UserName: '',
      Password: '',
      Name: '',
      Avatar: '',
      Exp: 0,
      CreatedAt: Timestamp.now(),
      Role: false);

  //hàm này khi bỏ dữ liệu user được lấy về từ firebase firestore vào thì sẽ có được dạng model user. tương tác làm việc sẽ dễ hơn cần gì chỉ cần user.ID, user.Name ,....
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

//tương tự giải thích class user
class TopicModel {
  String ID;
  String TopicName;

  TopicModel({required this.ID, required this.TopicName});

  static TopicModel empty() => TopicModel(ID: '', TopicName: '');

  Map<String, dynamic> toJson() {
    return {'ID': ID, 'TopicName': TopicName};
  }

  //cũng giống như hàm fromFirestore nhưng đây là câu lệnh lấy dữ liệu realtime của firebase nên dữ liệu trả về sẽ dạng khác nên cần viết hàm khác, vẫn trả ra model user
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

//tương tự 2 class trên
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

//Controller có thể viết mà không cần kế thừa từ GetXCOntroller. tuy nhiên vì khi hiển thị câu hỏi cần lấy được tên topic từ topic ID của bảng question.
//nên nên phương án tạm thời là cho kế thừa GetXControler để override được hàm onInit là khi khởi tạo Controller sẽ lấy dữ liệu của topic bỏ vào biến topics luôn
//việc có được topics sẽ đảm bảo rằng khi lấy tên topic từ topicID để hiển thị bên question sẽ luôn thành công. không có trường hơp không có dữ liệu
//đây có thể không phải cách tối ưu, nhưng tạm thời xài được thì cứ xài, nếu biết được cách khác ok hơn sẽ áp dụng sau
class Controller extends GetxController {
  static Controller get instance => Get.find();
  final db = FirebaseFirestore.instance;

  //biến topics lưu tất cả topic có trong database được nói ở trên
  RxList<TopicModel> topics = <TopicModel>[].obs;

  //onInit sẽ được gọi khi khởi tạo controller. onInit được gọi sẽ gọi luôn các hàm ở trong nó
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  //hàm lấy tất cả topic lưu vào biến topics phục vụ việc lấy tên topic như đã đề cập
  Future<void> fetchData() async {
    db.collection('Topic').snapshots().listen((snapshot) {
      topics.clear();
      for (var topic in snapshot.docs) {
        topics.add(TopicModel.fromSnapshot(topic));
      }
    });
  }

  // hàm trả về danh sách option của questionID bỏ vào khi được gọi
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

  //hàm trả về dữ liệu tất cả user trong db
  //Không cần lấy dạng RxList, có thể lấy bằng List thường. có thể trả lời lúc làm phần này nửa đêm nên viết theo quán tính
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
    //vì là RxList nên phải .obs phía sau để phù hợp kiểu Rx
    return users.obs;
  }

  //tương tự hàm getOptions phía trên
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

  //tương tự hàm getOptions phía trên
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

  //hàm xóa user được truyển userID vào
  Future<void> deleteUser(String userID) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('User').doc(userID).delete();
      await getUsers();
    } catch (e) {}
  }

  //hàm chỉnh sửa thông tin user được truyển userID vào. chỉ cho sửa name và exp
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

  //tương tự hàm edituser, ở đây chỉ có content để sửa
  Future<void> editOption(String optionID, String content) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Option').doc(optionID).update({
        'Content': content,
      });
    } catch (e) {}
  }

  //tương tự 2 hàm edit phía trên
  Future<void> editTopic(String name, String topicID) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Topic').doc(topicID).update({
        'TopicName': name,
      });
      await getTopics();
    } catch (e) {}
  }

  //tương tự hàm deleteUser
  Future<void> deleteTopic(String topicID) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection('Topic').doc(topicID).delete();
      await getTopics();
    } catch (e) {}
  }

  //hàm lấy tên topic. truyền vào topicID nó sẽ tìm kiếm topic có ID giống với topicID truyển vào
  // khi này chỉ cần lấy topic đạt yêu cầu trên và return topic.TopicName để có được tên topic hiển thị trên phần question
  String getTopicName(String topicID) {
    TopicModel topic = topics.firstWhere((topic) => topic.ID == topicID,
        orElse: () => TopicModel(ID: '', TopicName: ''));
    return topic.TopicName;
  }

  //hàm thêm câu hỏi mới. tạo ra 4 ID option ngẫu nhiên để tạo 4 option của câu hỏi mới tạo. ID của câu hỏi mới tạo sẽ được tạo ngẫu nhiên trước và truyền vào khi gọi hàm này
  Future<void> addQuestion(
      String content, String topicID, String questionID) async {
    final db = FirebaseFirestore.instance;
    try {
      final optionID1 = generateRandomString();
      final optionID2 = generateRandomString();
      final optionID3 = generateRandomString();
      final optionID4 = generateRandomString();

      //thêm question mới
      await db
          .collection('Question')
          .doc(questionID)
          .set({'ID': questionID, 'IDTopic': topicID, 'Content': content});

      //thêm option thứ 1 của question vừa tạo
      await db.collection('Option').doc(optionID1).set({
        'ID': optionID1,
        'IDQuestion': questionID,
        'Content': 'A',
        'Accuracy': true
      });

      //thêm option thứ 2 của question vừa tạo
      await db.collection('Option').doc(optionID1).set({
        'ID': optionID2,
        'IDQuestion': questionID,
        'Content': 'B',
        'Accuracy': false
      });

      //thêm option thứ 3 của question vừa tạo
      await db.collection('Option').doc(optionID1).set({
        'ID': optionID3,
        'IDQuestion': questionID,
        'Content': 'C',
        'Accuracy': false
      });
      //thêm option thứ 4 của question vừa tạo
      await db.collection('Option').doc(optionID1).set({
        'ID': optionID4,
        'IDQuestion': questionID,
        'Content': 'D',
        'Accuracy': false
      });

      //gọi thêm hàm getQuestion để cập nhật dữ liệu question mới được thêm vào
      await getQuestion();
    } catch (e) {}
  }

  //như các hàm add bên trên đầu
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

  //hàm tạo chuỗi 20 ký tự ngẫu nhiên. dùng để làm ID
  //Không nên làm cách này để tạo ID vì có thể trùng
  //nhưng đồ án quy mô nhỏ, nên xài cách này cho nhanh gọn (dữ liệu ít -> khả năng trùng thấp)
  String generateRandomString() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      20,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  //hàm đổi chuỗi String lấy từ db sang kiểu Bytes để MemoryImage đọc được và hiển thị ra hình ảnh
  Uint8List displayImageFromBase64(String base64String) {
    Uint8List decodedBytes = base64Decode(base64String);
    return decodedBytes;
  }
}
