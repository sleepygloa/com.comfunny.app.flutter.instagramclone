import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
      if(401 == response.statusCode){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인이 필요합니다.')),
        );
            
        //로그아웃 후 로그인 페이지로 이동
        // dataController.logout();
        Get.offAll(() => LoginPage());
        return null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버와의 통신에 실패했습니다.')),
        );
        return null;
      }

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

  // API 요청 메서드
  static Future<Map<String, dynamic>?> sendApiFile(
    BuildContext context, String url, Map<String, dynamic> body) async {

    // JWT 토큰 가져오기
    String? accessToken = await getAccessToken();
    // 서버 URL과 요청 URL 결합
    String combineUrl = serverUrl + url;

    // HTTP POST 요청 만들기
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(combineUrl),
    );
    

    request.headers.addAll({
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    });


    // 여러 파일 추가
    if (body["filelist"] != null) {
      List<Uint8List> imagePaths = body["filelist"];
    for (int i = 0; i < imagePaths.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'filelist', // 서버에서 받을 필드명 (다중 처리 시 주의)
          imagePaths[i],
          filename: 'image_$i.jpg', // 고유 파일 이름 설정
          contentType: MediaType('image', 'jpeg'), // MIME 타입 설정
        ),
      );
    }

      try {
        final streamedResponse = await request.send();

        // 응답 상태 확인
        if (400 <= streamedResponse.statusCode && streamedResponse.statusCode < 500) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('서버와의 통신에 실패했습니다.')),
          );
          return null;
        }

        // 스트림 데이터를 문자열로 변환
        final responseBodyString = await streamedResponse.stream.bytesToString();

        // 문자열 데이터를 JSON으로 파싱
        Map<String, dynamic> responseBody = jsonDecode(responseBodyString);
        // 메시지 처리
        if (responseBody['msgTxt'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['msgTxt'])),
          );
          return null;
        }

        return responseBody;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
        return null;
      }
    }
  }


    // 파일 업로드 메서드
  static Future<String?> uploadFile(BuildContext context, String filePath) async {
    String? accessToken = await getAccessToken();
    String uploadUrl = '$serverUrl/api/upload'; // 파일 업로드 엔드포인트

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(uploadUrl),
    );

    request.headers.addAll({
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    });

    // 파일 추가
    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );

    try {
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseBodyString = await streamedResponse.stream.bytesToString();
        final response = jsonDecode(responseBodyString);
        return response['fileUrl']; // 서버에서 반환된 파일 URL
      } else {
        print('파일 업로드 실패: ${streamedResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('파일 업로드 중 오류 발생: $e');
      return null;
    }
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