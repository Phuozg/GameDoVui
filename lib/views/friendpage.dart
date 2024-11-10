import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/views/addFriendNotification.dart';
import 'package:dadd/views/addfriendpage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class FriendPage extends StatefulWidget {
  final String userID;
  const FriendPage({super.key, required this.userID});

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<FriendModel> friends = [];
  List<FriendModel> filteredFriends = [];
  List<UserModel> users = [];
  bool hasNotification = false;
  Map<String, String> userNames = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFriends);
    loadRealTimeData();
  }

  void _filterFriends() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFriends = friends.where((friend) {
        String name1 = getName(friend.IDUser1).toLowerCase();
        String name2 = getName(friend.IDUser2).toLowerCase();
        return name1.contains(query) || name2.contains(query);
      }).toList();
    });
  }

  void checkNotification() {
    bool found = friends
        .any((friend) => (friend.IDUser2 == widget.userID && !friend.Status));
    if (found) {
      setState(() {
        hasNotification = true;
      });
    } else {
      setState(() {
        hasNotification = false;
      });
    }
  }

  void loadRealTimeData() {
    FirebaseFirestore.instance
        .collection('Friend')
        .snapshots()
        .listen((snapshot) {
      List<FriendModel> newFriends =
          snapshot.docs.map((doc) => FriendModel.fromSnapshot(doc)).toList();
      if (mounted) {
        setState(() {
          friends = newFriends;
          filteredFriends = List.from(friends);
        });
        checkNotification(); // Gọi hàm kiểm tra thông báo
      }
    });

    FirebaseFirestore.instance
        .collection('User')
        .snapshots()
        .listen((snapshot) {
      List<UserModel> newUsers =
          snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
      if (mounted) {
        setState(() {
          users = newUsers;
          userNames = {for (var user in users) user.ID: user.Name};
        });
      }
    });
  }

  String getAvatar(String userID) {
    UserModel? user = users.firstWhere(
      (user) => user.ID == userID,
      orElse: () => UserModel.empty(),
    );
    return user.Avatar.isNotEmpty ? user.Avatar : '';
  }

  String getName(String userID) {
    return userNames[userID] ?? 'Người dùng không xác định';
  }

  Widget buildFriendCard(String userID) {
    String avatarString = getAvatar(userID);
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
          color: Colors.purple[50],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              backgroundImage:
                  avatarImage != null ? MemoryImage(avatarImage) : null,
              child: avatarImage == null
                  ? Text(
                      getName(userID)[0],
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                getName(userID),
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black54),
              onPressed: () {
                confirmRemoveFriend(widget.userID, userID);
              },
            ),
          ],
        ),
      ),
    );
  }

  void confirmRemoveFriend(String userID1, String userID2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa bạn bè'),
          content: const Text('Bạn có chắc chắn muốn xóa bạn này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                removeFriend(userID1, userID2);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void removeFriend(String userID1, String userID2) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Friend')
          .where('IDUser1', whereIn: [userID1, userID2]).where('IDUser2',
              whereIn: [userID1, userID2]).get();

      if (querySnapshot.docs.isNotEmpty) {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        for (var doc in querySnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa bạn thành công')),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy bạn bè để xóa')),
        );
      }
    } catch (e) {
      print('Lỗi khi xóa bạn: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi khi xóa bạn: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFriends);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Bạn Bè'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              FriendSearchScreen(
                  userID: widget.userID); //đảm bảo load lại trang add
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FriendSearchScreen(userID: widget.userID)),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  hasNotification
                      ? Icons.notifications_active
                      : Icons.notifications,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Addfriendnotification()),
                  );
                },
              ),
              if (hasNotification)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 20),
            Expanded(
              child: friends.isEmpty && _searchController.text.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có bạn bè',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : filteredFriends.isEmpty
                      ? const Center(
                          child: Text(
                            'Không tìm thấy',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredFriends.length,
                          itemBuilder: (context, index) {
                            var friend = filteredFriends[index];
                            if (friend.Status &&
                                friend.IDUser1 == widget.userID) {
                              return buildFriendCard(friend.IDUser2);
                            } else if (friend.Status &&
                                friend.IDUser2 == widget.userID) {
                              return buildFriendCard(friend.IDUser1);
                            }
                            return const SizedBox();
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendModel {
  final String IDUser1;
  final String IDUser2;
  final bool Status;

  FriendModel(
      {required this.IDUser1, required this.IDUser2, required this.Status});
  FriendModel.empty()
      : IDUser1 = '',
        IDUser2 = '',
        Status = false;

  factory FriendModel.fromSnapshot(DocumentSnapshot snapshot) {
    return FriendModel(
      IDUser1: snapshot['IDUser1'],
      IDUser2: snapshot['IDUser2'],
      Status: snapshot['Status'],
    );
  }
}

class UserModel {
  final String ID;
  final String Name;
  final String Avatar;

  UserModel({required this.ID, required this.Name, required this.Avatar});

  UserModel.empty()
      : ID = '',
        Name = '',
        Avatar = '';

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      ID: snapshot['ID'],
      Name: snapshot['Name'],
      Avatar: snapshot['Avatar'] ?? '',
    );
  }
}
