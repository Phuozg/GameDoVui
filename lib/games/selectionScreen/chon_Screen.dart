import 'package:dadd/games/selectionScreen/btn_slcXN.dart';
import 'package:dadd/games/selectionScreen/home_btn.dart';
import 'package:dadd/games/selectionScreen/slc_Topic.dart';
import 'package:dadd/games/selectionScreen/slc_number.dart';
import 'package:flutter/material.dart';

class slc_Screen extends StatefulWidget {
  const slc_Screen({super.key});

  @override
  State<slc_Screen> createState() => _slc_ScreenState();
}

class _slc_ScreenState extends State<slc_Screen> {
  int _questionCount = 10;
  final List<int> _questionOptions = [10, 20, 30];

  void _changeQuestionCount() {
    setState(() {
      int currentIndex = _questionOptions.indexOf(_questionCount);
      int nextIndex = (currentIndex + 1) % _questionOptions.length;
      _questionCount = _questionOptions[nextIndex];
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
        const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                trangcu_btn()
              ],
            ),
            slc_numbers(),
            slc_Topic(),
            btn_slcXN(),
          ],
        )
      ],
    );
  }
}
