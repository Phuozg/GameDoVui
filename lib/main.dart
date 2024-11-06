import 'package:dadd/games/gameScreen/game_Sceen.dart';
import 'package:dadd/games/notification/resultTeamScreen.dart';
import 'package:dadd/games/notification/rsOneScreen.dart';
import 'package:dadd/games/selectionScreen/chon_Screen.dart';
import 'package:dadd/login/login_account_screen.dart';
import 'package:dadd/views/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
