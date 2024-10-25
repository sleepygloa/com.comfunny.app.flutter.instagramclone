class MyPageDto{
  /// A Data Transfer Object (DTO) representing the user's page information.
  ///
  /// This class is used to encapsulate the user's page data, including their
  /// thumbnail image, post count, followers count, following count, a list
  /// of their posts, and a description. It provides methods to convert the
  /// data to and from JSON format for server communication.
  ///
  /// 사용자의 페이지 정보를 나타내는 데이터 전송 객체(DTO)입니다.
  ///
  /// 이 클래스는 사용자의 썸네일 이미지, 게시물 수, 팔로워 수, 팔로잉 수,
  /// 그리고 사용자의 게시물 목록 및 설명을 포함한 데이터를 캡슐화하는 데 사용됩니다.
  /// 서버와의 통신을 위해 데이터를 JSON 형식으로 변환하는 메서드를 제공합니다.
  final String myThumbnailImg;
  final int postCnt;
  final int followersCnt;
  final int followingCnt;
  final List<String> myPostList;
  final String myDescription;

  MyPageDto({
    required this.myThumbnailImg,
    required this.postCnt,
    required this.followersCnt,
    required this.followingCnt,
    required this.myPostList,
    required this.myDescription,
  });

  factory MyPageDto.fromJson(Map<String, dynamic> json) {
    return MyPageDto(
      myThumbnailImg: json['myThumbnailImg']?? '',
      postCnt: json['postCnt'] ?? 0,
      followersCnt: json['followersCnt'] ?? 0,
      followingCnt: json['followingCnt'] ?? 0,
      myPostList: List<String>.from(json['myPostList'] ?? []),
      myDescription: json['myDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myThumbnailImg': myThumbnailImg,
      'postCnt': postCnt,
      'followersCnt': followersCnt,
      'followingCnt': followingCnt,
      'myPostList': myPostList,
      'myDescription': myDescription,
    };
  }
}