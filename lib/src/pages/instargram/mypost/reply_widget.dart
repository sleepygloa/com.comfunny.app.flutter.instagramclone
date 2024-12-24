import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';

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
            backgroundImage: NetworkImage('${ApiService.serverUrl}/${reply.thumbnailPth}'),
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
