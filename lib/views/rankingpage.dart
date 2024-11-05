import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RankingPage(),
  ));
}

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  Future<List<Map<String, dynamic>>> fetchRankingData() async {
    List<Map<String, dynamic>> rankingData = [];
    try {
      // Truy xuất dữ liệu từ Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('ranking').get();

      for (var doc in snapshot.docs) {
        rankingData.add({
          "name": doc['name'],
          "points": doc['points'],
        });
      }

      // Sắp xếp dữ liệu theo điểm giảm dần
      rankingData.sort((a, b) => b['points'].compareTo(a['points']));
    } catch (e) {
      print("Error fetching data: $e");
    }

    return rankingData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Xếp Hạng'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchRankingData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final rankingData = snapshot.data!;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 250),
                          Expanded(
                            child: ListView.builder(
                              itemCount: rankingData.length,
                              itemBuilder: (context, index) {
                                final data = rankingData[index];
                                return ListTile(
                                  title: Text(data['name'],
                                      style: const TextStyle(fontSize: 16)),
                                  trailing: Text('${data['points']}pts',
                                      style: const TextStyle(fontSize: 16)),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Quay lại'),
                            ),
                          ),
                          const SizedBox(height: 100)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
