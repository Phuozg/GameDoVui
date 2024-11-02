import 'package:dadd/games/notification/resultBoard.dart';
import 'package:flutter/material.dart';

class rsTeamscreen extends StatefulWidget {
  const rsTeamscreen({super.key});

  @override
  State<rsTeamscreen> createState() => _rsTeamscreenState();
}

class _rsTeamscreenState extends State<rsTeamscreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
            child: Image.asset(
          'assets/image/background.jpg',
          fit: BoxFit.cover,
        )),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: rsBoard(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Chơi Lại'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Quay về màn hình chính'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ))
      ],
    );
  }
}
