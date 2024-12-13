import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload/upload_detail_post.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload/upload_detail_photo_filter.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload/upload_detail_search_music.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadDetail extends StatefulWidget {

  const UploadDetail({super.key});

  @override
  State<UploadDetail> createState() => _UploadDetailState();
}

class _UploadDetailState extends State<UploadDetail> {
  final UploadController controller = Get.put(UploadController()); // 컨트롤러
  late PageController _pageController; // 페이지 컨트롤러

  @override
  void initState() {
    super.initState();

    // 선택된 이미지가 있으면 컨트롤러에 추가
    _pageController = PageController(initialPage: controller.currentIndex.value);
  }

  @override
  void dispose() {

    // 페이지 컨트롤러 해제
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // 이미지 미리보기
  Widget _imagePreview() {
    return Obx(() {
      // 선택된 이미지가 없으면
      if (controller.selectedImages.isEmpty) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: const Center(child: Text('선택된 이미지가 없습니다.')),
        );
      }
      return SizedBox(
        height: MediaQuery.of(context).size.width,
        // 페이지뷰
        child: PageView.builder(
          controller: _pageController,
          itemCount: controller.filteredImages.length,
          onPageChanged: (index) {
            controller.currentIndex.value = index;
          },
          itemBuilder: (context, index) {
            // 이미지 위젯
            return FutureBuilder<Uint8List?>(
              future: controller.filteredImages[index].originBytes, // 원본 이미지 가져오기
              builder: (context, snapshot) {
                // 이미지 로딩 중
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 이미지 로드 실패
                if (!snapshot.hasData) {
                  return const Center(child: Text('이미지를 로드할 수 없습니다.'));
                }
                // 이미지 로드 성공
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                );
              },
            );
          },
        ),
      );
    });
  }


  // 이벤트 그룹
  Widget _eventGroup() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 음악 추가 버튼
              GestureDetector(
                onTap: () {
                  //
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const UploadDetailSearchMusic(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.music_note),
                ),
              ),
              const SizedBox(width: 20),
              // 사진 필터 버튼
              GestureDetector(
                onTap: () {
                  if (controller.selectedImages.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('필터를 적용할 이미지를 선택해주세요.')),
                    );
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => UploadDetailPhotoFilter(
                      image: controller.selectedImages[controller.currentIndex.value],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.filter),
                ),
              ),
              const SizedBox(width: 20),
              // 조정 버튼
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.tune),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 버튼 그룹
  Widget _buttonGroup() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (controller.selectedImages.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('이미지를 선택해주세요.')),
                );
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UploadDetailPost(selectedImages: controller.selectedImages),
                ),
              );
            },
            child: const Text(
              '다음 ➡️',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('업로드'),
      ),
      body: Column(
        children: [
          _imagePreview(),
          const SizedBox(height: 8),
          _eventGroup(),
          const SizedBox(height: 8),
          _buttonGroup(),
        ],
      ),
    );
  }
}
