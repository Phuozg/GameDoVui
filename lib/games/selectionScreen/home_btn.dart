import 'package:dadd/games/gameScreen/game_Sceen.dart';
import 'package:flutter/material.dart';


class trangcu_btn extends StatefulWidget {
  const trangcu_btn({super.key});

  @override
  State<trangcu_btn> createState() => _trangcu_btnState();
}

class _trangcu_btnState extends State<trangcu_btn> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.blue,
        width: 60,
        height: 60,
        child: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => _showConfirmationDialogTC(context),
        ),
      ),
    );
  }
}

void _showConfirmationDialogTC(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Quay lại trang chủ?"),
        content: Text("Bạn có chắc chắn muốn quay lại trang chủ không?"),
        actions: [
          TextButton(
            child: Text("Không"),
            onPressed: () => Navigator.of(context).pop(), // Closes dialog
          ),
          TextButton(
            child: Text("Có"),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => gameScreen()),
            ); // Navigates back to home
            },
          ),
        ],
      );
    },
  );
}