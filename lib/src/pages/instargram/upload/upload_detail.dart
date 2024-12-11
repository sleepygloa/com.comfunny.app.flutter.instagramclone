import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload/upload_detail%20post.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadDetail extends StatefulWidget {
  final List<AssetEntity>? selectedImages; // 여러 이미지를 받을 수 있도록 변경

  const UploadDetail({super.key, this.selectedImages});

  @override
  State<UploadDetail> createState() => _UploadDetailState();
}

class _UploadDetailState extends State<UploadDetail> {
  final UploadController controller = Get.put(UploadController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(controller.selectedImages);
  }

  // 이미지 미리보기
  Widget _imagePreview() {
    if (controller.selectedImages == null || controller.selectedImages!.isEmpty) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width,
        color: Colors.grey,
        child: const Center(
          child: Text(
            '선택한 이미지가 없습니다.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.selectedImages!.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            child: _photoWidget(
              controller.selectedImages![index],
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
  }

  // 이미지 위젯
  Widget _photoWidget(AssetEntity asset, int size, {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)), // 이미지 데이터 가져오기
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.music_note),
              ),
              const SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.filter),
              ),
              const SizedBox(width: 20),
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
              if (controller.selectedImages == null || controller.selectedImages!.isEmpty) {
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
