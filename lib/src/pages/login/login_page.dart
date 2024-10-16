import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/login/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    if (value.length < 10) {
      return '비밀번호는 최소 10자 이상이어야 합니다';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{10,}$').hasMatch(value)) {
      return '비밀번호는 영문 대문자, 영문 소문자, 숫자를 포함해야 합니다';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 로그인 로직 추가
                  }
                },
                child: Text('로그인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
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