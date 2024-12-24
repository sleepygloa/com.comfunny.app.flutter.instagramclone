import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:get/get.dart';

class MyPostModify extends StatefulWidget {
  final PostDto post; // 게시글 번호
  final int index; // 게시글 인덱스 1:일반, 2:내 게시물:

  const MyPostModify({super.key, required this.post, required this.index});

  @override
  State<MyPostModify> createState() => _MyPostModifyState();
}

class _MyPostModifyState extends State<MyPostModify> {
  final InstargramDataController controller = Get.find<InstargramDataController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 저장과 QR 코드 버튼을 세로로 정렬
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  print("저장 클릭");
                },
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.bookmark_outline, color: Colors.black),
                      const SizedBox(width: 15),
                      const Text(
                        '저장',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  print("QR 코드 클릭");
                },
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code, color: Colors.black),
                      const SizedBox(width: 15),
                      const Text(
                        'QR 코드',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //비팔로우 타 게시물
          if(widget.index == 1 || widget.index == 3) ...[
            
            if(widget.index == 3) ...[
              const SizedBox(height: 10),
              Container(
                // width: 150,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    // 일반 옵션
                    ...[
                      //즐겨찾기 추가
                      _menuItem('즐겨찾기 추가', Icons.bookmark_outline, 'FAVORITE_ADD'),
                      const Divider(height: 20, thickness: 1),
                      //팔로우 취소
                      _menuItem('팔로우 취소', Icons.person_remove, 'UNFOLLOW'),]
                  ],
                ),
              ),
            ],


            const SizedBox(height: 10),
            Container(
              // width: 150,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
              
                  // 일반 옵션
                  ...[
                    //이 계정 정보
                    _menuItem('이 계정 정보', Icons.info, 'INFO'),
                    const Divider(height: 20, thickness: 1),
                    //번역
                    _menuItem('번역', Icons.translate, 'TRANSLATE'),
                    const Divider(height: 20, thickness: 1),
                    //선택 캡션
                    _menuItem('선택 캡션', Icons.text_fields, 'CAPTION'),
                    const Divider(height: 20, thickness: 1),
                    //이 게시물이 표시되는 이유
                    _menuItem('이 게시물이 표시되는 이유', Icons.help, 'REASON'),
                    const Divider(height: 20, thickness: 1),
                    //관심 없음
                    _menuItem('관심 없음', Icons.not_interested, 'NOT_INTERESTED'),
                    const Divider(height: 20, thickness: 1),
                    //신고
                    _menuItem('신고', Icons.report, 'REPORT'),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              // width: 150,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  // 일반 옵션
                  ...[
                  //콘텐츠 설정 기본 관리
                  _menuItem('콘텐츠 설정 기본 관리', Icons.settings, 'SETTING'),
                  ]
                ],
              ),
            ),
          ],


          //내 게시물
          if(widget.index == 2) ...[
            const SizedBox(height: 10),
            Container(
              // width: 150,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
              
                  // 일반 옵션
                  ...[
                    //Facebook에 공유
                    _menuItem('Facebook에 공유', Icons.share, 'FACEBOOK'),
                    //보관
                    const Divider(height: 20, thickness: 1),
                    _menuItem('보관', Icons.bookmark_outline, 'ACHIEVE'),
                    //좋아요 수 숨기기
                    const Divider(height: 20, thickness: 1),
                    if(widget.post.likeDisplayYn == 'Y') _menuItem('좋아요 수 숨기기', Icons.favorite, 'LIKE'),
                    if(widget.post.likeDisplayYn == 'N') _menuItem('좋아요 수 표시하기', Icons.favorite, 'LIKE'),
                    //댓글 기능 해제
                    const Divider(height: 20, thickness: 1),
                    if(widget.post.commentDisplayYn == 'Y') _menuItem('댓글 기능 해제', Icons.comment, 'COMMENT'),
                    if(widget.post.commentDisplayYn == 'N') _menuItem('댓글 기능 표시하기', Icons.comment, 'COMMENT'),
                    //이 게시물에서 릴스 만들기
                    const Divider(height: 20, thickness: 1),
                    _menuItem('이 게시물에서 릴스 만들기', Icons.replay, 'REELS'),
                    //수정
                    const Divider(height: 20, thickness: 1),
                    _menuItem('수정', Icons.edit, 'EDIT'),
                    //내 프로필에 고정
                    const Divider(height: 20, thickness: 1),
                    if(widget.post.fixDisplayYn == 'Y') _menuItem('내 프로필에서 고정 해제', Icons.push_pin_outlined, 'PIN'),
                    if(widget.post.fixDisplayYn == 'N') _menuItem('내 프로필에 고정', Icons.push_pin_outlined, 'PIN'),
                    //삭제
                    const Divider(height: 20, thickness: 1),
                    _menuItem('삭제', Icons.delete, 'DELETE'),
                  ]
                ],
              ),
            ),
          ],



          //팔로우 타 게시물
          if(widget.index == 3) ...[
            const SizedBox(height: 10),
            Container(
              // width: 150,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
              
                  // 일반 옵션
                  ...[
                    //이 계정 정보
                    _menuItem('이 계정 정보', Icons.info, 'INFO'),
                    const Divider(height: 20, thickness: 1),
                    //번역
                    _menuItem('번역', Icons.translate, 'TRANSLATE'),
                    const Divider(height: 20, thickness: 1),
                    //선택 캡션
                    _menuItem('선택 캡션', Icons.text_fields, 'CAPTION'),
                    const Divider(height: 20, thickness: 1),
                    //이 게시물이 표시되는 이유
                    _menuItem('이 게시물이 표시되는 이유', Icons.help, 'REASON'),
                    const Divider(height: 20, thickness: 1),
                    //관심 없음
                    _menuItem('관심 없음', Icons.not_interested, 'NOT_INTERESTED'),
                    const Divider(height: 20, thickness: 1),
                    //신고
                    _menuItem('신고', Icons.report, 'REPORT'),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              // width: 150,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  // 일반 옵션
                  ...[
                  //콘텐츠 설정 기본 관리
                  _menuItem('콘텐츠 설정 기본 관리', Icons.settings, 'SETTING'),
                  ]
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 일반 옵션 위젯
  Widget _menuItem(String title, IconData icon, String flag) {
    return InkWell(
      onTap: () {
        print("$title 클릭");
        //공유 하기/중단
        if(flag == 'FACEBOOK'){
        }
        if(flag == 'LIKE'){
          controller.saveLikeDisplayYn(context, widget.post);
        }
        if(flag == 'COMMENT'){
          controller.saveCommentDisplayYn(context, widget.post);
        }
        if(flag == 'PIN'){
          controller.saveFixDisplayYn(context, widget.post);
        }
        if(flag == 'DELETE'){
          controller.deletePost(context, widget.post);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(title)),
        );
        // BottomSheet 닫기
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
