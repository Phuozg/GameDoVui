import 'package:dadd/admin/addUser_screen.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isMenuOpen = false;
  String selectedTab = 'Quản lý người dùng';

  final List<Map<String, dynamic>> tabs = [
    {
      'title': 'Quản lý người dùng',
      'icon': Icons.supervised_user_circle,
    },
    {
      'title': 'Quản lý bộ đề',
      'icon': Icons.list,
    },
    {
      'title': 'Quản lý câu hỏi',
      'icon': Icons.question_answer,
    },
  ];

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void selectTab(String tab) {
    setState(() {
      selectedTab = tab;
      isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: toggleMenu,
            ),
            Image.asset(
              'assets/image/logo.png',
              height: 70,
              width: 70,
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()));
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          // Thanh tab
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isMenuOpen ? 200 : 0,
            color: Colors.black,
            child: Column(
              children: tabs.map((tab) {
                return ListTile(
                  leading: Icon(tab['icon'], color: Colors.white),
                  title: Text(tab['title'],
                      style: const TextStyle(color: Colors.white)),
                  onTap: () => selectTab(tab['title']),
                );
              }).toList(),
            ),
          ),
          // Nội dung chính
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Đang quản lý: $selectedTab',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddUserScreen()),
                          );
                        },
                        child: Text('Thêm'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Xóa'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Sửa'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: 10, // Số lượng item
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('$selectedTab Item ${index + 1}'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
