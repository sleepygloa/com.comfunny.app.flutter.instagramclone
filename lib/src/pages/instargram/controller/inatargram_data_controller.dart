import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_page_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InstargramDataController extends GetxController {
  RxBool isLoading = false.obs;
  // var apiData = {}.obs; // API 데이터 상태
  Rx<MyProfile> myProfile = MyProfile().obs; // 내 프로필 데이터 상태
  List<PostDto> myPostList = <PostDto>[].obs; // 내 포스트 데이터 상태
  List<PostDto> postList = <PostDto>[].obs; // 게시물 데이터 상태

  bool getNullCheckApiData(str){
    if(str == null || str == ''){
      return false;
    }
    return true;
  }

  //기본 정보 
  Future<void> getBasicData(BuildContext context) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    var result = await ApiService.sendApi(context, '/api/instargram/mypage/selectMyPage', {});
    if(result != null) {
      myProfile.value = MyProfile.fromJson(result);

      //게시물 리스트
      myPostList.assignAll(
        result["myPostList"].map<PostDto>((data) => PostDto.fromJson(data)).toList()
      );
    }
    
    // print('getBasicData result : $result');
    isLoading.value = false; // 로딩 완료
  }

  //포스트정보
  Future<void> getPostList(BuildContext context) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    var result = await ApiService.sendApi(context, '/api/instargram/mypage/selectPostList', {});
    if(result != null) {
      //게시물 리스트
      postList.assignAll(
        result["myPostList"].map<PostDto>((data) => PostDto.fromJson(data)).toList()
      );
    }

    // print('getPostList result : $result');
    isLoading.value = false; // 로딩 완료
  }

  // 로그인시 앱 콤보 선택 데이터 가져오기 _selectedRole
  Future<String> getSelectedRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString('_selectedRole') ?? '인스타그램';
    return status;
  }

  //공유 하기/중단 API 호출
  Future<void> sharePost(BuildContext context, String postNo, String shareYn) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    var result = await ApiService.sendApi(context, '/api/instargram/mypage/sharePost', {
      'postNo': postNo,
      'shareYn': shareYn
    });
    if(result != null) {
      //게시물 리스트
      myPostList.assignAll(
        result["myPostList"].map<PostDto>((data) => PostDto.fromJson(data)).toList()
      );
    }

    // print('sharePost result : $result');
    isLoading.value = false; // 로딩 완료
  }

  //게시글 표시여부 API 호출
  Future<void> saveDisplayYn(BuildContext context, PostDto post) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    String displayYn = post.displayYn == "Y" ? "N" : "Y";
    var result = await ApiService.sendApi(context, '/api/instargram/post/saveDisplayYn', {
      'postNo': post.postNo,
      'displayYn': displayYn
    });
    if(result != null) {
      post.displayYn = displayYn;
    }
    isLoading.value = false; // 로딩 완료
  }
  //게시글 좋아요수표시여부 API 호출
  Future<void> saveLikeDisplayYn(BuildContext context, PostDto post) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    String likeDisplayYn = post.likeDisplayYn == "Y" ? "N" : "Y";
    print('post.postNo : ${post.likeDisplayYn}');
    var result = await ApiService.sendApi(context, '/api/instargram/post/saveLikeDisplayYn', {
      'postNo': post.postNo,
      'likeDisplayYn': likeDisplayYn
    });
    if(result != null) {
      post.likeDisplayYn = likeDisplayYn;
    }
    isLoading.value = false; // 로딩 완료
  }
  //게시글 댓글기능표시여부 API 호출
  Future<void> saveCommentDisplayYn(BuildContext context, PostDto post) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    String commentDisplayYn = post.commentDisplayYn == "Y" ? "N" : "Y";
    var result = await ApiService.sendApi(context, '/api/instargram/post/saveCommentDisplayYn', {
      'postNo': post.postNo,
      'commentDisplayYn': commentDisplayYn
    });
    if(result != null) {
      post.commentDisplayYn = commentDisplayYn;
    }
    isLoading.value = false; // 로딩 완료
  }
  //게시글 고정표시여부 API 호출
  Future<void> saveFixDisplayYn(BuildContext context, PostDto post) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    String fixDisplayYn = post.fixDisplayYn == "Y" ? "N" : "Y";
    var result = await ApiService.sendApi(context, '/api/instargram/post/saveFixDisplayYn', {
      'postNo': post.postNo,
      'fixDisplayYn': fixDisplayYn
    });
    if(result != null) {
      post.fixDisplayYn = fixDisplayYn;
    }
    isLoading.value = false; // 로딩 완료
  }

  //게시글 고정표시여부 API 호출
  Future<void> deletePost(BuildContext context, PostDto post) async {
    isLoading.value = true; // 로딩 시작
    //기본 데이터
    var result = await ApiService.sendApi(context, '/api/instargram/post/deletePost', {
      'postNo': post.postNo,
    });
    if(result != null) {
      myPostList.remove(post);
    }
    isLoading.value = false; // 로딩 완료
  }
}