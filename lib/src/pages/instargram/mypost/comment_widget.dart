import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:get/get.dart';

class CommentWidget extends StatefulWidget {
  final List<Comment> comments; // 서버에서 불러온 댓글 리스트
  final PostDto post; // 게시글 번호

  CommentWidget({super.key, required this.post, required this.comments});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final InstargramDataController controller = Get.find<InstargramDataController>();
  TextEditingController commentController = TextEditingController();
  String commentNo = ''; // 댓글 번호
  String replyNo = ''; // 답글 대상 댓글 번호

  var postUserId;
  var userId;
  var userName;
  var thumbnailPth;

  @override
  void initState() {
    super.initState();
    postUserId = widget.post.userId;
    userId = controller.myProfile.value.userId;
    userName = controller.myProfile.value.userName;
    thumbnailPth = controller.myProfile.value.thumbnailPth;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  } 

  // 댓글 저장
  void saveComment() async {
    var result = await ApiService.sendApi(context, '/api/instargram/post/saveComment', {
      'postNo': widget.post.postNo,
      'userId': userId,
      'content': commentController.value.text,
      'commentNo': commentNo,
      'replyNo': replyNo,
    });

    if(result == null) return;
      
    print('saveComment result: $result');
    print('====== '+ result!["commentNo"]);
    print('====== '+ result!["replyNo"]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('댓글이 저장되었습니다.')),
    );
    setState(() {
      //1. commentNo "", replyNo "" 댓글 신규등록, commentNo 는 resultNo["commentNo"]
      //2. commentNo "댓글번호", replyNo "" 댓글 수정
      if(commentNo == '' && result["commentNo"] != '') {
        print(123);
        commentNo = result["commentNo"];
      }
      if(commentNo != '' && replyNo == '') {
        // 댓글 저장 후 댓글 리스트에 추가
        Comment comment = new Comment(
          bizCd: '', 
          postNo: widget.post.postNo,
          commentNo: commentNo,
          content: commentController.text, 
          userId: userId, 
          userName: userName,
          thumbnailPth: thumbnailPth
        );
        widget.post.comments.add(comment);
      }else
      //3. commentNo "댓글번호", replyNo "0" 대댓글 신규등록
      if(commentNo != '' && replyNo == '0') {
        // 대댓글 저장 후 댓글 리스트에 추가
        Reply reply = new Reply(
          bizCd: '', 
          postNo: widget.post.postNo,
          commentNo: commentNo,
          replyNo: replyNo,
          content: commentController.text, 
          userId: userId, 
          userName: userName,
          thumbnailPth: thumbnailPth
        );
        //현재의 widget.post.comments 내 commentNo와 같은 commentNo를 가진 대댓글 리스트에 추가
        widget.post.comments.where((element) => element.commentNo == commentNo).first.replys.add(reply);
      }else
      //4. commentNo "댓글번호", replyNo "대댓글번호" 대댓글 수정
      if(commentNo != '' && replyNo != '0') {
        // 대댓글 저장 후 댓글 리스트에 추가
        Reply reply = new Reply(
          bizCd: '', 
          postNo: widget.post.postNo,
          commentNo: commentNo,
          replyNo: replyNo,
          content: commentController.text, 
          userId: userId, 
          userName: userName,
          thumbnailPth: thumbnailPth
        );
        //현재의 widget.post.comments 내 commentNo와 같은 commentNo를 가진 대댓글 리스트 내 replyNo와 같은 replyNo를 가진 대댓글 수정
        widget.post.comments.where((element) => element.commentNo == commentNo).first.replys.where((element) => element.replyNo == replyNo).first.content = commentController.text;
      }


      commentController.text = '';
    });
  }



  //좋아요/좋아요해제 
  Future<void> savePostCommentLike(BuildContext context, PostDto post, Comment comment) async {
    //commentNo
    var likeYn = comment.isLiked;
    var saveLikeYn = likeYn == 'Y' ? 'N' : 'Y'; // 좋아요 토글
    var likeChange = likeYn == 'Y' ? -1 : 1; // 좋아요 개수 변경값

    var result = await ApiService.sendApi(context, '/api/instargram/post/savePostLike', {
      'postNo': post.postNo,
      'commentNo': comment.commentNo,
      'likeUserId': controller.myProfile.value.userId,
      'likeYn': saveLikeYn,
    });

    if(result != null) {
      setState(() {
          //현재의 widget.post.comments 내 commentNo와 같은 commentNo를 가진 좋아요변경
          // var comment = post.comments.where((element) => element.commentNo == comment.commentNo).first;
          comment.isLiked = saveLikeYn;
          comment.likeCnt = comment.likeCnt + likeChange;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 상태 변경 실패')),
      );
    }
  }

  //좋아요/좋아요해제 
  Future<void> savePostCommentReplyLike(BuildContext context, PostDto post, Comment comment, Reply reply) async {
    //commentNo
    var likeYn = reply.isLiked;
    var saveLikeYn = likeYn == 'Y' ? 'N' : 'Y'; // 좋아요 토글
    var likeChange = likeYn == 'Y' ? -1 : 1; // 좋아요 개수 변경값

    var result = await ApiService.sendApi(context, '/api/instargram/post/savePostLike', {
      'postNo': widget.post.postNo,
      'commentNo': reply.commentNo,
      'replyNo': reply.replyNo,
      'likeUserId': controller.myProfile.value.userId,
      'likeYn': saveLikeYn,
    });

    if(result != null) {
      setState(() {
          //현재의 widget.post.comments 내 commentNo와 같은 commentNo를 가진 대댓글 리스트 내 replyNo와 같은 replyNo를 가진 대댓글 수정
          reply.isLiked = saveLikeYn;
          reply.likeCnt = reply.likeCnt + likeChange;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 상태 변경 실패')),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '댓글',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.info_outline),
          ],
        ),

        // 댓글 리스트 (스크롤 가능)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var comment in widget.comments)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // 댓글 작성자 프로필 이미지
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                              '${ApiService.serverUrl}/${controller.myProfile.value.thumbnailPth}',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 댓글 작성자
                                Text(comment.userId, style: TextStyle(fontWeight: FontWeight.bold)),
                                // 댓글 내용
                                Text(comment.content),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      commentNo = comment.commentNo; // 대상 댓글 번호
                                      replyNo = '0'; // 대상 댓글 번호 초기화
                                      // 댓글 입력창에 대상 댓글 작성자 아이디 추가
                                      commentController.text = '@${comment.userId} ';
                                    });
                                  },
                                  child: Text(
                                    '답글 달기',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 좋아요 버튼과 카운트
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  comment.isLiked == "Y" ? Icons.favorite : Icons.favorite_border,
                                  color: comment.isLiked == "Y" ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  savePostCommentLike(context, widget.post, comment);
                                },
                              ),
                              if (comment.likeCnt > 0)
                                Text(
                                  '${comment.likeCnt}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // 대댓글 리스트
                      if (comment.replys.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 30), // 들여쓰기
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var reply in comment.replys)
                                Row(
                                  children: [
                                    // 대댓글 작성자 프로필 이미지
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                        '${ApiService.serverUrl}/${controller.myProfile.value.thumbnailPth}',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 대댓글 작성자
                                          Text(reply.userId, style: TextStyle(fontWeight: FontWeight.bold)),
                                          // 대댓글 내용
                                          Text(reply.content),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                commentNo = comment.commentNo; // 대상 댓글 번호
                                                replyNo = reply.replyNo; // 대상 대댓글 번호
                                                // 댓글 입력창에 대상 댓글 작성자 아이디 추가
                                                commentController.text = '@${reply.userId} ';
                                              });
                                            },
                                            child: Text(
                                              '답글 달기',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 좋아요 버튼과 카운트
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            reply.isLiked == "Y" ? Icons.favorite : Icons.favorite_border,
                                            color: reply.isLiked == "Y" ? Colors.red : Colors.grey,
                                          ),
                                          onPressed: () {
                                            savePostCommentReplyLike(context, widget.post, comment, reply);
                                          },
                                        ),
                                        if (reply.likeCnt > 0)
                                          Text(
                                            '${reply.likeCnt}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10),
        Divider(),
        // 댓글 입력창
        Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                '${ApiService.serverUrl}/${controller.myProfile.value.thumbnailPth}',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: postUserId + '에게 댓글 추가...',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (commentNo != '')
              TextButton(
                onPressed: () {
                  setState(() {
                    commentNo = '';
                    replyNo = '';
                    commentController.text = '';
                  });
                },
                child: Text('취소'),
              ),
            TextButton(
              onPressed: () {
                // 댓글 등록
                saveComment();
              },
              child: Text('게시'),
            ),
          ],
        ),
      ],
    ),
  );
}
}
