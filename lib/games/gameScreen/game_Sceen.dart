import 'package:dadd/games/gameScreen/btn_Home.dart';
import 'package:dadd/games/gameScreen/btn_XacNhan.dart';
import 'package:dadd/games/gameScreen/clock.dart';
import 'package:dadd/games/gameScreen/question.dart';
import 'package:flutter/material.dart';


class gameScreen extends StatefulWidget {
  const gameScreen({super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  int _selectedIndex = -1; // Track the selected answer

  void _onOptionSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ngăn xếp

      children: [
        SizedBox.expand(
            child: Image.asset(
          'assets/image/background.jpg',
          fit: BoxFit.cover,
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        btn_Home()
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        cdTimer(),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Question(ques: 'abc'),
            SizedBox(
              height: 250, // Set height as needed
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onOptionSelected(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.purple[300]
                              : Colors.purple[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            btn_XN(),
          ],
        )
      ],
    );
  }
}
