import 'package:dadd/Historys/historypage.dart';
import 'package:dadd/views/rankingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dadd/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: HomePage(),
      //home: RankingPage(),
      home: Historypage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
