import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentHistorypage extends StatelessWidget {
  final String mode;
  const ContentHistorypage({required this.mode});

  Future<List<Map<String, dynamic>>> soloPlayData() async {
    List<Map<String, dynamic>> historyData = [];
    Map<String, String> userMap = {};

    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').get();
      for (var doc in userSnapshot.docs) {
        userMap[doc['ID']] = doc['UserName'];
      }

      // Fetch play history data
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('PlayHistory').get();
      for (var doc in snapshot.docs) {
        String idUser = doc['IDUser'];
        historyData.add({
          "IDUser": userMap[idUser] ?? idUser,
          "IDTopic": doc['IDTopic'],
          "QuestionSet": doc['QuestionSet'],
          "Mode": doc['Mode'],
          "Score": doc['Score'],
          "StartTime": doc['StartTime'],
          "EndTime": doc['EndTime'],
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return historyData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: soloPlayData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history found'));
          } else {
            final historyData = snapshot.data!;
            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                var item = historyData[index];
                if (item["Mode"] == mode) {
                  //if (true) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    child: ListTile(
                      title: Text('UserName: ${item["IDUser"]}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('IDTopic: ${item["IDTopic"]}'),
                          Text('QuestionSet: ${item["QuestionSet"]}'),
                          //Text('Mode: ${item["Mode"]}'),
                          Text('Score: ${item["Score"]}'),
                          Text('StartTime: ${item["StartTime"]}'),
                          Text('EndTime: ${item["EndTime"]}'),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
