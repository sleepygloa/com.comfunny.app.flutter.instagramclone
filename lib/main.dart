import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/%08splash/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

void main() async {
  // 
  WidgetsFlutterBinding.ensureInitialized();
  // 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String theme = prefs.getString('theme') ?? 'light';

  runApp(MyApp(initialTheme: theme));
}

class MyApp extends StatefulWidget {
  final String? initialTheme;

  const MyApp({super.key, required this.initialTheme});

  @override
  _MyAppState createState() => _MyAppState();

  // MyAppState에 접근할 수 있도록 하는 정적 메서드
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  String _theme;

  _MyAppState() : _theme = 'light';

  @override
  void initState() {
    super.initState();
    _theme = widget.initialTheme!;
  }

  void setTheme(String theme) {
    setState(() {
      _theme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: _theme == 'light' ? ThemeData.light() : ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
