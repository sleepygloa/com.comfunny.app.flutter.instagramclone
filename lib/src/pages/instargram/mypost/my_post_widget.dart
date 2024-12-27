import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/mypost/comment_widget.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/mypost/my_post_modify.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
class MyPostWidget extends StatefulWidget {
  final PostDto post;
  int index;

  MyPostWidget({super.key, required this.post, required this.index});

  @override
  State<MyPostWidget> createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {
  int currentPage = 0; // 현재 페이지를 추적하기 위한 변수
  InstargramDataController dataController = Get.find<InstargramDataController>();
  late Rx<PostDto> post; // 상태 관리를 위한 Rx<PostDto>

  @override
  void initState() {
    super.initState();
    post = widget.post.obs; // Rx 상태로 초기화
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // @override
  // void didUpdateWidget(covariant MyPostWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   comments = widget.post.comments;
  // }

  
  // 좋아요/좋아요 해제
  Future<void> toggleLike(BuildContext context) async {
    final likeYn = post.value.likeYn;
    final updatedLikeYn = likeYn == 'Y' ? 'N' : 'Y';
    final likeChange = likeYn == 'Y' ? -1 : 1;

    final result = await ApiService.sendApi(context, '/api/instargram/post/savePostLike', {
      'postNo': post.value.postNo,
      'likeUserId': dataController.myProfile.value.userId,
      'likeYn': updatedLikeYn,
    });

    if (result != null) {
      post.update((p) {
        if (p != null) {
          p.likeYn = updatedLikeYn;
          p.likeCnt = (p.likeCnt ?? 0) + likeChange;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('좋아요 상태 변경 실패')),
      );
    }
  }


  // 사용자 이름과 프로필 사진 경로 설정
  Map<String, String> _getUserDetails() {
    if (widget.index == 2) {
      return {
        'userName': dataController.myProfile.value.userName ?? '',
        'thumbnailPth': dataController.myProfile.value.thumbnailPth ?? '',
      };
    } else if (widget.index == 3) {
      return {
        'userName': post.value.userNm ?? '',
        'thumbnailPth': post.value.thumbnailPth ?? '',
      };
    }
    return {'userName': '', 'thumbnailPth': ''};
  }


  Widget _header() {
    final userDetails = _getUserDetails();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarWidget(
            type: AvatarType.type3,
            nickname: userDetails['userName'] ?? '',
            size: 40,
            thumbPath: userDetails['thumbnailPth'] ?? '',
          ),
          if (widget.index == 1)
            Expanded(
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await dataController.saveFollow(context, post.value);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            post.value.followYn == 'Y' ? '언팔로우' : '팔로우',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    minChildSize: 0.5,
                    maxChildSize: 1.0,
                    expand: false,
                    builder: (_, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: MyPostModify(
                          post: post.value,
                          index: widget.index,
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageData(
                IconPath.postMoreIcon,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }


  //이미지
  Widget _image() {
    var list = widget.post.list;
    if (list.length == 1) {
      return CachedNetworkImage(
        imageUrl: '${ApiService.serverUrl}/${list[0].imgPth}',
      );
    } else {
      return Stack(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: list.length,
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemBuilder: (context, pageIndex) {
                return CachedNetworkImage(
                  imageUrl: '${ApiService.serverUrl}/${list[0].imgPth}',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          // 페이지 인디케이터 (하단 점)
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              children: List.generate(
                list.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black38),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _infoCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  toggleLike(context);
                },
                child: Obx(() => ImageData(
                      post.value.likeYn == 'Y'
                          ? IconPath.likeOnIcon
                          : IconPath.likeOffIcon,
                      width: 65,
                    )),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: Get.context!,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return CommentWidget(
                        post: post.value,
                        comments: post.value.comments,
                      );
                    },
                  );
                },
                child: ImageData(
                  IconPath.replyIcon,
                  width: 60,
                ),
              ),
              const SizedBox(width: 15),
              ImageData(
                IconPath.directMessage,
                width: 55,
              ),
            ],
          ),
          ImageData(
            IconPath.bookMarkOffIcon,
            width: 65,
          ),
        ],
      ),
    );
  }

  
  Widget _infoDescription() {
    final userDetails = _getUserDetails();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() => Text(
                '좋아요 ${post.value.likeCnt}개',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          ExpandableText(
            post.value.content ?? '',
            prefixText: userDetails['userName'],
            onPrefixTap: () => print('prefix tapped'),
            prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
            expandText: '더보기',
            collapseText: '접기',
            maxLines: 3,
            expandOnTextTap: true,
            collapseOnTextTap: true,
            linkColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  //댓글
  Widget _replyTextBtn() {
    return GestureDetector(
      onTap : (){
        showModalBottomSheet(
          context: Get.context!,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return CommentWidget(
              post: widget.post, // 게시물 번호 전달
              comments: widget.post.comments, // 댓글 리스트 전달
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          '댓글 ${widget.post.comments.length} 개 모두 보기',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
          // textAlign: TextAlign.start,
        ),
      ),
    );
  }

  //시간
  Widget _dateAgo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        widget.post.postYmd,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          const SizedBox(height: 15),
          _image(),
          const SizedBox(height: 15),
          _infoCount(),
          const SizedBox(height: 5),
          _infoDescription(),
          const SizedBox(height: 5),
          post.value.comments.isNotEmpty ? _replyTextBtn() : const SizedBox(),
          _dateAgo(),
        ],
      ),
    );
  }

}