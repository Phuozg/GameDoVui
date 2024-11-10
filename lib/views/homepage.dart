import 'package:dadd/firebase_options.dart';
import 'package:dadd/games/selectionScreen/chon_Screen.dart';
import 'package:dadd/phuong/controllers/profile_controller.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:dadd/phuong/views/room_game_screen.dart';
import 'package:dadd/views/expContainer.dart';
import 'package:dadd/views/friendpage.dart';
import 'package:dadd/views/historypage.dart';
import 'package:dadd/views/menubutton.dart';
import 'package:dadd/views/rankingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
                      builder: (builder) => const AccountScreen()));
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
                  }),
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
                Expcontainer(user: ProfileController().user.value),
                const SizedBox(height: 150),
                MenuButton(
                  text: 'Chơi Luyện Tập',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const slc_Screen()));
                  },
                ),
                MenuButton(
                  text: 'Chơi Xếp Hạng',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const RoomGameScreen()));
                  },
                ),
                MenuButton(
                  text: 'Bạn Bè',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendPage(
                              userID: FirebaseAuth.instance.currentUser!.uid)),
                    );
                  },
                ),
                MenuButton(
                  text: 'Xem Lịch Sử Chơi',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Historypage(
                              userID: FirebaseAuth.instance.currentUser!.uid)),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
