import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/%08comment_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/mypost/comment_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';

class MyPostWidget extends StatefulWidget {
  final PostDto post;

  MyPostWidget({super.key, required this.post});

  @override
  State<MyPostWidget> createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {
  int currentPage = 0; // 현재 페이지를 추적하기 위한 변수
  InstargramDataController dataController = Get.find<InstargramDataController>();
  List<Comment> comments= [];


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyPostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    comments = widget.post.comments;
  }

  
  //좋아요/좋아요해제 
  Future<void> savePostLike(BuildContext context) async {
    var likeYn = widget.post.likeYn;
    var saveLikeYn = likeYn == 'Y' ? 'N' : 'Y'; // 좋아요 토글
    var likeChange = likeYn == 'Y' ? -1 : 1; // 좋아요 개수 변경값

    var result = await ApiService.sendApi(context, '/api/instargram/post/savePostLike', {
      'postNo': widget.post.postNo,
      'likeUserId': dataController.apiData['userId'],
      'likeYn': saveLikeYn,
    });

    if(result != null) {
      setState(() {
        // 좋아요 상태 및 좋아요 개수 업데이트
        widget.post.likeYn = saveLikeYn;
        widget.post.likeCnt = (widget.post.likeCnt ?? 0) + likeChange;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 상태 변경 실패')),
      );
    }
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarWidget(
            type: AvatarType.type3,
            nickname: dataController.apiData['userName'],
            size: 40,
            thumbPath: "http://localhost:8080/"+dataController.apiData['thumbnailPth'],
          ),
          GestureDetector(
            onTap: () {},
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
        imageUrl: "http://localhost:8080/" + list[0].imgPth,
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
                  imageUrl: "http://localhost:8080/"+list[pageIndex].imgPth,
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

  //좋아요
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
                  savePostLike(context);
                },
                child: widget.post.likeYn == "Y" ? 
                  ImageData(
                    IconPath.likeOnIcon,
                    width: 65,
                  ) :
                  ImageData(
                    IconPath.likeOffIcon,
                    width: 65,
                  ),
              )
              ,
              const SizedBox(width: 15,),
              GestureDetector(
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
                child: ImageData(
                  IconPath.replyIcon,
                  width: 60,
                ),
              ),
              const SizedBox(width: 15,),
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

  //설명
  Widget _infoDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            // '좋아요 5개',
            '좋아요 ${widget.post.likeCnt}개',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ExpandableText(
            widget.post.content ?? '',
            prefixText: dataController.apiData['userName'],
            onPrefixTap: () => print('prefix tapped'),
            prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
            expandText: '더보기',
            collapseText: '접기',
            maxLines: 3, //펼쳐지기 전에 보여줄 줄 수
            expandOnTextTap: true, //더보기를 눌러야 펼쳐지는지 여부
            collapseOnTextTap: true, //접기를 눌러야 접히는지 여부
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
          const SizedBox(height: 15,),
          _image(),
          const SizedBox(height: 15,),
          _infoCount(),
          const SizedBox(height: 5,),
          _infoDescription(),
          const SizedBox(height: 5,),
          widget.post.comments.isNotEmpty ? 
            _replyTextBtn() :
            const SizedBox(),
          _dateAgo(),
        ],
      ),
    );
  }

}