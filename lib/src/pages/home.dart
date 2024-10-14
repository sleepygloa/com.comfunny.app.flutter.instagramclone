import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/components/post_widget.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  Widget _myStory(){
    return Stack(
      children: [
        AvatarWidget(
          type: AvatarType.type2,
          thumbPath: 'https://newsimg-hams.hankookilbo.com/2022/09/18/194f6bfb-b902-4298-9edc-3e855626a56d.jpg',
          size: 70,
        ),
        Positioned(
          right: 5,
          bottom: 0,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Text(
                '+', 
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            )
          ),
        ),
      ],
    );
  }

  //가로 스크롤 리스트
  //팔로우 친구들의 스토리 리스트
  Widget _storyBoardList(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      //스토리 리스트
      child: Row(
        children: [
          const SizedBox(width: 20,),
          //나의 스토리
          _myStory(),
          const SizedBox(width: 5,),
          //친구 스토리 리스트
          ...List.generate(
          100,
          (index) => AvatarWidget(
            type: AvatarType.type1,
            thumbPath: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg',
          ),
        ),
        ]
      ),
    );
  }

  //포스트 리스트
  Widget _postList(){
    return Column(
      children: List.generate(50, (index) => const PostWidget()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: ImageData(IconPath.logo, width: 270,),
        actions: [
          GestureDetector(
            onTap: (){},
            child: Padding(padding: const EdgeInsets.all(15.0),
            child: ImageData(IconPath.directMessage, width: 50,),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _storyBoardList(),
          _postList(),
        ],
      ),
    );
  }
} 