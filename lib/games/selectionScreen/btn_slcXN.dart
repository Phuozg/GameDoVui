import 'package:flutter/material.dart';

class btn_slcXN extends StatefulWidget {
  const btn_slcXN({super.key});

  @override
  State<btn_slcXN> createState() => _btn_slcXNState();
}

class _btn_slcXNState extends State<btn_slcXN> {
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