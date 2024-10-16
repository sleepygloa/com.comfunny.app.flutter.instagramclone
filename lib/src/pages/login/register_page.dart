import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(value)) {
      return '비밀번호는 영문 대문자, 영문 소문자, 숫자를 포함해야 합니다';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력하세요';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '유효한 이메일 형식을 입력하세요';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력하세요';
    }
    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return '유효한 전화번호 형식을 입력하세요';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID를 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pwController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '이메일'),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: '전화번호'),
                validator: _validatePhoneNumber,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 회원가입 로직 추가
                  }
                },
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}