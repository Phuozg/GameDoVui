import 'package:dadd/phuong/controllers/auth.dart';
import 'package:dadd/phuong/views/confirm_reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
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
                  'Quên mật khẩu',
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
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      onPressed: () async {
                        await authentication.sendPasswordResetEmail(
                            context, username.text);
                        
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(200, 40)),
                      child: const Text(
                        'Lấy lại mật khẩu',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
