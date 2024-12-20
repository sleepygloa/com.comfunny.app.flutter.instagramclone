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
    return PostImg(
      bizCd: json['bizCd'] ?? '',
      postId: json['postId'] ?? '',
      postDetailSeq: json['postDetailSeq'] ?? 0,
      imgPth: json['imgPth'] ?? '',
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
