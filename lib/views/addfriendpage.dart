import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class FriendSearchScreen extends StatefulWidget {
  final String userID;
  const FriendSearchScreen({super.key, required this.userID});

  @override
  _FriendSearchScreenState createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  List<FriendModel> currentFriends = [];
  Map<String, String> userNames = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
    fetchData();
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((user) {
        return user.ID != widget.userID &&
            userNames[user.ID]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  String getAvatar(String userID) {
    UserModel? user = allUsers.firstWhere(
      (user) => user.ID == userID,
      orElse: () => UserModel(ID: '', Name: '', Avatar: ''),
    );
    return user.Avatar.isNotEmpty ? user.Avatar : '';
  }

  Widget buildFriendCard(UserModel user) {
    FriendStatus friendStatus = getFriendStatus(user.ID);
    String avatarString = getAvatar(user.ID);
    Uint8List? avatarImage;

    if (avatarString.isNotEmpty) {
      try {
        avatarImage = base64Decode(avatarString);
      } catch (e) {
        print('Lỗi khi giải mã chuỗi base64: $e');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage:
                  avatarImage != null ? MemoryImage(avatarImage) : null,
              child: avatarImage == null
                  ? Text(
                      user.Name[0],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                user.Name,
                style: const TextStyle(fontSize: 18.0, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                friendStatus == FriendStatus.friend
                    ? Icons.check_circle
                    : (friendStatus == FriendStatus.requestPending
                        ? Icons.hourglass_top
                        : Icons.person_add_alt_1),
                color: friendStatus == FriendStatus.friend
                    ? Colors.green
                    : (friendStatus == FriendStatus.requestPending
                        ? Colors.black
                        : Colors.black),
              ),
              onPressed: friendStatus != FriendStatus.notFriend
                  ? null
                  : () => sendFriendRequest(widget.userID, user.ID),
            ),
          ],
        ),
      ),
    );
  }

  FriendStatus getFriendStatus(String userID) {
    for (var friend in currentFriends) {
      if (friend.IDUser1 == widget.userID && friend.IDUser2 == userID ||
          friend.IDUser2 == widget.userID && friend.IDUser1 == userID) {
        return friend.Status
            ? FriendStatus.friend
            : FriendStatus.requestPending;
      }
    }
    return FriendStatus.notFriend;
  }

  Future<void> fetchData() async {
    // Lấy danh sách người dùng
    FirebaseFirestore.instance
        .collection('User')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        allUsers.clear();
        userNames.clear();
        for (var doc in snapshot.docs) {
          var userModel = UserModel.fromSnapshot(doc);
          if (userModel.ID != widget.userID) {
            allUsers.add(userModel);
            userNames[userModel.ID] = userModel.Name;
          }
        }
        filteredUsers = List.from(allUsers);
      });
    });

    // Lấy danh sách bạn bè hiện tại
    FirebaseFirestore.instance
        .collection('Friend')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        currentFriends.clear();
        for (var doc in snapshot.docs) {
          var friendModel = FriendModel.fromSnapshot(doc);
          if (friendModel.IDUser1 == widget.userID ||
              friendModel.IDUser2 == widget.userID) {
            currentFriends.add(friendModel);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Tìm Bạn Bè'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bạn bè',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
            ),
            // Danh sách người dùng
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(
                      child: Text(
                        'Không tìm thấy',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredUsers.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.shade400,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        var user = filteredUsers[index];
                        return buildFriendCard(user);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void sendFriendRequest(String currentUserID, String friendUserID) async {
    try {
      await FirebaseFirestore.instance.collection('Friend').add({
        'IDUser1': currentUserID,
        'IDUser2': friendUserID,
        'Status': false, // Trạng thái ban đầu là false (chờ xác nhận)
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Đã gửi yêu cầu kết bạn tới ${userNames[friendUserID]}')),
      );
      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }
}

enum FriendStatus {
  friend,
  requestPending,
  notFriend,
}

class UserModel {
  final String ID;
  final String Name;
  final String Avatar;

  UserModel({required this.ID, required this.Name, required this.Avatar});

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      ID: snapshot['ID'],
      Name: snapshot['Name'],
      Avatar: snapshot['Avatar'] ?? '',
    );
  }
}

class FriendModel {
  final String IDUser1;
  final String IDUser2;
  final bool Status;

  FriendModel(
      {required this.IDUser1, required this.IDUser2, required this.Status});

  factory FriendModel.fromSnapshot(DocumentSnapshot snapshot) {
    return FriendModel(
      IDUser1: snapshot['IDUser1'],
      IDUser2: snapshot['IDUser2'],
      Status: snapshot['Status'],
    );
  }
}
