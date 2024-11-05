import 'package:dadd/games/selectionScreen/topic_Btn.dart';
import 'package:flutter/material.dart';

class slc_Topic extends StatefulWidget {
  const slc_Topic({super.key});

  @override
  State<slc_Topic> createState() => _slc_TopicState();
}

class _slc_TopicState extends State<slc_Topic> {
  String? _selectedTopic;
  final List<String> topics = [
    'Toán học',
    'Lịch sử',
    'Khoa học',
    'Địa lý',
    'Văn học',
    'Sinh học',
    'Hóa học',
    'Vật lý',
    'Công nghệ',
    // Add more topics as needed
  ];

  void _selectTopic(String topic) {
    setState(() {
      _selectedTopic = topic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          const Text(
            'Chọn Chủ Đề',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // 60% of screen height
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: btn_Topic(
                      topic: topics[index],
                      isSelected: _selectedTopic == topics[index],
                      onTap: () => _selectTopic(topics[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
