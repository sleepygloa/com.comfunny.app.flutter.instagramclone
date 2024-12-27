import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/search/search_focus.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/search/search_post.dart';
import 'package:get/get.dart';
import 'package:quiver/iterables.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}
class _SearchState extends State<Search> {
  final InstargramDataController dataController = Get.find<InstargramDataController>();
  RxList<List<int>> groupBox = RxList<List<int>>(); // 검색 게시물 그룹 상태
  List<int> groupIndex = <int>[]; // 검색 게시물 그룹 인덱스
  RxList<PostDto> searchPostList = <PostDto>[].obs; // 검색 게시물 데이터 상태

  @override
  void initState() {
    super.initState();
    groupBox.value = List.generate(3, (_) => <int>[]);
    groupIndex = List.generate(3, (_) => 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 초기 데이터 로드
    getSearchPostList(context, '');
  }

  Future<void> getSearchPostList(BuildContext context, String searchWord) async {
    dataController.isLoading.value = true;
    try {
      final result = await ApiService.sendApi(context, '/api/instargram/post/selectPostOfSearch', {
        'search': searchWord
      });
      if (result != null && result['searchs'] != null) {
        dataController.searchPostList.assignAll(
          result['searchs'].map<PostDto>((data) => PostDto.fromJson(data)).toList()
        );

        // 그룹 초기화
        groupBox.clear();
        groupIndex = List.generate(3, (_) => 0);
        for (int i = 0; i < 3; i++) {
          groupBox.add(<int>[].obs);
        }

        // 게시물 데이터 정렬
        for (var post in dataController.searchPostList) {
          var gi = groupIndex.indexOf(min<int>(groupIndex)!);
          var size = (gi != 1 && Random().nextInt(100) % 2 == 0) ? 2 : 1;
          groupBox[gi].add(size);
          groupIndex[gi] += size;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('검색 결과가 없습니다.'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e'))
      );
    } finally {
      dataController.isLoading.value = false;
    }
  }

  Widget _appbar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchFocus())
              );
            },
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
              ),
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

  Widget _body() {
    int counter = 0;
    return SingleChildScrollView(
      child: Obx(() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          groupBox.length,
          (i) => Expanded(
            child: Column(
              children: List.generate(
                groupBox[i].length,
                (j) {
                  String imageUrl = counter < dataController.searchPostList.length
                      ? '${ApiService.serverUrl}/${dataController.searchPostList[counter].list[0].imgPth}'
                      : 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg';

                  int currentCounter = counter;
                  counter++;
                  return GestureDetector(
                    onTap: () {
                      if (currentCounter < dataController.searchPostList.length) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPost(
                              postDto: dataController.searchPostList[currentCounter]
                            )
                          )
                        );
                      } else {
                        print('Index out of range');
                      }
                    },
                    child: Container(
                      height: Get.width * 0.33 * groupBox[i][j],
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ).toList(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appbar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await getSearchPostList(context, '');
                },
                child: _body(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
