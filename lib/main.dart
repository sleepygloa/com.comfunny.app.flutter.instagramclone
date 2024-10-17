import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/app.dart';
import 'package:flutter_clone_instagram/src/pages/%08splash/splash_page.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isSplashedIn = prefs.getBool('isSplashedIn') ?? false;

  runApp(MyApp(isSplashedIn:isSplashedIn, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isSplashedIn;
  

  const MyApp({super.key, required this.isSplashedIn, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
        ),
      ),
      // home: SplashScreen(),
      // home: LoginPage(),
      // home: App(),
      home: SplashScreen(),
    );
  }
}
