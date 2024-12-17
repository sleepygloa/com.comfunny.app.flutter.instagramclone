import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/myPostImg.dart';

class MyPost {
  // 회사 코드
  final String bizCd;
  // 사용자 ID
  final String userId;
  // 게시물 ID
  final String postId;
  // 게시물 내용
  final String content;
  // 게시일자
  final String postYmd;
  // 리스트 (하위 데이터)
  final List<MyPostImg> list;

  // 생성자
  MyPost({
    required this.bizCd,
    required this.userId,
    required this.postId,
    required this.content,
    required this.postYmd,
    required this.list,
  });

  // JSON 데이터를 DTO로 변환하는 팩토리 메서드
  factory MyPost.fromJson(Map<String, dynamic> json) {
    return MyPost(
      bizCd: json['bizCd'] ?? '',
      userId: json['userId'] ?? '',
      postId: json['postId'] ?? '',
      content: json['content'] ?? '',
      postYmd: json['postYmd'] ?? '',
      list: List<MyPostImg>.from(json['list'] ?? []),
    );
  }

  // DTO를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'bizCd': bizCd,
      'userId': userId,
      'postId': postId,
      'content': content,
      'postYmd': postYmd,
      'list': list,
    };
  }

  @override
  String toString() {
    return 'MyPost(bizCd: $bizCd, userId: $userId, postId: $postId, content: $content, postYmd: $postYmd, list: $list)';
  }
}