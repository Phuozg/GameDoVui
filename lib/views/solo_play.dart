import 'package:dadd/views/homepage.dart';
import 'package:dadd/views/menubutton.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoloPlay(),
    );
  }
}

class SoloPlay extends StatefulWidget {
  const SoloPlay({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SoloPlay> {
  String? selectedTopic;
  String? selectedNumberOfSentences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chơi Luyện Tập'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Chọn Chủ đề',
              ),
              value: selectedTopic,
              items: const [
                DropdownMenuItem(value: '1', child: Text('Chủ đề 1')),
                DropdownMenuItem(value: '2', child: Text('Chủ đề 2')),
                DropdownMenuItem(value: '3', child: Text('Chủ đề 3')),
                DropdownMenuItem(value: '4', child: Text('Chủ đề 4')),
                DropdownMenuItem(value: '5', child: Text('Chủ đề 5')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTopic = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Chọn số câu',
              ),
              value: selectedNumberOfSentences,
              items: const [
                DropdownMenuItem(value: '1', child: Text('10 câu')),
                DropdownMenuItem(value: '2', child: Text('20 câu')),
                DropdownMenuItem(value: '3', child: Text('30 câu')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedNumberOfSentences = value;
                });
              },
            ),
            const SizedBox(height: 30),
            MenuButton(
              text: 'Bắt đầu chơi',
              onPressed: () {},
            ),
            // const SizedBox(height: 5),
            MenuButton(
              text: 'Chơi ngẫu nhiên',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
