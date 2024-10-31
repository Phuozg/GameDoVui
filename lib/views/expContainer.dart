import 'package:flutter/material.dart';

class Expcontainer extends StatelessWidget {
  const Expcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       'Level 2',
          //       style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     SizedBox(width: 10),
          //   ],
          // ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.5),
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 25,
                  width:
                      (5200 / 6000) * MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                ),
              ),
              const Positioned(
                left: 15,
                top: 3,
                child: Text('2'),
              ),
              const Positioned(
                right: 15,
                top: 3,
                child: Text('3'),
              ),
              const Center(
                child: Text(
                  '5200/6000',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
