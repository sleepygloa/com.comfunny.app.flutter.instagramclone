
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _sound = true;
  bool _vibration = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
      _sound = prefs.getBool('sound') ?? true;
      _vibration = prefs.getBool('vibration') ?? true;
    });
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', _pushNotifications);
    await prefs.setBool('sound', _sound);
    await prefs.setBool('vibration', _vibration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 설정'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('푸시 알림'),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
                _saveSettings();
              });
            },
          ),
          SwitchListTile(
            title: Text('알림 소리'),
            value: _sound,
            onChanged: (bool value) {
              setState(() {
                _sound = value;
                _saveSettings();
              });
            },
          ),
          SwitchListTile(
            title: Text('진동'),
            value: _vibration,
            onChanged: (bool value) {
              setState(() {
                _vibration = value;
                _saveSettings();
              });
            },
          ),
        ],
      ),
    );
  }
}