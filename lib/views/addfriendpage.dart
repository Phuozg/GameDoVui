import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FriendSearchScreen(),
    );
  }
}

class FriendSearchScreen extends StatelessWidget {
  final List<String> friends = ['Anh A', 'Anh B', 'Anh C'];

  FriendSearchScreen({super.key});

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
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bạn bè',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // Xóa nội dung tìm kiếm
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
          // Danh sách bạn bè
          Expanded(
            child: ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade400,
                height: 1,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple.shade100,
                    child: Text(
                      friends[index][0],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text(friends[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.person_add_alt_1),
                    onPressed: () {
                      // Hành động khi nhấn kết bạn
                      print("Kết bạn với ${friends[index]}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}