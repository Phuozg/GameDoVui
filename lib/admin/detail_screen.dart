import 'package:dadd/admin/controller.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:flutter/material.dart';

class DetailQuestion extends StatefulWidget {
  const DetailQuestion({super.key, required this.questionID});
  final questionID;
  @override
  State<DetailQuestion> createState() => _DetailQuestionState();
}

class _DetailQuestionState extends State<DetailQuestion> {
  @override
  Widget build(BuildContext context) {
    //Hiển thị họp thoại sửa câu trả lời
    showAEditDialog(Option option) {
      TextEditingController content =
          TextEditingController(text: option.Content);
      showDialog(
          context: context,
          builder: (_) => StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Center(child: Text('Sửa câu trả lời')),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          controller: content,
                          decoration: InputDecoration(
                              label: Text(
                                'Nội dung câu trả lời',
                              ),
                              border: OutlineInputBorder()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Controller()
                                        .editOption(option.ID, content.text);
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text(
                                  'Sửa',
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text('Chi tiết câu hỏi'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountScreen()));
                },
                icon: const Icon(Icons.person_outline))
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          )),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 100, 20, 100),
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: FutureBuilder<List<Option>>(
                      future: Controller().getOptions(widget.questionID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          Controller().getOptions(widget.questionID);
                          List<Option> options = snapshot.data!;
                          return ListView.builder(
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              Option option = options[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.white,
                                ),
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      color: option.Accuracy
                                          ? Colors.green
                                          : Colors.red,
                                      child: Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showAEditDialog(option);
                                              },
                                              icon: Icon(Icons.edit)),
                                          Text(
                                            option.Content,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Không tìm thấy chủ đề nào.'));
                        }
                      },
                    ))
              ],
            ),
          ),
        ));
  }
}
