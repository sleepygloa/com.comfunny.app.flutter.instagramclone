
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';

class ActiveHistory extends StatelessWidget{  
  const ActiveHistory({super.key});

  //최근 활동 아이템
  Widget _activeitemOne(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          AvatarWidget(
            type: AvatarType.type2, 
            size: 40,
            thumbPath: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg'
            ),
          const SizedBox(width: 10,),
          const Expanded(
            child: Text.rich(
              TextSpan(
                text: '또노님', 
                style: TextStyle(
                  // fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '님의 게시물을 좋아합니다.', 
                    style: TextStyle(
                      // fontSize: 16,
                      fontWeight: FontWeight.normal,
                      // color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' 5 일전', 
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ]
              )
            )
          )
        ],
      ),
    );
  }

  //최근 활동 뷰
  Widget _newRecentlyActiveView(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              // color: Colors.black,
            ),
          ),
          const SizedBox(height: 15,),
          _activeitemOne(),
          _activeitemOne(),
          _activeitemOne(),
          _activeitemOne(),
          _activeitemOne(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '활동',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _newRecentlyActiveView('오늘'),
            _newRecentlyActiveView('이번주'),
            _newRecentlyActiveView('이번달'),
          ],
        ),
      ),
    );
  }
}


