import 'package:dadd/Historys/ContentHistoryPage.dart';
import 'package:flutter/material.dart';

class Historypage extends StatelessWidget {
  const Historypage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Lịch Sử Chơi')),
        body: const CustomDialogContent(),
      ),
    );
  }
}

class CustomDialogContent extends StatefulWidget {
  const CustomDialogContent({super.key});

  @override
  _CustomDialogContentState createState() => _CustomDialogContentState();
}

class _CustomDialogContentState extends State<CustomDialogContent> {
  bool isPracticeMode = true;

  void toggleMode() {
    setState(() {
      isPracticeMode = !isPracticeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isPracticeMode = true),
                    child: Column(
                      children: [
                        Text(
                          'Chơi luyện tập',
                          style: TextStyle(
                            fontSize: 20,
                            color: isPracticeMode ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: isPracticeMode
                              ? Colors.black
                              : Colors.transparent,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isPracticeMode = false),
                    child: Column(
                      children: [
                        Text(
                          'Chơi nhiều người',
                          style: TextStyle(
                            fontSize: 20,
                            color: !isPracticeMode ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: !isPracticeMode
                              ? Colors.black
                              : Colors.transparent,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
                child: isPracticeMode
                    ? const ContentHistorypage(mode: "Single")
                    : const ContentHistorypage(mode: "Multiple")),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Quay lại'),
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
