import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/search/search_focus.dart';
import 'package:get/get.dart';
import 'package:quiver/iterables.dart';

class Search extends StatefulWidget{
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>{
  List<List<int>> groupBox = [[],[],[]];
  List<int> groupIndex = [0,0,0];

  //초기화
  @override
  void initState(){
    super.initState();

    for(int i = 0; i < 100; i++){
      //가장 작은 그룹의 인덱스
      var gi = groupIndex.indexOf(min<int>(groupIndex)!);
      var size = 1;
      if(gi != 1){
        size = Random().nextInt(100)%2 == 0 ? 1 : 2;
      }
      groupBox[gi].add(size);
      groupIndex[gi] += size; //가장 작은 그룹의 인덱스에 사이즈 추가
    }
  }

  //검색바
  Widget _appbar(){
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SearchFocus()));
            },
            //검색바
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xffefefef),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  Text(
                    '검색',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff838383),
                    ),
                  )
                ],
              )
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.location_pin),
        )
      ],
    );
  }

  //검색바 아래 바
  Widget _body(){
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //세로축에서 시작점 정렬
        children: 
          List.generate(
            groupBox.length,
            (i) => Expanded(
              child: Column(
                children: List.generate(
                  groupBox[i].length,
                  (j) => Container(
                    height: Get.width * 0.33 * groupBox[i][j],
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.primaries[
                        Random().nextInt(Colors.primaries.length)
                        ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg',
                      fit: BoxFit.cover,
                    )

                  )
                ).toList(),
              ),
            )
          ).toList(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Column(
          children: [
            _appbar(),
            Expanded(child: _body()),
          ],
        ))
    );
  }
}