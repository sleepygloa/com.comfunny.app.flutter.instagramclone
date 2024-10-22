import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String serverUrl = 'http://localhost:8080';

  // JWT 토큰 저장 메서드
  static Future<void> setJwtToken(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // JWT 토큰 가져오기 메서드
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // JWT 토큰 삭제 메서드
  static Future<void> removeJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  static Future<Map<String, dynamic>?> sendApi(BuildContext context, String url, Map<String, Object> body) async {
    String? accessToken = await getAccessToken();
    String combineUrl = serverUrl+url;
    final response = await http.post(
      Uri.parse(combineUrl),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      body: jsonEncode(body),
    );

    // 200 OK가 아닌 경우
    if(400 <= response.statusCode && response.statusCode < 500){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와의 통신에 실패했습니다.')),
      );
      return null;
    }

    // 200 OK
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    //메시지 리턴
    if(responseBody['msgTxt'] != null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['msgTxt'])),
      );
      return null;
    }

    return responseBody;
  }
}