
import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('앱 이름: 컴퍼니디벨로퍼 MyFavoriteApp', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('버전: 1.0.0', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('개발자: 김도노', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('라이선스 정보:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text('이 앱은 오픈 소스 라이브러리를 사용합니다.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('연락처: sleepygloa@gmail.com', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}