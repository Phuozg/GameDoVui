import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

void main() {
  runApp(RankingPage());
}

class RankingPage extends StatelessWidget {
  RankingPage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _getRankingData() {
    return _firestore.collection('User').snapshots().map((snapshot) {
      List<Map<String, dynamic>> rankingData = snapshot.docs.map((doc) {
        return {
          "Name": doc['Name'],
          "Exp": doc['Exp'],
          "Avatar": doc['Avatar'],
        };
      }).toList();

      rankingData.sort((a, b) => b['Exp'].compareTo(a['Exp']));
      return rankingData;
    });
  }

  Widget _buildAvatar(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      );
    }
    try {
      final decodedBytes = base64Decode(base64String);
      return CircleAvatar(
        backgroundImage: MemoryImage(decodedBytes),
        backgroundColor: Colors.blue,
      );
    } catch (e) {
      return const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back)),
          title: const Text('Bảng Xếp Hạng'),
        ),
        body: const CustomDialogContent(),
      ),
    );
  }
}

class CustomDialogContent extends StatefulWidget {
  const CustomDialogContent({super.key});

  @override
  _CustomDialogContentState createState() => _CustomDialogContentState();
}

class _CustomDialogContentState extends State<CustomDialogContent> {
  bool isRankingSelected = true;
  String? selectedTopic;
  String? selectedTopicID;
  List<Map<String, dynamic>> userPointsList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _getRankingData() {
    return _firestore.collection('User').snapshots().map((snapshot) {
      List<Map<String, dynamic>> rankingData = snapshot.docs.map((doc) {
        return {
          "Name": doc['Name'],
          "Exp": doc['Exp'],
          "Avatar": doc['Avatar'],
        };
      }).toList();

      rankingData.sort((a, b) => b['Exp'].compareTo(a['Exp']));
      return rankingData;
    });
  }

  Future<String> getName(String idUser) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('User').doc(idUser).get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        return userSnapshot['Name'] ?? 'Unknown';
      } else {
        return 'User not found';
      }
    } catch (e) {
      print("Lỗi khi lấy tên người dùng: $e");
      return 'Error';
    }
  }

  List<Map<String, dynamic>> filterHighestPoints(
      List<Map<String, dynamic>> userPointsList) {
    final Map<String, int> highestPointsMap = {};

    for (var entry in userPointsList) {
      String idUser = entry['IDUser'];
      int point = entry['Point'];

      if (highestPointsMap.containsKey(idUser)) {
        if (point > highestPointsMap[idUser]!) {
          highestPointsMap[idUser] = point; // Cập nhật nếu điểm cao hơn
        }
      } else {
        highestPointsMap[idUser] = point; // Thêm IDUser mới
      }
    }

    // Chuyển map thành list và sắp xếp theo điểm từ cao xuống thấp
    List<Map<String, dynamic>> sortedList =
        highestPointsMap.entries.map((entry) {
      return {
        'IDUser': entry.key,
        'Point': entry.value,
      };
    }).toList();

    sortedList.sort((a, b) => b['Point'].compareTo(a['Point']));
    return sortedList;
  }

  Future<void> fetchQuestionSetIDs(String topicID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('QuestionSet')
          .where('IDTopic', isEqualTo: topicID)
          .get();

      List<String> fetchedIDs = querySnapshot.docs.map((doc) {
        return doc['ID'] as String;
      }).toList();

      List<Map<String, dynamic>> allUserPoints = [];

      // Gọi hàm getUserPointsByQuestionSet cho từng ID và lưu kết quả
      for (String idQuestionSet in fetchedIDs) {
        List<Map<String, dynamic>> userPoints =
            await getUserPointsByQuestionSet(idQuestionSet);
        allUserPoints.addAll(userPoints);
      }

      // Lọc danh sách để chỉ giữ lại IDUser có điểm cao nhất và sắp xếp theo điểm
      List<Map<String, dynamic>> filteredUserPoints =
          filterHighestPoints(allUserPoints);

      setState(() {
        userPointsList = filteredUserPoints;
      });
    } catch (e) {
      print("Lỗi khi lấy ID bộ câu hỏi: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getUserPointsByQuestionSet(
      String idQuestionSet) async {
    List<Map<String, dynamic>> userPoints = [];

    try {
      QuerySnapshot gameSnapshot = await _firestore
          .collection('Game')
          .where('IDQuestionset', isEqualTo: idQuestionSet)
          .get();

      for (var gameDoc in gameSnapshot.docs) {
        String idUser = gameDoc['IDUser'] ?? '';
        int point = gameDoc['Point'] ?? 0;

        userPoints.add({
          'IDUser': idUser,
          'Point': point,
        });
      }

      return userPoints;
    } catch (e) {
      print("Lỗi khi tìm kiếm dữ liệu Game: $e");
      return [];
    }
  }

  Widget _buildAvatar(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      );
    }
    try {
      final decodedBytes = base64Decode(base64String);
      return CircleAvatar(
        backgroundImage: MemoryImage(decodedBytes),
        backgroundColor: Colors.blue,
      );
    } catch (e) {
      return const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.error, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isRankingSelected = true),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Theo Cấp Độ',
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                isRankingSelected ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: isRankingSelected
                              ? Colors.black
                              : Colors.transparent,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isRankingSelected = false),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Theo Chủ Đề',
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                !isRankingSelected ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: !isRankingSelected
                              ? Colors.black
                              : Colors.transparent,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 130),
            Expanded(
              child: isRankingSelected
                  ? StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _getRankingData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Lỗi khi tải dữ liệu'));
                        }
                        final rankingData = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: rankingData.length,
                          itemBuilder: (context, index) {
                            final data = rankingData[index];
                            return ListTile(
                              leading: _buildAvatar(data['Avatar']),
                              title: Text(
                                data['Name'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: Text(
                                'Level ${(data['Exp'] / 1000).toInt()}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const SizedBox(height: 16),
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('Topic').snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Lỗi khi tải dữ liệu'));
                              }

                              final topics = snapshot.data?.docs.map((doc) {
                                return {
                                  'TopicName': doc['TopicName'] as String,
                                  'ID': doc.id,
                                };
                              }).toList();

                              if (topics == null || topics.isEmpty) {
                                return const Text('Không có chủ đề nào');
                              }

                              return DropdownButton<String>(
                                value: selectedTopicID,
                                items: topics.map((topic) {
                                  return DropdownMenuItem<String>(
                                    value: topic['ID'],
                                    child: Text(topic['TopicName']!),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTopicID = newValue;
                                    selectedTopic = topics.firstWhere((topic) =>
                                        topic['ID'] == newValue)['TopicName'];
                                    userPointsList.clear();
                                  });
                                  if (selectedTopicID != null) {
                                    fetchQuestionSetIDs(selectedTopicID!);
                                  }
                                },
                                hint: const Text('Chọn Chủ Đề'),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          userPointsList.isEmpty
                              ? const Center(child: Text('Không có dữ liệu'))
                              : ListView.builder(
                                  itemCount: userPointsList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final data = userPointsList[index];
                                    return FutureBuilder<String>(
                                      future: getName(data['IDUser']),
                                      builder: (context, nameSnapshot) {
                                        if (nameSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(); // Hiển thị khi đang tải
                                        }
                                        if (nameSnapshot.hasError) {
                                          return ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Icon(Icons.error,
                                                  color: Colors.red),
                                            ),
                                            title: const Text(
                                                'Error loading name'),
                                            trailing:
                                                Text('Điểm: ${data['Point']}'),
                                          );
                                        }

                                        // Lấy avatar từ bảng User với IDUser tương ứng
                                        return FutureBuilder<DocumentSnapshot>(
                                          future: _firestore
                                              .collection('User')
                                              .doc(data['IDUser'])
                                              .get(),
                                          builder: (context, avatarSnapshot) {
                                            if (avatarSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator(); // Hiển thị khi đang tải
                                            }
                                            if (avatarSnapshot.hasError ||
                                                !avatarSnapshot.hasData ||
                                                avatarSnapshot.data == null) {
                                              return ListTile(
                                                leading: const CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: Icon(Icons.person,
                                                      color: Colors.white),
                                                ),
                                                title: Text(nameSnapshot.data ??
                                                    'Unknown'),
                                                trailing: Text(
                                                    'Điểm: ${data['Point']}'),
                                              );
                                            }

                                            final avatarData =
                                                avatarSnapshot.data!.data()
                                                    as Map<String, dynamic>?;
                                            final avatarBase64 =
                                                avatarData?['Avatar'];

                                            return ListTile(
                                              leading: _buildAvatar(
                                                  avatarBase64), // Thêm CircleAvatar ở đây
                                              title: Text(nameSnapshot.data ??
                                                  'Unknown'), // Hiển thị tên lấy được
                                              trailing: Text(
                                                'Điểm: ${data['Point']}',
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                        ]),
            ),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: const Text('Quay lại'),
            //   ),
            // ),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }
}

class UserModel {
  final String ID;
  final String Name;

  UserModel({
    required this.ID,
    required this.Name,
  });
  UserModel.empty()
      : ID = '',
        Name = '';
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      ID: snapshot['ID'],
      Name: snapshot['Name'],
    );
  }
}

class TopicModel {
  final String ID;
  final String Name;

  TopicModel({required this.ID, required this.Name});

  TopicModel.empty()
      : ID = '',
        Name = 'Unknown';

  factory TopicModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TopicModel(
      ID: snapshot['ID'],
      Name: snapshot['TopicName'],
    );
  }
}

class QuestionSetModel {
  final String ID;
  final int Quantity;
  final String IDTopic;

  QuestionSetModel(
      {required this.ID, required this.Quantity, required this.IDTopic});
  QuestionSetModel.empty()
      : ID = '',
        Quantity = 0,
        IDTopic = '';
  factory QuestionSetModel.fromSnapshot(DocumentSnapshot snapshot) {
    return QuestionSetModel(
        ID: snapshot['ID'],
        Quantity: snapshot['Quantity'],
        IDTopic: snapshot['IDTopic']);
  }
}

class GameModel {
  final String idUser;
  final String idQuestionSet;
  final int point;

  GameModel({
    required this.idUser,
    required this.idQuestionSet,
    required this.point,
  });

  factory GameModel.fromDocument(Map<String, dynamic> doc) {
    return GameModel(
      idUser: doc['IDUser'] ?? '',
      idQuestionSet: doc['IDQuestionSet'] ?? '',
      point: doc['Point'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'IDUser': idUser,
      'IDQuestionSet': idQuestionSet,
      'Point': point,
    };
  }
}
