import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  String? verificationId;

  Future<void> sendEmailVerification() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/email/send'),
      body: jsonEncode({'email': _emailController.text}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      setState(() {
        verificationId = jsonDecode(response.body)['verificationId'];
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('이메일로 인증 코드가 전송되었습니다.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('이메일 전송에 실패했습니다.'),
      ));
    }
  }

  Future<void> verifyCode() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/login/email/verify'),
      body: jsonEncode({
        'verificationId': verificationId,
        'code': _codeController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('인증에 성공했습니다!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('인증에 실패했습니다.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이메일 인증')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일 입력'),
            ),
            ElevatedButton(
              onPressed: sendEmailVerification,
              child: Text('인증 코드 보내기'),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: '인증 코드 입력'),
            ),
            ElevatedButton(
              onPressed: verifyCode,
              child: Text('인증 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
