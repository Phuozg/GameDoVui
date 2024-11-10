import 'package:dadd/admin/controller.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:flutter/material.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  @override
  Widget build(BuildContext context) {
    //Hiển thị họp thoại thêm chủ đề
    showAddDialog() {
      showDialog(
          context: context,
          builder: (_) {
            TextEditingController topicText = TextEditingController();
            return AlertDialog(
              title: const Center(
                  child: Text(
                'Thêm chủ đề mới',
                textAlign: TextAlign.center,
              )),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: topicText,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), label: Text("Tên")),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              try {
                                setState(() {
                                  //Giải thích tương tự như file user_screen.dart
                                  Controller().addTopic(topicText.text);
                                  Controller().getTopics();
                                });
                                Navigator.of(context).pop();
                              } catch (e) {}
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text(
                              'Xác nhận',
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text(
                              'Không',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }

    //Hiển thị họp thoại thông báo xác nhận muốn xóa chủ đề hay không
    showDeleteDialog(String topicID) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(
                    child: Text(
                  'Bạn có chắc chắn muốn xóa chủ đề này này',
                  textAlign: TextAlign.center,
                )),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                try {
                                  setState(() {
                                    //Giải thích tương tự như file user_screen.dart
                                    Controller().deleteTopic(topicID);
                                    Controller().getTopics();
                                  });
                                  Navigator.of(context).pop();
                                } catch (e) {}
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text(
                                'Xác nhận',
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                'Không',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    //Hiển thị họp thoại sửa chủ đề
    showEditDialog(String topicID) {
      showDialog(
          context: context,
          builder: (_) {
            TextEditingController topicText = TextEditingController();
            return AlertDialog(
              title: const Center(
                  child: Text(
                'Sửa chủ đề',
                textAlign: TextAlign.center,
              )),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: topicText,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), label: Text("Tên")),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              try {
                                setState(() {
                                  //Giải thích tương tự như file user_screen.dart
                                  Controller()
                                      .editTopic(topicText.text, topicID);
                                  Controller().getTopics();
                                });
                                Navigator.of(context).pop();
                              } catch (e) {}
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text(
                              'Xác nhận',
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text(
                              'Không',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text('Quản lý chủ đề'),
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
                  fit: BoxFit.cover)),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      showAddDialog();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'Thêm chủ đề',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: FutureBuilder<List<TopicModel>>(
                      future: Controller().getTopics(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          Controller().getUsers();
                          List<TopicModel> topics = snapshot.data!;
                          return ListView.builder(
                            itemCount: topics.length,
                            itemBuilder: (context, index) {
                              TopicModel topic = topics[index];
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
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            topic.TopicName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            //Giải thích tương tự như file user_screen.dart
                                            showEditDialog(topic.ID);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            //Giải thích tương tự như file user_screen.dart
                                            showDeleteDialog(topic.ID);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    )
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
