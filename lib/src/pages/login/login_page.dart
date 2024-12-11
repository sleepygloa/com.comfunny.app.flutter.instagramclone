import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/%08app_instargram.dart';
import 'package:flutter_clone_instagram/src/app_wms.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/login/register_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  
  String? _selectedRole; // 선택된 역할을 저장할 변수
  final List<String> _roles = [
    '인스타그램',
    '물류센터관리',
    '배송기사',
  ]; // 역할 목록

  @override
  void initState() {
    super.initState();
    _selectedRole = _selectedRole?? _roles[0]; // 기본적으로 첫 번째 항목 선택
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }
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
    print(body);
    if (body == null) return;
    if (body['accessToken'] == null || body['refreshToken'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다'),
        ),
      );
      return;
    }

    // 로그인 성공 시 accessToken, refreshToken 저장
    await ApiService.setJwtToken(body['accessToken'], body['refreshToken']);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('_selectedRole', _selectedRole?? '인스타그램');

    // 앱 유형 선택 확인
    switch (_selectedRole) {
      case '인스타그램':
          // BottomNavController를 GetX에 등록
          Get.put(BottomNavController());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppInstargram()),
          );
        break;
      case '물류센터관리':
          // BottomNavController를 GetX에 등록
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppWms()),
          );
        break;
      case '배송기사':
        break;
    }


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
              // 드롭다운 메뉴 추가
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '사용자 역할 선택'),
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '역할을 선택하세요';
                  }
                  return null;
                },
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