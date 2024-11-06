import 'package:dadd/phuong/views/login_screen.dart';
import 'package:dadd/phuong/views/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GAME',
                style: TextStyle(
                    fontSize: 100,
                    color: Colors.blue,
                    fontWeight: FontWeight.w900),
              ),
              Stack(
                children: <Widget>[
                  Text(
                    'ĐỐ VUI',
                    style: TextStyle(
                      fontSize: 60,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.blue,
                    ),
                  ),
                  const Text(
                    'ĐỐ VUI',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width / 1.5, 50)),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: const Text(
                      'Chưa có tài khoản?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
