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

  // API 요청 메서드
  static Future<Map<String, dynamic>?> sendApi(BuildContext context, String url, dynamic body) async {
    // JWT 토큰 가져오기
    String? accessToken = await getAccessToken();
    // 서버 URL과 요청 URL 결합
    String combineUrl = serverUrl + url;
    // HTTP POST 요청 보내기
    final response = await http.post(
      Uri.parse(combineUrl),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    // 200 OK가 아닌 경우
    if (400 <= response.statusCode && response.statusCode < 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와의 통신에 실패했습니다.')),
      );
      return null;
    }

    //repsonse.body를 Map<String, dynamic>으로 변환
    if(response.body == ''){
      return {};
    }
    // 200 OK
    var responseBody = jsonDecode(response.body);
    if (responseBody is List) {
      return {'data': List<Map<String, dynamic>>.from(responseBody)};
    }else{
      // 메시지 리턴
      if (responseBody['msgTxt'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['msgTxt'])),
        );
        return null;
      }
    }

    return responseBody;
  }

  // GET 방식 API 요청 메서드
  static Future<Map<String, dynamic>?> getApi(BuildContext context, String url) async {
    // JWT 토큰 가져오기
    String? accessToken = await getAccessToken();
    // 서버 URL과 요청 URL 결합
    String combineUrl = serverUrl + url;
    // HTTP GET 요청 보내기
    final response = await http.get(
      Uri.parse(combineUrl),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    // 200 OK가 아닌 경우
    if (400 <= response.statusCode && response.statusCode < 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와의 통신에 실패했습니다.')),
      );
      return null;
    }

    // 200 OK
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    // 메시지 리턴
    if (responseBody['msgTxt'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['msgTxt'])),
      );
      return null;
    }

    return responseBody;
  }
}