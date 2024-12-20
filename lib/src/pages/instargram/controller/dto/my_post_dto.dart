import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/%08comment_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/myPostImg.dart';

class PostDto {
  // 회사 코드
  final String bizCd;
  // 사용자 ID
  final String userId;
  // 게시물 ID
  final String postNo;
  // 게시물 내용
  final String content;
  // 게시일자
  final String postYmd;
  // 좋아요 갯수
  late int likeCnt;
  // 좋아요 여부
  late String likeYn;
  // 리스트 (하위 데이터)
  List<PostImg> list;
  // 댓글 리스트
  List<Comment> comments;

  // 생성자
  PostDto({
    required this.bizCd,
    required this.userId,
    required this.postNo,
    required this.content,
    required this.postYmd,
    required this.list,
    this.likeCnt = 0,
    this.likeYn = 'N',
    this.comments = const <Comment>[],
  });


  // JSON 데이터를 List<Comment> 객체로 변환
  static List<PostDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PostDto.fromJson(json)).toList();
  }

  // JSON 데이터를 DTO로 변환하는 팩토리 메서드
  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      bizCd: json['bizCd'] ?? '',
      userId: json['userId'] ?? '',
      postNo: json['postNo'] ?? '',
      content: json['content'] ?? '',
      postYmd: json['postYmd'] ?? '',
      list: PostImg.fromJsonList(json['list'] ?? <PostImg>[]),
      likeCnt: json['likeCnt'] ?? 0,
      likeYn: json['likeYn'] ?? 'N',
      comments: Comment.fromJsonList(json['comments'] ?? <Comment>[]),
    );
  }

  // DTO를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'bizCd': bizCd,
      'userId': userId,
      'postNo': postNo,
      'content': content,
      'postYmd': postYmd,
      'list': list,
    };
  }

  @override
  String toString() {
    return 'MyPost(bizCd: $bizCd, userId: $userId, postNo: $postNo, content: $content, postYmd: $postYmd, list: $list)';
  }
}


