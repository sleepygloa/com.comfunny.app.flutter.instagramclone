
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';

class MyProfile {
  final String bizCd; // 사업 코드
  final String userId; // 사용자 ID
  String userName = ''; // 사용자 이름
  String description = ''; // 사용자 설명
  String thumbnailPth = ''; // 썸네일 경로
  String thumbnailName = ''; // 썸네일 이름
  String displayYn = 'Y'; // 노출 여부
  int followerCnt = 0; // 팔로워 수
  int followingCnt = 0; // 팔로잉 수
  int postCnt = 0; // 게시물 수
  List<PostDto> myPostList = <PostDto>[]; // 내 포스트 리스트

  // 생성자
  MyProfile({
     this.bizCd = '',
     this.userId = '',
     this.userName = '',
     this.description = '',
     this.thumbnailPth = '',
     this.thumbnailName = '',
     this.displayYn = 'Y',
     this.followerCnt = 0,
     this.followingCnt = 0,
     this.postCnt = 0,
     this.myPostList = const <PostDto>[],
  });

  // JSON 데이터를 DTO로 변환하는 팩토리 메서드
  factory MyProfile.fromJson(Map<String, dynamic> json) {
    print(json);
    print(json['thumbnailName']);
    return MyProfile(
      bizCd: json['bizCd'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      description: json['description'] ?? '',
      thumbnailPth:  json['thumbnailPth']??'',
      thumbnailName: json['thumbnailName'] ?? '',
      displayYn: json['displayYn'] ?? 'Y',
      followerCnt: json['followerCnt'] ?? 0,
      followingCnt: json['followingCnt'] ?? 0,
      postCnt: json['postCnt'] ?? 0,
      myPostList: PostDto.fromJsonList(json['myPostList'] ?? <PostDto>[]),
    );
  }

  // DTO를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    // print('toJson ${ApiService.serverUrl}/'+ thumbnailPth);
    return {
      'bizCd': bizCd,
      'userId': userId,
      'userName': userName,
      'description': description,
      'thumbnailPth': thumbnailPth,
      'thumbnailName': thumbnailName,
      'displayYn': displayYn,
      'followerCnt': followerCnt,
      'followingCnt': followingCnt,
      'postCnt': postCnt,
      'myPostList': myPostList,
    };
  }

  @override
  String toString() {
    return 'MyProfile(bizCd: $bizCd, userId: $userId, userName: $userName, description: $description, thumbnailPth: $thumbnailPth, thumbnailName: $thumbnailName, followerCnt: $followerCnt, followingCnt: $followingCnt, postCnt: $postCnt, myPostList: $myPostList)';
  }
}
