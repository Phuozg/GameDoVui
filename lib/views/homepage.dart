import 'package:dadd/views/account_screen.dart';
import 'package:dadd/views/expContainer.dart';
import 'package:dadd/views/friendpage.dart';
import 'package:dadd/views/historypage.dart';
import 'package:dadd/views/menubutton.dart';
import 'package:dadd/views/rankingpage.dart';
import 'package:dadd/views/room_game_screen.dart';
import 'package:dadd/views/solo_play.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Trang Chủ'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()));
            },
            icon: const Icon(Icons.person),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.emoji_events),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RankingPage()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover)),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: Column(
              children: [
                const Expcontainer(),
                const SizedBox(height: 30),
                // Buttons
                Column(
                  children: [
                    MenuButton(
                      text: 'Chơi Luyện Tập',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SoloPlay()),
                        );
                      },
                    ),
                    MenuButton(
                      text: 'Chơi Xếp Hạng',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RoomGameScreen()));
                      },
                    ),
                    //MenuButton(text: 'Bạn Bè'),
                    MenuButton(
                      text: 'Bạn Bè',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FriendPage()),
                        );
                      },
                    ),
                    MenuButton(
                        text: 'Xem Lịch Sử Chơi',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomDialogContent(),
                              );
                            },
                          );
                        })
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
