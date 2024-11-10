import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentHistorypage extends StatefulWidget {
  final String mode;
  final String userID;
  const ContentHistorypage(
      {super.key, required this.mode, required this.userID});

  @override
  _ContentHistorypageState createState() => _ContentHistorypageState();
}

class _ContentHistorypageState extends State<ContentHistorypage> {
  List<QuestionSetModel> questionSets = [];
  List<UserModel> users = [];
  List<TopicModel> topics = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FirebaseFirestore.instance
        .collection('QuestionSet')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        questionSets.clear();
        for (var questionSet in snapshot.docs) {
          questionSets.add(QuestionSetModel.fromSnapshot(questionSet));
        }
      });
    });

    FirebaseFirestore.instance
        .collection('User')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        users.clear();
        for (var user in snapshot.docs) {
          users.add(UserModel.fromSnapshot(user));
        }
      });
    });

    FirebaseFirestore.instance
        .collection('Topic')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        topics.clear();
        for (var topic in snapshot.docs) {
          topics.add(TopicModel.fromSnapshot(topic));
        }
      });
    });
  }

  int getQuantityQuestion(String questionSetID) {
    QuestionSetModel filteredQuestionSet = QuestionSetModel.empty();
    for (var questionSet in questionSets) {
      if (questionSet.ID == questionSetID) {
        filteredQuestionSet = questionSet;
      }
    }
    return filteredQuestionSet.Quantity;
  }

  String getIDTopic(String questionSetID) {
    QuestionSetModel filteredQuestionSet = QuestionSetModel.empty();
    for (var questionSet in questionSets) {
      if (questionSet.ID == questionSetID) {
        filteredQuestionSet = questionSet;
      }
    }
    return filteredQuestionSet.IDTopic;
  }

  String getName(String userID) {
    UserModel filteredName = UserModel.empty();
    for (var user in users) {
      if (user.ID == userID) {
        filteredName = user;
      }
    }
    return filteredName.Name;
  }

  String getTopicName(String topicID) {
    TopicModel filteredName = TopicModel.empty();
    for (var topic in topics) {
      if (topic.ID == topicID) {
        filteredName = topic;
      }
    }
    return filteredName.Name;
  }

  Future<List<Map<String, dynamic>>> playData() async {
    List<Map<String, dynamic>> historyData = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Game').get();
      for (var doc in snapshot.docs) {
        historyData.add({
          "IDUser": doc['IDUser'],
          "IDQuestionSet": doc['IDQuestionSet'],
          "GameType": doc['GameType'],
          "Point": doc['Point'],
          "CreatedAt": doc['CreatedAt'],
          "CompletedAt": doc['CompletedAt'],
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return historyData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Game').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text(''));
        } else {
          final historyData = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          return ListView.builder(
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              var item = historyData[index];
              if (item["GameType"] == widget.mode &&
                  item["IDUser"] == widget.userID) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  child: ListTile(
                    title: Text('Người chơi: ${getName('${item['IDUser']}')}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Chủ Đề: ${getTopicName(getIDTopic('${item['IDQuestionset']}'))}'),
                        Text('Điểm số: ${item["Point"]}'),
                        Text(
                            'Số câu hỏi: ${getQuantityQuestion('${item["IDQuestionset"]}')}'),
                        Text(
                          'Bắt đầu: ${item["CreatedAt"] != null ? DateFormat('HH:mm:ss dd/MM/yyyy').format(item["CreatedAt"].toDate()) : ""}',
                        ),
                        Text(
                          'Kết Thúc: ${item["CompletedAt"] != null ? DateFormat('HH:mm:ss dd/MM/yyyy').format(item["CompletedAt"].toDate()) : ""}',
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        }
      },
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
