import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/%08comment_dto.dart';

class ReplyWidget extends StatelessWidget {
  final List<Reply> replies;

  ReplyWidget({required this.replies});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('답글 보기 (${replies.length})'),
      children: replies.map((reply) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(reply.thumbnailPth),
          ),
          title: Text(reply.userName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reply.content),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {
                      // 좋아요 기능 구현
                    },
                  ),
                  Text('${reply.likeCnt}'),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
