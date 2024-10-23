import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/controller/data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:flutter_clone_instagram/src/pages/profile/app_info_page.dart';
import 'package:flutter_clone_instagram/src/pages/profile/notification_settings_page.dart';
import 'package:flutter_clone_instagram/src/pages/profile/theme_settings_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget{
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting>{
  bool _isLoggedIn = false; //로그인 상태
  final DataController dataController = Get.put(DataController());

  //초기화
  @override
  void initState(){
    super.initState();
    _checkLoginStatus();
  }

  //로그인 상태 확인
  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  //로그아웃
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = false;
    });

    //로그아웃 후 로그인 페이지로 이동
    dataController.logout();
    Get.offAll(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            print('뒤로가기');
            // BottomNavController.to.willPopAction();
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(IconPath.backBtnIcon),
          ),
        ),
      ),
      body: ListView(
        children: _buildLoggedInSettings(),
      ),
    );
  }

  List<Widget> _buildLoggedInSettings() {
    return [
      ListTile(
        title: const Text('테마'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThemeSettingsPage()),
          );
        },
      ),
      ListTile(
        title: const Text('알림'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
          );
        },
      ),
      ListTile(
        title: const Text('비밀번호 변경'),
        onTap: () {
          // 비밀번호 변경 화면으로 이동하는 로직 추가
        },
      ),
      ListTile(
        title: const Text('앱 정보'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppInfoPage()),
          );
        },
      ),
      ListTile(
        title: const Text('로그아웃'),
        onTap: _logout,
      ),
    ];
  }

}
