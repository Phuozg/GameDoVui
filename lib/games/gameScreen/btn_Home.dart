import 'package:dadd/views/homepage.dart';
import 'package:flutter/material.dart';

class btn_Home extends StatefulWidget {
  const btn_Home({super.key});

  @override
  State<btn_Home> createState() => _btn_HomeState();
}

class _btn_HomeState extends State<btn_Home> {
   void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Thông Báo',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Bạn có chắc chắn muốn từ bỏ trận đấu và quay về trang chủ',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ); 
              },
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text(
                'Hủy bỏ',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
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
          onPressed: () => _showConfirmationDialog(context),
        ),
      ),
    );
  }
}