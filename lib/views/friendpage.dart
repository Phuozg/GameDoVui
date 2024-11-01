import 'package:dadd/views/addfriendpage.dart';
import 'package:flutter/material.dart';

class FriendPage extends StatelessWidget {
  final List<Map<String, String>> friends = [
    {'name': 'Kha', 'status': 'Chưa xếp hạng'},
    {'name': 'Thành', 'status': 'Xếp hạng: Vàng'},
    {'name': 'Phương', 'status': 'Xếp hạng: Bạc'},
  ];

  FriendPage({super.key});

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendSearchScreen()));
              },
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover)),
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(friends[index]['name']![0],
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friends[index]['name']!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                friends[index]['status']!,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black54),
                        onPressed: () {
                          // xóa bạn bè tại đây
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
