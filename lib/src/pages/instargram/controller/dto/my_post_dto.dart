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
  // 표시 여부
  late String displayYn;
  // 좋아요수표시 여부
  late String likeDisplayYn;
  // 댓글기능사용 여부
  late String commentDisplayYn;
  // 고정표시 여부
  late String fixDisplayYn;
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
    this.displayYn = 'Y',
    this.likeDisplayYn = 'Y',
    this.commentDisplayYn = 'Y',
    this.fixDisplayYn = 'N',
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
      displayYn: json['displayYn'] ?? 'Y',
      likeDisplayYn: json['likeDisplayYn'] ?? 'Y',
      commentDisplayYn: json['commentDisplayYn'] ?? 'Y',
      fixDisplayYn: json['fixDisplayYn'] ?? 'N',
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
      'displayYn': displayYn,
      'likeDisplayYn': likeDisplayYn,
      'commentDisplayYn': commentDisplayYn,
      'fixDisplayYn': fixDisplayYn,
      'list': list,
    };
  }

  @override
  String toString() {
    return 'MyPost(bizCd: $bizCd, userId: $userId, postNo: $postNo, content: $content, postYmd: $postYmd, displayYn: $displayYn, likeDisplayYn: $likeDisplayYn, commentDisplayYn: $commentDisplayYn, fixDisplayYn: $fixDisplayYn, list: $list)';
  }
}




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


class PostImg {
  final String bizCd;          // 회사 코드
  final String postId;         // 게시물 ID
  final int postDetailSeq;     // 게시물 상세 순번
  final String imgPth;         // 이미지 경로
  final String imgName;        // 이미지 이름

  // 생성자
  PostImg({
    required this.bizCd,
    required this.postId,
    required this.postDetailSeq,
    required this.imgPth,
    required this.imgName,
  });


  // JSON 데이터를 List<Comment> 객체로 변환
  static List<PostImg> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PostImg.fromJson(json)).toList();
  }

  // JSON 데이터를 DTO로 변환하는 팩토리 메서드
  factory PostImg.fromJson(Map<String, dynamic> json) {
    // '${ApiService.serverUrl}/'+ thumbnailPth,
    return PostImg(
      bizCd: json['bizCd'] ?? '',
      postId: json['postId'] ?? '',
      postDetailSeq: json['postDetailSeq'] ?? 0,
      imgPth: json['imgPth'],
      imgName: json['imgName'] ?? '',
    );
  }

  // DTO를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'bizCd': bizCd,
      'postId': postId,
      'postDetailSeq': postDetailSeq,
      'imgPth': imgPth,
      'imgName': imgName,
    };
  }

  @override
  String toString() {
    return 'PostImg(bizCd: $bizCd, postId: $postId, postDetailSeq: $postDetailSeq, imgPth: $imgPth, imgName: $imgName)';
  }
}
