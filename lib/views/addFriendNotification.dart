import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String avatar; // Thuộc tính avatar là chuỗi base64

  UserModel({required this.id, required this.name, required this.avatar});

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      id: doc['ID'],
      name: doc['Name'],
      avatar: doc['Avatar'] ??
          '', // Lấy avatar từ Firestore hoặc để trống nếu không có
    );
  }
}

class Addfriendnotification extends StatefulWidget {
  @override
  _AddfriendnotificationState createState() => _AddfriendnotificationState();
}

class _AddfriendnotificationState extends State<Addfriendnotification> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String userID = '0qInTr2HURRPok0mkb6hRStGjfs2';

  Stream<List<Map<String, dynamic>>> _getRequestAddUserData() {
    return _firestore.collection('Friend').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          "IDUser1": doc['IDUser1'],
          "IDUser2": doc['IDUser2'],
          "Status": doc['Status'],
        };
      }).toList();
    });
  }

  Future<List<UserModel>> _getUserList() async {
    try {
      final snapshot = await _firestore.collection('User').get();
      return snapshot.docs
          .map((doc) => UserModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching user list: $e');
      return [];
    }
  }

  Future<void> _acceptFriendRequest(String idUser1, String idUser2) async {
    try {
      await _firestore
          .collection('Friend')
          .where('IDUser1', isEqualTo: idUser1)
          .where('IDUser2', isEqualTo: idUser2)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _firestore.collection('Friend').doc(doc.id).update({'Status': true});
        }
      });
      print('Friend request accepted');
      setState(() {}); // Tải lại trang sau khi cập nhật dữ liệu
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  Future<void> _declineFriendRequest(String idUser1, String idUser2) async {
    try {
      await _firestore
          .collection('Friend')
          .where('IDUser1', isEqualTo: idUser1)
          .where('IDUser2', isEqualTo: idUser2)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _firestore.collection('Friend').doc(doc.id).delete();
        }
      });
      print('Friend request declined');
      setState(() {}); // Tải lại trang sau khi xóa dữ liệu
    } catch (e) {
      print('Error declining friend request: $e');
    }
  }

  String? getAvatar(String userID, List<UserModel> userList) {
    UserModel? user = userList.firstWhere(
      (user) => user.id == userID,
      orElse: () => UserModel(id: '', name: 'Unknown', avatar: ''),
    );
    return user.avatar.isNotEmpty ? user.avatar : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Báo'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _getUserList(),
        builder: (context, userListSnapshot) {
          if (userListSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userListSnapshot.hasError) {
            return const Center(child: Text('Lỗi khi tải dữ liệu người dùng'));
          }
          final userList = userListSnapshot.data ?? [];

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getRequestAddUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Lỗi khi tải dữ liệu'));
              }
              final userData = snapshot.data ?? [];
              if (userData.isEmpty) {
                return const Center(child: Text('Không có dữ liệu'));
              }
              final filteredData = userData
                  .where((data) =>
                      data['IDUser2'] == userID && data['Status'] == false)
                  .toList();

              if (filteredData.isEmpty) {
                return const Center(
                    child: Text('Không có lời mời kết bạn nào'));
              }

              return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final requestData = filteredData[index];
                  final matchingUser = userList.firstWhere(
                      (user) => user.id == requestData['IDUser1'],
                      orElse: () =>
                          UserModel(id: '', name: 'Unknown', avatar: ''));

                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              getAvatar(requestData['IDUser1'], userList) !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: MemoryImage(
                                        base64Decode(getAvatar(
                                            requestData['IDUser1'], userList)!),
                                      ),
                                    )
                                  : const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                          title: const Text('Thông Báo'),
                          subtitle: Text(
                              '${matchingUser.name} đã gửi lời mời kết bạn'),
                          trailing: const Text(''),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _acceptFriendRequest(
                                    requestData['IDUser1'], userID);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('Xác nhận'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _declineFriendRequest(
                                    requestData['IDUser1'], userID);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Từ chối'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Addfriendnotification(),
  ));
}
