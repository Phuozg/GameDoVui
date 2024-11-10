import 'package:dadd/phuong/controllers/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController code = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    final authentication = Get.put(Authentication());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt Lại Mật Khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: code,
              decoration: const InputDecoration(
                labelText: 'Mã xác minh',
              ),
            ),
            TextField(
              controller: newPassword,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu mới',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authentication.resetPassword(
                    context, code.text, newPassword.text);
              },
              child: const Text('Xác nhận mật khẩu mới'),
            ),
          ],
        ),
      ),
    );
  }
}
