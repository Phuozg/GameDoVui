import 'package:dadd/phuong/controllers/auth.dart';
import 'package:dadd/phuong/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authentication = Get.put(Authentication());
    TextEditingController name = TextEditingController();
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController rePassword = TextEditingController();
    RxBool hidePassword = true.obs;
    RxBool hideRePassword = true.obs;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/background.jpg'),
                  fit: BoxFit.cover)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      labelText: 'Tên hiển thị', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: username,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("^[\u0000-\u007F]+\$"))
                  ],
                  decoration: const InputDecoration(
                      labelText: 'Tài khoản', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return Column(
                    children: [
                      TextField(
                        controller: password,
                        obscureText: hidePassword.value,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("^[\u0000-\u007F]+\$"))
                        ],
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              hidePassword.value = !hidePassword.value;
                            },
                            icon: Icon(hidePassword.value == true
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: rePassword,
                        obscureText: hideRePassword.value,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("^[\u0000-\u007F]+\$"))
                        ],
                        decoration: InputDecoration(
                          labelText: 'Nhập lại mật khẩu',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              hideRePassword.value = !hideRePassword.value;
                            },
                            icon: Icon(hideRePassword.value == true
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          'Đã có tài khoản?',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      onPressed: () {
                        if (name.text.isEmpty ||
                            password.text.isEmpty ||
                            username.text.isEmpty ||
                            rePassword.text.isEmpty) {
                          const snackBar = SnackBar(
                              content: Text('Vui lòng nhập đầy đủ thông tin'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (rePassword.text != password.text) {
                          const snackBar = SnackBar(
                              content:
                                  Text('Nhập lại mật khẩu của bạn không đúng'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          authentication.registerUser(
                              name.text, username.text, password.text, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(200, 40)),
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
