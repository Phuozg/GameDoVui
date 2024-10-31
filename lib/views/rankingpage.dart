import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: RankingPage(),
  ));
}

class RankingPage extends StatelessWidget {
  final List<Map<String, dynamic>> rankingData = [
    {
      "name": "Kha",
      "points": 100,
      "icon": Icons.emoji_events,
      "color": Colors.yellow
    },
    {
      "name": "Nhân",
      "points": 89,
      "icon": Icons.emoji_events,
      "color": Colors.grey
    },
    {
      "name": "Phương",
      "points": 80,
      "icon": Icons.emoji_events,
      "color": Colors.brown
    },
    {"name": "Thành", "points": 79, "icon": null, "color": null},
  ];

  RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Xếp Hạng'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rankingData.length,
              itemBuilder: (context, index) {
                final data = rankingData[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      data['icon'] ?? Icons.person,
                      color: data['color'],
                    ),
                  ),
                  title: Text(data['name']),
                  trailing: Text('${data['points']}pts'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press action
                Navigator.pop(context);
              },
              child: const Text('Quay lại'),
            ),
          ),
        ],
      ),
    );
  }
}
