import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/%08app_instargram.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/controller/data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DataController dataController = Get.put(DataController());


  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // 로그인 상태 확인
    bool isLoggedIn = await dataController.checkLoginStatus();

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
    Get.put(BottomNavController());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AppInstargram()),
    );
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