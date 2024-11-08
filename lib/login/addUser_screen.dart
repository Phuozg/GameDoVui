import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Sử dụng để tạo ID ngẫu nhiên
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();
  final ImagePicker _picker = ImagePicker();

  String _name = '';
  String _userName = '';
  String _role = 'User'; // Mặc định là 'User'
  String _avatar = '';
  String _password = '';
  int _exp = 0;
  bool role = false;

  // Danh sách các vai trò
  List<String> roles = ['User', 'Admin'];

  // Hàm chọn ảnh từ bộ nhớ
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Đọc ảnh và chuyển thành chuỗi base64
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        _avatar = base64Encode(bytes);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã chọn ảnh đại diện thành công')),
      );
    }
  }

  // Hàm thêm người dùng vào Firestore
  Future<void> addUser() async {
    try {
      if (_role == 'Admin') role = true; // Sửa lại phép gán
      String id = _uuid.v4(); // Tạo ID ngẫu nhiên
      await _firestore.collection('User').doc(id).set({
        'ID': id,
        'Name': _name,
        'UserName': _userName,
        'Exp': _exp,
        'Role': role,
        'Avatar': _avatar,
        'Password': _password,
        'CreateAt': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Người dùng đã được thêm thành công')),
      );
      _formKey.currentState!.reset(); // Reset form sau khi thêm
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi khi thêm người dùng: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm người dùng"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name field
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên người dùng'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người dùng';
                  }
                  return null;
                },
              ),
              // UserName field
              TextFormField(
                decoration: InputDecoration(labelText: 'Gmail đăng nhập'),
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),
              // Password field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              // Button chọn ảnh đại diện
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn ảnh đại diện từ bộ nhớ'),
              ),
              _avatar.isNotEmpty
                  ? Text('Ảnh đã được chọn',
                      style: TextStyle(color: Colors.green))
                  : Text('Chưa chọn ảnh', style: TextStyle(color: Colors.red)),
              // Role field
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Chọn vai trò'),
                value: _role,
                items: roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addUser();
                  }
                },
                child: Text('Thêm người dùng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
