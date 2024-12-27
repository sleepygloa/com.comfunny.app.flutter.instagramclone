import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/component/image_util.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/home.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:image/image.dart' as img;


class UploadDetailPost extends StatefulWidget {
  final List<AssetEntity>? selectedImages; // 여러 이미지를 받을 수 있도록 변경

  const UploadDetailPost({super.key, this.selectedImages});

  @override
  State<UploadDetailPost> createState() => _UploadDetailPostState();
}

class _UploadDetailPostState extends State<UploadDetailPost> {
  InstargramDataController dataController = Get.find<InstargramDataController>();
  final UploadController controller = Get.put(UploadController());
  // List<AssetEntity>? get selectedImages => widget.selectedImages; // 여러 이미지를 참조
  final TextEditingController _contentController = TextEditingController();
  String? _taggedPeoples;
  String? _music;
  String? _shareTarget;
  String? _location;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // 이미지 미리보기 위젯 (여러 이미지 지원)
  Widget _imagePreview() {
    return Obx(() {
      return SizedBox(
        height: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.filteredImages!.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: _photoWidget(
                controller.filteredImages![index],
                MediaQuery.of(context).size.width.toInt(),
                builder: (data) {
                  return Image.memory(
                    data,
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget _photoWidget(AssetEntity asset, int size, {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)),
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // 이벤트 그룹 위젯 (기존과 동일)
  Widget _eventGroup() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 내용 입력 필드
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: '문구를 작성하거나 설문을 추가하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: null,
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          // 나머지 이벤트 필드
          _buildRow(Icons.person_add, '사람 태그', () => setState(() => _taggedPeoples = 'Tagged People')),
          _buildRow(Icons.music_note, '음악 추가', () => setState(() => _music = 'Selected Music')),
          _buildRow(Icons.share_rounded, '공개 대상', () => setState(() => _shareTarget = 'Selected Audience')),
          _buildRow(Icons.location_pin, '위치 추가', () => setState(() => _location = 'Selected Location')),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _savePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '공유',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 공통 행 빌더
  Widget _buildRow(IconData icon, String title, VoidCallback onTap) {
    return Row(
      children: [
        IconButton(icon: Icon(icon), onPressed: onTap),
        Text(title),
        const Spacer(),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  // 게시물 저장
  Future<void> _savePost() async {
    dataController.isLoading.value = true; // 로딩 시작

    // 최대 크기 (예: 10MB = 10 * 1024 * 1024 bytes)
    const int maxSizeInBytes = 10 * 1024 * 1024;

    // 이미지를 압축하여 ByteData로 변환
    List<Uint8List> compressedImageDataList = [];
    for (var asset in controller.filteredImages ?? []) {
      final data = await asset.originBytes; // 원본 이미지 데이터
      if (data != null) {
        try {
          final compressedData = await compressImage(data, maxSizeInBytes);
          compressedImageDataList.add(compressedData);

          // 압축된 이미지 크기를 로그로 출력
          print('압축된 이미지 크기: ${compressedData.lengthInBytes / 1024 / 1024} MB');
          if (compressedData.lengthInBytes > maxSizeInBytes) {
            print("이미지 크기 초과: ${compressedData.lengthInBytes / 1024 / 1024} MB");
            throw Exception("이미지 크기가 서버에서 허용하는 최대 크기를 초과했습니다.");
          }
        } catch (e) {
          print("이미지 압축 실패: $e");
        }
      }
    }
    

    // API 요청
    var result = await ApiService.sendApiFile(context, '/api/instargram/post/savePost', {
      'filelist': compressedImageDataList, // 압축된 이미지 전달
    });

    if (result == null) {
      print('게시물 저장 실패');
      return;
    }
    final content = _contentController.text;
    // API 요청
    var result2 = await ApiService.sendApi(context, '/api/instargram/post/saveMetadata', {
      // 'images': compressedImageDataList, // 압축된 이미지 전달
      'content': content,
      'list': result['list'],
    });

    if (result2 == null) {
      print('게시물 저장 실패');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('게시물 저장 성공')),
    );



    //Upload.dart 누르기 전 탭으로 이동
    dataController.isLoading.value = false; // 로딩 시작
    // Get.offAll(Home());
    BottomNavController.to.changeBottomNav(0);
  }

  //이미지 압축
  Future<Uint8List> compressImage(Uint8List imageData, int maxSizeInBytes) async {
    int quality = 100; // 초기 압축 품질
    Uint8List compressedData = imageData;

    // 반복적으로 압축하여 크기를 제한 이하로 줄임
    while (compressedData.lengthInBytes > maxSizeInBytes && quality > 0) {
      final result = await ImageUtil.compressImageData(imageData, quality: quality);
      if (result != null) {
        compressedData = result;
        print('압축 품질 $quality로 재압축, 크기: ${compressedData.lengthInBytes / 1024} KB');
      }
      quality -= 10; // 품질을 점진적으로 낮춤
    }

    if (compressedData.lengthInBytes > maxSizeInBytes) {
      throw Exception('이미지를 최대 크기로 압축할 수 없습니다.');
    }
    return compressedData;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시물 업로드')),
      body: Column(
        children: [
          _imagePreview(),
          const SizedBox(height: 8),
          Expanded(child: _eventGroup()),
        ],
      ),
    );
  }
}
