import 'package:dadd/phuong/controllers/auth.dart';
import 'package:dadd/phuong/controllers/profile_controller.dart';
import 'package:dadd/views/expContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = Get.put(Authentication());
    final profileController = Get.put(ProfileController());
    profileController.fetchData();
    TextEditingController name =
        TextEditingController(text: profileController.user.value.Name);
    TextEditingController password = TextEditingController();
    TextEditingController repassword = TextEditingController();
    showEditNameDialog() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(child: Text('Đổi tên người dùng')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        controller: name,
                        decoration: const InputDecoration(
                            labelText: 'Tên người dùng',
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await authentication.changeName(
                                    name.text, context);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
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
                                'Hủy',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    showEditPasswordDialog() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(child: Text('Đổi mật khẩu')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                            labelText: 'Mật khẩu cũ',
                            border: OutlineInputBorder()),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                            labelText: 'Mật khẩu mới',
                            border: OutlineInputBorder()),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                            labelText: 'Nhập lại mật khẩu mới',
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (password.text.isEmpty ||
                                    repassword.text.isEmpty) {
                                  const snackBar = SnackBar(
                                      content: Text(
                                          'Vui lòng nhập đầy đủ thông tin'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (repassword.text != password.text) {
                                  const snackBar = SnackBar(
                                      content: Text(
                                          'Nhập lại mật khẩu của bạn không đúng'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  authentication.changePassword(
                                      password.text, context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
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
                                'Hủy',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    showLogOutDialog() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Center(
                    child: Text(
                  'Bạn có chắc chắn muốn đăng xuất',
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
                                authentication.logout();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
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
                                'Hủy',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 50,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover)),
          child: Container(
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expcontainer(
                      user: profileController.user.value,
                    ),
                    Column(
                      children: [
                        Builder(builder: (context) {
                          if (profileController.user.value.Avatar.isEmpty) {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/image/avatar.jpg'),
                              minRadius: 50,
                              maxRadius: 100,
                            );
                          } else {
                            return CircleAvatar(
                              backgroundImage: MemoryImage(
                                  profileController.displayImageFromBase64(
                                      profileController.user.value.Avatar)),
                              minRadius: 50,
                              maxRadius: 100,
                            );
                          }
                        }),
                        ElevatedButton(
                            onPressed: () {
                              profileController.pickAndUploadImage(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              'Sửa',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tên người dùng',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                profileController.user.value.Name,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              showEditNameDialog();
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tài khoản',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                truncateText(
                                    profileController.user.value.UserName),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mật khẩu',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '************',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              showEditPasswordDialog();
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            showLogOutDialog();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(200, 40)),
                          child: const Text(
                            'Đăng xuất',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    )
                  ],
                );
              })),
        ));
  }

  String truncateText(String text) {
    if (text.length > 20) {
      return '${text.substring(0, 20)}...';
    } else {
      return text;
    }
  }
}
