
import 'package:dadd/views/ContentHistoryPage.dart';
import 'package:dadd/views/homepage.dart';
import 'package:flutter/material.dart';

class Historypage extends StatelessWidget {
  final String userID;
  const Historypage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Lịch Sử Chơi')),
        body: CustomDialogContent(userID: userID),
      ),
    );
  }
}

class CustomDialogContent extends StatefulWidget {
  final String userID;
  const CustomDialogContent({super.key, required this.userID});

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
                const SizedBox(height: 80),
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
                  ? ContentHistorypage(mode: "Single", userID: widget.userID)
                  : ContentHistorypage(mode: "Multiple", userID: widget.userID),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
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
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}
