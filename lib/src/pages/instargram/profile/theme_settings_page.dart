import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  String _selectedTheme = 'light';

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTheme = prefs.getString('theme') ?? 'light';
    });
  }

  _saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    setState(() {
      _selectedTheme = theme;
    });
    // 테마 변경 시 MyApp 위젯을 다시 빌드하여 테마를 적용
    MyApp.of(context)?.setTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테마 설정'),
      ),
      body: ListView(
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('라이트 테마'),
            value: 'light',
            groupValue: _selectedTheme,
            onChanged: (String? value) {
              if (value != null) {
                _saveTheme(value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('다크 테마'),
            value: 'dark',
            groupValue: _selectedTheme,
            onChanged: (String? value) {
              if (value != null) {
                _saveTheme(value);
              }
            },
          ),
        ],
      ),
    );
  }
}