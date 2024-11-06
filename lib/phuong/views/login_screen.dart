import 'package:dadd/phuong/controllers/auth.dart';
import 'package:dadd/phuong/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    RxBool hidePassword = true.obs;
    final authentication = Get.put(Authentication());
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
                const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
                  controller: username,
                  decoration: const InputDecoration(
                      labelText: 'Tài khoản', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return TextField(
                    controller: password,
                    obscureText: hidePassword.value,
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
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/image/google_logo.png',
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      onPressed: () {
                        authentication.login(
                            username.text, password.text, context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(200, 40)),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Container(
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chưa có tài khoản?',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            ' Đăng ký',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
