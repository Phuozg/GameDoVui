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
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    labelText: 'Chọn chủ đề',
                    labelStyle: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    labelText: 'Chọn số câu',
                    labelStyle: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 45),
                MenuButton(
                  text: 'Bắt đầu chơi',
                  onPressed: () {},
                ),
                MenuButton(
                  text: 'Chơi ngẫu nhiên',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
