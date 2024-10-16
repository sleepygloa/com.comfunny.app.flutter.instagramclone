import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String serverUrl = 'http://localhost:8080';

  static Future<Map<String, dynamic>?> sendApi(BuildContext context, String url, Map<String, Object> body) async {
    String combineUrl = serverUrl+url;
    final response = await http.post(
      Uri.parse(combineUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    // 200 OK가 아닌 경우
    if(response.statusCode != 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버와의 통신에 실패했습니다.')),
      );
      return null;
    }

    // 200 OK
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody;
  }
}