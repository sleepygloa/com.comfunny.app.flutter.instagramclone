import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/MyPost.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InstargramDataController extends GetxController {
  var apiData = {}.obs; // API 데이터 상태
  var isLoading = false.obs; // 로딩 상태

  bool getNullCheckApiData(str){
    if(str == null || str == ''){
      return false;
    }
    return true;
  }

  // API 데이터 업데이트 메서드
  void updateApiData(Map<String, dynamic> newData) {
    apiData.value = newData;
  }


  //기본 정보 
  Future<Map?> getBasicData(BuildContext context) async {
    //기본 데이터
    var result = await ApiService.sendApi(context, '/api/instargram/mypage/selectMyPage', {});

    if(result != null) {
      //기본 데이터
      apiData["userName"] = result["userName"];
      apiData["description"] = result["description"];
      apiData["thumbnailPth"] = result["thumbnailPth"];
      apiData["thumbnailName"] = result["thumbnailName"];
      //포스트, 팔로워, 팔로잉 수
      apiData["followerCnt"] = result["followerCnt"];
      apiData["followingCnt"] = result["followingCnt"];
      apiData["postCnt"] = result["postCnt"];
      apiData["myPostList"] = result["myPostList"];
      // print('apiData:: $apiData');
      // print('apiData:: ${apiData["myPostList"]}');
      apiData.refresh();
      return apiData;
    }
    
    return null;
  }

  // 로그인시 앱 콤보 선택 데이터 가져오기 _selectedRole
  Future<String> getSelectedRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString('_selectedRole') ?? '인스타그램';
    return status;
  }
}