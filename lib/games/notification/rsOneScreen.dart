import 'package:dadd/games/notification/resultOne.dart';
import 'package:flutter/material.dart';


class rsOnescreen extends StatefulWidget {
  const rsOnescreen({super.key});

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
              child: rsBoardone(rScore: '5', wScore: '5', score: '50'),
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
