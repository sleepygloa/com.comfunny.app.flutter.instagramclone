import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';

class PostWidget extends StatelessWidget{
  const PostWidget({super.key});

  
  Widget _header(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarWidget(
            type: AvatarType.type3, 
            nickname: '김또노',
            size: 40,
            thumbPath: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg',
          ),
          GestureDetector(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageData(
                IconPath.postMoreIcon,
                width: 30,
              ),
            )
          )
        ],
      ),
    );
  }

  //이미지
  Widget _image(){
    return CachedNetworkImage(imageUrl: 'https://ppss.kr/wp-content/uploads/2018/09/zzzzzz.jpg',);
  }

  //좋아요
  Widget _infoCount(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageData(IconPath.likeOffIcon, width: 65,),
              const SizedBox(width: 15,),
              ImageData(IconPath.replyIcon, width: 60,),
              const SizedBox(width: 15,),
              ImageData(IconPath.directMessage, width: 55,),
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
  Widget _infoDescription(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '좋아요 150개',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          ExpandableText(
            '컨텐츠 1 입니다.\n컨텐츠 1 입니다.\n컨텐츠 1 입니다.\n컨텐츠 1 입니다.\n컨텐츠 1 입니다.\n컨텐츠 1 입니다.',
            prefixText: '김또노',
            onPrefixTap: () => print('prefix tapped'),
            prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
            expandText: '더보기',
            collapseText: '접기',
            maxLines: 3, //펼쳐지기 전에 보여줄 줄 수
            expandOnTextTap: true, //더보기를 눌러야 펼쳐지는지 여부
            collapseOnTextTap: true, //접기를 눌러야 접히는지 여부
            linkColor: Colors.grey,
          )
        ],
      ),
    );
  }

  //댓글
  Widget _replyTextBtn(){
    return GestureDetector(
      onTap: (){},
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          '댓글 10개 모두 보기',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          // textAlign: TextAlign.start,
        ),
      )
    );
  }

  //시간
  Widget _dateAgo(){
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        '1일 전',
        style: TextStyle(color: Colors.grey, fontSize: 11),
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
          _replyTextBtn(),
          const SizedBox(height: 5,),
          _dateAgo(),
        ],
      )
    );
  }
}