import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dadd/login/admin_screen.dart';
import 'package:dadd/phuong/controllers/profile_controller.dart';
import 'package:dadd/phuong/views/welcome_screen.dart';
import 'package:dadd/views/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authentication extends GetxController {
  static Authentication get instance => Get.put(Authentication());

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitScreen);
  }

  _setInitScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      final profileController = Get.put(ProfileController());
      profileController.fetchData();
      if (profileController.user.value.Role == false) {
        Get.offAll(() => const HomePage());
      } else {
        Get.offAll(() => AdminDashboard());
      }
    }
  }

  Future<void> registerUser(String name, String usernamse, String password,
      BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: usernamse, password: password);
      if (firebaseUser.value != null) {
        final userID = userCredential.user!.uid;
        await db.collection('User').doc(userID).set({
          'ID': userID,
          'UserName': usernamse,
          'Password': password,
          'Name': name,
          'Avatar': '',
          'Exp': 0,
          'CreatedAt': Timestamp.now(),
          'Role': false
        });
      }
      firebaseUser.value != null
          ? Get.offAll(() => const HomePage())
          : Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = signUpWithEmailAndPasswordFailure(e.code);
      final snackBar = SnackBar(content: Text(ex));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (_) {}
  }

  Future<void> login(
      String usernamse, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: usernamse, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const HomePage())
          : Get.offAll(() => const WelcomeScreen());
    } catch (_) {}
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> changeName(String change, BuildContext context) async {
    try {
      final userID = auth.currentUser!.uid;
      if (userID.isNotEmpty) {
        await db.collection('User').doc(userID).update({'Name': change});
      }
      await ProfileController.instance.fetchData();
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> changePassword(String change, BuildContext context) async {
    try {
      final userID = auth.currentUser!.uid;
      if (userID.isNotEmpty) {
        await auth.currentUser!.updatePassword(change);
        await db.collection('User').doc(userID).update({'Password': change});
      }
      await ProfileController.instance.fetchData();
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  signUpWithEmailAndPasswordFailure(String code) {
    switch (code) {
      case 'weak-password':
        return 'Vui lòng chọn mật khẩu an toàn hơn';
      case 'invalid-email':
        return 'Tài khoản không đúng định dạng';
      case 'email-already-in-use':
        return '';
      case 'operation-not-allowed':
        return 'Tài khoản đã tồn tại';
      case 'user-disabled':
        return 'Người dùng này đã bị chặn';
      default:
        return;
    }
  }
}
