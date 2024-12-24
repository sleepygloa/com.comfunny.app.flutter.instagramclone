import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/%08app_instargram.dart';
import 'package:flutter_clone_instagram/src/app_wms.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_login_controller.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var dataController = Get.put(InstargramDataController());
  var loginController = Get.put(InstargramLoginController());
  // var uploadController = Get.put(UploadController());


  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // 로그인 상태 확인
    bool isLoggedIn = await loginController.checkLoginStatus();

    // 로그인 상태가 아닐 경우 로그인 페이지로 이동
    if (!isLoggedIn) {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }

    // 로그인 상태일 경우 홈 화면으로 이동
    await Future.delayed(Duration(seconds: 3), () {});

    String selectedRole = await dataController.getSelectedRole();
    switch (selectedRole) {
      case '인스타그램':
        Get.put(BottomNavController());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppInstargram()),
        );
        break;
      case '물류센터관리':
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}