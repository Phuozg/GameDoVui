import 'package:dadd/games/gameController.dart';
import 'package:dadd/games/notification/resultOne.dart';
import 'package:dadd/views/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class rsOnescreen extends StatefulWidget {
  rsOnescreen(
      {super.key,
      required this.score,
      required this.quantity,
      required this.topicID});
  String topicID;
  int score;
  int quantity;
  @override
  State<rsOnescreen> createState() => _rsOnescreenState();
}

class _rsOnescreenState extends State<rsOnescreen> {
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
              child: rsBoardone(
                  rScore: widget.score.toString(),
                  wScore: (widget.quantity - widget.score).toString(),
                  score: (widget.score * 10).toString()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                try {
                  GameController().createRoom(context, widget.topicID,
                      widget.quantity, FirebaseAuth.instance.currentUser!.uid);
                } catch (e) {}
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Chơi Lại'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()),
                    (Route<dynamic> route) => route is HomePage);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Quay về màn hình chính'),
            ),
          ],
        ))
      ],
    );
  }
}
