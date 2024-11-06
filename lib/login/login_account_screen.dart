import 'package:dadd/login/admin_screen.dart';
import 'package:dadd/login/forgot_password_screen.dart';
import 'package:dadd/login/register_screen.dart';
import 'package:dadd/views/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đăng Nhập',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //chuyển hướng người chơi
  void _test() {
    if (usernameController.text == 'player' &&
        passwordController.text == '123') {
      // Chuyển sang giao diện Admin
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void _login() {
    if (usernameController.text == 'admin' &&
        passwordController.text == '123') {
      // Chuyển sang giao diện Admin
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      // Cho phép đăng nhập khi nhấn Enter
      passwordController.selection = TextSelection.fromPosition(
          TextPosition(offset: passwordController.text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Nền giao diện với hình ảnh
          Image.asset(
            'assets/image/background2.png', // Hình ảnh nền
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black54, // Nền tối để làm nổi bật các widget
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Đăng Nhập',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Tài khoản',
                          labelStyle: TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        onSubmitted: (value) => _login(),
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          labelStyle: TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                              // Chuyển sang giao diện quên mật khẩu
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          IconButton(
                            icon: Image.asset('assets/image/google_logo.png',
                                height: 30), // Thay đổi link hình ảnh Google
                            onPressed: () {
                              // Đăng ký bằng Google
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Màu chữ
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Đăng Nhập'),
                      ),

                      /// Chưa có tài khoản bắt đầu đăng ký
                      TextButton(
                        onPressed: () {
                          // Chuyển sang giao diện Đăng ký
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                          );
                        },
                        child: Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),

                      /// nút test chuyển thẳng vào trang người dùng
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _test,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Màu chữ
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Test'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
