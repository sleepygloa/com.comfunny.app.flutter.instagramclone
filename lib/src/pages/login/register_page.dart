import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

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
  final TextEditingController _verificationCodeController = TextEditingController();

  bool _isVerificationCodeSent = false;
  bool _isEmailVerified = false;

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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // 회원가입 로직 추가
    }
  }

  // 이메일 인증 메일 발송 API 호출
  Future<void> _sendEmailVerification(BuildContext context, String email) async {
    Map<String, dynamic>? body = await ApiService.sendApi(
      context, 
      '/login/email/send',
      {'email': email},);

    // 응답이 null이면 에러 메시지 출력
    if(body == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 인증에 실패했습니다. 다시 시도해주세요.')),
      );
      return;
    }

    // 응답이 성공이면 인증 이메일 발송 메시지 출력
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('인증 이메일이 발송되었습니다.')),
    );
    setState(() {
      _isVerificationCodeSent = true;
      _isEmailVerified = false;
    });
  }

  // 이메일 인증 코드 확인 API 호출
  Future<void> _verifyEmailCode(BuildContext context, String email, String code) async {
    Map<String, dynamic>? body = await ApiService.sendApi(
      context, 
      '/login/email/verify',
      {'email': email, 'code': code},
      );

    final result = body?['result'];
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
      );
      setState(() {
        _isEmailVerified = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호가 올바르지 않습니다. 다시 시도해주세요.')),
      );
    }
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
              // ID 입력 필드
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
              // 비밀번호 입력 필드
              TextFormField(
                controller: _pwController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: _validatePassword,
              ),
              // 이메일 입력 필드와 인증 버튼
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: '이메일'),
                      validator: _validateEmail,
                      onChanged: (value) {
                        setState(() {
                          _isVerificationCodeSent = false;
                          _isEmailVerified = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isEmailVerified ? null : () async {
                      if (_validateEmail(_emailController.text) == null) {
                        await _sendEmailVerification(context, _emailController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('유효한 이메일을 입력하세요')),
                        );
                      }
                    },
                    child: Text('이메일 인증'),
                  ),
                ],
              ),
              // 인증번호 입력 필드와 확인 버튼
              if (_isVerificationCodeSent && !_isEmailVerified) ...[
                // 인증번호 입력 필드
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _verificationCodeController,
                        decoration: InputDecoration(labelText: '인증번호 입력'),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _verifyEmailCode(context, _emailController.text, _verificationCodeController.text);
                      },
                      child: Text('이메일 확인'),
                    ),
                  ],
                ),
              ],
              // 전화번호 입력 필드
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: '전화번호'),
                validator: _validatePhoneNumber,
              ),
              SizedBox(height: 20),
              // 회원가입 버튼
              ElevatedButton(
                onPressed: _register,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 이메일 인증 화면 클래스 정의
class EmailVerificationScreen extends StatelessWidget {
  final String email;

  EmailVerificationScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이메일 인증'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('이메일 $email 로 인증 메일이 발송되었습니다.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}