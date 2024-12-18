import 'package:dadd/admin/controller.dart';
import 'package:dadd/admin/question_screen.dart';
import 'package:dadd/admin/topic_screen.dart';
import 'package:dadd/phuong/views/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    //Hiển thị họp thoại thông báo xác nhận muốn xóa người dùng hay không
    showDeleteDialog(String userID) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(
                    child: Text(
                  'Bạn có chắc chắn muốn xóa người dùng này',
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
                                    Controller().deleteUser(userID);
                                    Controller().getUsers();
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

    //Hiển thị họp thoại cập nhật thông tin người dùng
    showEditDialog(UserModel user) {
      showDialog(
          context: context,
          builder: (_) {
            TextEditingController name = TextEditingController(text: user.Name);
            TextEditingController exp =
                TextEditingController(text: user.Exp.toString());
            return AlertDialog(
              title: const Center(
                  child: Text(
                'Cập nhật thông tin người dùng',
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
                        controller: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), label: Text("Tên")),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: exp,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Kinh nghiệm")),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              try {
                                setState(() {
                                  Controller().editUser(
                                      user.ID, name.text, int.parse(exp.text));
                                  Controller().getUsers();
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

    Controller().getTopics();
    Controller().getQuestion();
    Controller().getUsers();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Quản lý người dùng'),
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
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: FutureBuilder<List<UserModel>>(
                    future: Controller().getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        Controller().getUsers();
                        List<UserModel> users = snapshot.data!;
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            UserModel user = users[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Builder(builder: (context) {
                                    if (user.Avatar.isEmpty) {
                                      return const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/image/avatar.jpg'),
                                        minRadius: 30,
                                        maxRadius: 30,
                                      );
                                    } else {
                                      return CircleAvatar(
                                        backgroundImage: MemoryImage(
                                            Controller().displayImageFromBase64(
                                                user.Avatar)),
                                        minRadius: 30,
                                        maxRadius: 30,
                                      );
                                    }
                                  }),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Tên: ${user.Name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Email: ${user.UserName}'),
                                        Text('Cấp độ: ${user.Exp ~/ 1000}'),
                                        Text(
                                            'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(user.CreatedAt.toDate())}')
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showEditDialog(user);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDeleteDialog(user.ID);
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
                            child: Text('Không tìm thấy người dùng.'));
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.blue,
      );
  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(16),
        child: Wrap(runSpacing: 16, children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Quản lý người dùng'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const UserScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('Quản lý chủ đề'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TopicScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('Quản lý câu hỏi'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuestionScreen()));
            },
          ),
        ]),
      );
}
