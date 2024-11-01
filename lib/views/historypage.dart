import 'package:flutter/material.dart';

class CustomDialogContent extends StatefulWidget {
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
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Lịch sử chơi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                          fontSize: 16,
                          color: isPracticeMode ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color:
                            isPracticeMode ? Colors.black : Colors.transparent,
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
                          fontSize: 16,
                          color: !isPracticeMode ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color:
                            !isPracticeMode ? Colors.black : Colors.transparent,
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
            child: Center(
              child: Text(
                isPracticeMode
                    ? 'Nội dung chơi luyện tập'
                    : 'Nội dung chơi nhiều người',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
