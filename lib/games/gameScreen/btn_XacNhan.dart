import 'package:flutter/material.dart';

class btn_XN extends StatefulWidget {
  const btn_XN({super.key});

  @override
  State<btn_XN> createState() => _btn_XNState();
}

class _btn_XNState extends State<btn_XN> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    'Xác Nhận',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
  }
}