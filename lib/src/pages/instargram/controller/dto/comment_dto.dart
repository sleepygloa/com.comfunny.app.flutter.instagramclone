class Comment {
  final String bizCd; // 회사코드
  final String postNo; // 게시글 번호
  final String commentNo; // 댓글 번호
  final String content; // 댓글 내용
  final String userId; // 작성자 ID
  final String userName; // 작성자 이름
  final String thumbnailPth; // 작성자 프로필 이미지 경로
  int likeCnt = 0; // 좋아요 수
  String isLiked = 'N'; // 좋아요 여부
  final List<Reply> replys; // 대댓글 리스트

  Comment({
    required this.bizCd,
    required this.postNo,
    required this.commentNo,
    required this.content,
    required this.userId,
    required this.userName,
    required this.thumbnailPth,
    this.likeCnt = 0,
    this.isLiked = 'N',
    this.replys = const <Reply>[],
  });

  // JSON 데이터를 List<Comment> 객체로 변환
  static List<Comment> fromJsonList(List<dynamic> jsonList) {
    // if(jsonList.length < 1) return <Comment>[];
    return jsonList.map((json) => Comment.fromJson(json)).toList();
  }

  // JSON 데이터를 Comment 객체로 변환
  factory Comment.fromJson(dynamic json) {
    return Comment(
      bizCd: json['bizCd'],
      postNo: json['postNo'],
      commentNo: json['commentNo'],
      content: json['content'],
      userId: json['userId'],
      userName: json['userName'],
      thumbnailPth: json['thumbnailPth'] ?? '',
      likeCnt: json['likeCnt'] ?? 0,
      isLiked: json['isLiked'] ?? 'N',
      replys: json['replys'] == null ? <Reply>[] : Reply.fromJsonList(json['replys']),
    );
  }
}

class Reply {
  final String bizCd; // 회사코드
  final String postNo; // 게시글 번호
  final String commentNo; // 댓글 번호
  final String replyNo; // 대댓글 번호
  final String userId; // 작성자 ID
  final String userName; // 작성자 이름
  String content; // 대댓글 내용
  final String thumbnailPth; // 작성자 프로필 이미지 경로
  int likeCnt; // 좋아요 수
  String isLiked = 'N'; // 좋아요 여부

  Reply({
    required this.bizCd,
    required this.postNo,
    required this.commentNo,
    required this.replyNo,
    required this.userId,
    required this.userName,
    required this.content,
    required this.thumbnailPth,
    this.likeCnt = 0,
    this.isLiked = 'N',
  });

  // JSON 데이터를 List<Reply> 객체로 변환
  static List<Reply> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Reply.fromJson(json)).toList();
  }

  // JSON 데이터를 Reply 객체로 변환
  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      bizCd: json['bizCd'],
      postNo: json['postNo'],
      commentNo: json['commentNo'],
      replyNo: json['replyNo'],
      content: json['content'],
      userId: json['userId'],
      userName: json['userName'],
      thumbnailPth: json['thumbnailPth'] ?? '',
      likeCnt: json['likeCnt'] ?? 0,
      isLiked: json['isLiked'] ?? 'N',
    );
  }
}
