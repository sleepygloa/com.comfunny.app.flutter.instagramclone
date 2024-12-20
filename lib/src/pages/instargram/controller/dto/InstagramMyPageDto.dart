
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';

class InstagramMyPageDto {
  // 회사 이름
  final String bizCd;
  // 사용자 ID
  final String userId;
  // 사용자 이름
  final String userName;
  // 사용자 설명
  final String description;

  // 썸네일 이미지 경로
  final String thumbnailPth;
  // 썸네일 파일 이름
  final String thumbnailName;

  // 팔로워 수
  final int followerCnt;
  // 팔로잉 수
  final int followingCnt;
  // 게시물 수
  final int postCnt;

  // 내 게시물 목록
  final List<PostDto> myPostList;

  // 생성자
  InstagramMyPageDto({
    required this.bizCd,
    required this.userId,
    required this.userName,
    required this.description,
    required this.thumbnailPth,
    required this.thumbnailName,
    required this.followerCnt,
    required this.followingCnt,
    required this.postCnt,
    required this.myPostList,
  });

  // JSON 데이터를 DTO로 변환하는 팩토리 메서드
  factory InstagramMyPageDto.fromJson(Map<String, dynamic> json) {
    return InstagramMyPageDto(
      bizCd: json['bizCd'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      description: json['description'] ?? '',
      thumbnailPth: json['thumbnailPth'] ?? '',
      thumbnailName: json['thumbnailName'] ?? '',
      followerCnt: json['followerCnt'] ?? 0,
      followingCnt: json['followingCnt'] ?? 0,
      postCnt: json['postCnt'] ?? 0,
      myPostList: List<PostDto>.from(json['myPostList'] ?? []),
    );
  }

  // DTO를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'bizCd': bizCd,
      'userId': userId,
      'userName': userName,
      'description': description,
      'thumbnailPth': thumbnailPth,
      'thumbnailName': thumbnailName,
      'followerCnt': followerCnt,
      'followingCnt': followingCnt,
      'postCnt': postCnt,
      'myPostList': myPostList,
    };
  }

  @override
  String toString() {
    return 'InstagramMyPageDto(bizCd: $bizCd, userId: $userId, userName: $userName, description: $description, thumbnailPth: $thumbnailPth, thumbnailName: $thumbnailName, followerCnt: $followerCnt, followingCnt: $followingCnt, postCnt: $postCnt, myPostList: $myPostList)';
  }
}
