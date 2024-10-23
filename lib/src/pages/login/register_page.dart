import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationEmailController = TextEditingController(); // 이메일 인증 코드 입력 필드
  final TextEditingController _verificationSmsController = TextEditingController(); // 이메일 인증 코드 입력 필드

  // 이메일 인증 관련 변수
  bool _isVerificationCodeSent = false; // 이메일 인증 코드 발송 여부
  bool _isEmailVerified = false; // 이메일 인증 완료 여부
  bool _isClickEmailSend = false; // 이메일 인증 버튼 클릭 여부

  // SMS 인증 관련 변수
  bool _isVerificationCodeSentSms = false; // SMS 인증 코드 발송 여부
  bool _isSmsVerified = false; // SMS 인증 완료 여부
  bool _isClickSmsSend = false; // SMS 인증 버튼 클릭 여부

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[\W_]).{8,}$').hasMatch(value)) {
      return '비밀번호는 영문 대문자, 영문 소문자, 숫자, 특수문자를 포함해야 합니다';
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

  // 회원가입 버튼 클릭 시 호출되는 함수
  Future<void> _register() async {
    // 폼 유효성 검사
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Map<String, dynamic>? body = await ApiService.sendApi(
      context,
      '/login/saveUser',
      {
        'userId': _idController.text,
        'password': _pwController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      },
    );

    if (body == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입에 실패했습니다. 다시 시도해주세요.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('회원가입이 완료되었습니다.')),
    );

    Navigator.pop(context);
  }

  // 이메일 인증 메일 발송 API 호출
  Future<void> _sendEmailVerification(BuildContext context, String email) async {
    Map<String, dynamic>? body = await ApiService.sendApi(
      context,
      '/login/email/send',
      {'email': email},
    );

    if (body == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 인증에 실패했습니다. 다시 시도해주세요.')),
      );
      return;
    }

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

  // SMS 인증 메일 발송 API 호출
  Future<void> _sendSmsVerification(BuildContext context, String phone) async {
    Map<String, dynamic>? body = await ApiService.sendApi(
      context,
      '/sms/naver/send',
      {'phone': phone},
    );

    if (body == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS 인증에 실패했습니다. 다시 시도해주세요.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SMS 인증 코드가 발송되었습니다.')),
    );
    setState(() {
      _isVerificationCodeSentSms = true;
      _isSmsVerified = false;
    });
  }

  // SMS 인증 코드 확인 API 호출
  Future<void> _verifySmsCode(BuildContext context, String phone, String code) async {
    Map<String, dynamic>? body = await ApiService.sendApi(
      context,
      '/sms/naver/verify',
      {'phone': phone, 'code': code},
    );

    final result = body?['result'];
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS 인증이 완료되었습니다.')),
      );
      setState(() {
        _isSmsVerified = true;
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
                          _isClickEmailSend = false;
                          _verificationEmailController.clear(); // 인증 코드 입력 필드 초기화
                    });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  // 이메일 인증 버튼 클릭 시 유효성 검사 추가
                  ElevatedButton(
                    onPressed: _isClickEmailSend ? null : () async {
                      // 이메일 유효성 검사
                      String? emailValidationResult = _validateEmail(_emailController.text);
                      if (emailValidationResult != null) {
                        // 이메일이 유효하지 않으면 에러 메시지 출력
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(emailValidationResult)),
                        );
                        return; // 유효하지 않은 경우 함수 종료
                      }
                      
                      // 이메일이 유효한 경우, 인증 메일 발송
                      await _sendEmailVerification(context, _emailController.text);
                      setState(() {
                        _isVerificationCodeSent = true; // 인증 메일 발송 상태로 변경
                        _isClickEmailSend = true; // 인증 메일 발송 버튼 클릭 상태로 변경
                      });
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
                        controller: _verificationEmailController,
                        decoration: InputDecoration(labelText: '인증번호 입력'),

                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _verifyEmailCode(context, _emailController.text, _verificationEmailController.text);
                      },
                      child: Text('이메일 확인'),
                    ),
                  ],
                ),
              ],
              // 전화번호 입력 필드
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: '전화번호'),
                      validator: _validatePhoneNumber,
                      onChanged: (value) {
                        setState(() {
                          _isVerificationCodeSentSms = false; // SMS 인증 코드 발송 여부 초기화
                          _isSmsVerified = false; // SMS 인증 완료 여부 초기화
                          _isClickSmsSend = false; // SMS 인증 버튼 클릭 여부 초기화
                          _verificationSmsController.clear(); // 인증 코드 입력 필드 초기화
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isClickSmsSend ? null : () async {
                      if (_validatePhoneNumber(_phoneController.text) != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('유효한 전화번호를 입력하세요')),
                        );
                      }

                      await _sendSmsVerification(context, _phoneController.text);
                      setState(() {
                        _isVerificationCodeSentSms = true;
                        _isClickSmsSend = true;
                      });
                    },
                    child: Text('SMS 인증'),
                  ),
                ],
              ),
              // 인증번호 입력 필드와 확인 버튼
              if (_isVerificationCodeSentSms && !_isSmsVerified) ...[
                // 인증번호 입력 필드
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _verificationSmsController,
                        decoration: InputDecoration(labelText: '인증번호 입력'),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _verifySmsCode(context, _phoneController.text, _verificationSmsController.text);
                      },
                      child: Text('SMS 확인'),
                    ),
                  ],
                ),
              ],
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

  const EmailVerificationScreen({super.key, required this.email});

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