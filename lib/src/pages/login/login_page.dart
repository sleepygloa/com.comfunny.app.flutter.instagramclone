import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/app.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/login/register_page.dart';
import 'package:get/get.dart';

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
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{10,}$').hasMatch(value)) {
    //   return '비밀번호는 영문 대문자, 영문 소문자, 숫자를 포함해야 합니다';
    // }
    return null;
  }


  // 로그인 버튼 클릭 시 호출되는 함수
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    // 로그인 API 호출 
    Map<String, dynamic>? body = await ApiService.sendApi(
      context, 
      '/login/login',
      {
        'userId': _idController.text,
        'password': _pwController.text,
      },
    );

    if (body == null) return;

    if(body['accessToken'] == null || body['refreshToken'] == null ){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다'),
        ),
      );
      return;
    }

    // 로그인 성공 시 accessToken, refreshToken 저장
    await ApiService.setJwtToken(body['accessToken'], body['refreshToken']);

    // BottomNavController를 GetX에 등록
    Get.put(BottomNavController());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => App()), // 로그인 성공 시 App 화면으로 전환
    );
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
                onPressed: _login,
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