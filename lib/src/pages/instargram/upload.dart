import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload/upload_detail.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class Upload extends StatefulWidget {
  Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final UploadController controller = Get.put(UploadController());

  // 이미지 미리보기 (한 장씩 스와이프 가능)
  Widget _imagePreview() {
    return Obx((){
      if (controller.selectedImages.isEmpty) {
        return Container(
          color: Colors.grey,
          height: Get.width,
          child: const Center(
            child: Text(
              '선택한 이미지가 없습니다.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }else{
        return SizedBox(
          height: Get.width,
          child: PageView.builder(
                itemCount: controller.selectedImages.length,
                controller: PageController(initialPage: controller.currentIndex.value),
                onPageChanged: (index) {
                  controller.currentIndex.value = index;
                },
                itemBuilder: (context, index) {
                  return _photoWidget(controller.selectedImages[index], Get.width.toInt(), builder: (data) {
                    return Image.memory(
                      data,
                      fit: BoxFit.cover,
                    );
                  });
                },
              ),
        );
      }
    });
  }

  // 헤더
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                isScrollControlled: controller.albums.length > 10,
                builder: (_) => SizedBox(
                  height: 200,
                  child: Obx(() => ListView.builder(
                        itemCount: controller.albums.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(controller.albums[index].name),
                            onTap: () async {
                              controller.headerTitle.value = controller.albums[index].name;
                              controller.imageList.value = await controller.albums[index].getAssetListPaged(
                                page: 0,
                                size: 30,
                              );
                              controller.selectedImages.clear();
                              Get.back();
                            },
                          );
                        },
                      )),
                ),
              );
            },
            child: Obx(() => Row(
                  children: [
                    Text(
                      controller.headerTitle.value,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                )),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: controller.toggleSelectionMode,
                child: Obx(() => Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: controller.isMultipleSelection.value ? Colors.white : const Color(0xff808080),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          ImageData(IconPath.imageSelectIcon,),
                          // const SizedBox(width: 7),
                          // Text(
                          //   controller.isMultipleSelection.value ? '단일 선택' : '여러 항목 선택',
                          //   style: const TextStyle(color: Colors.white, fontSize: 14),
                          // ),
                        ],
                      ),
                    )),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff808080),
                ),
                child: ImageData(IconPath.cameraIcon),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 이미지 선택 리스트
  Widget _imageSelectList() {
    return Obx(() => GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: controller.imageList.length, // 이미지 리스트의 길이
          itemBuilder: (context, index) { // 이미지 위젯 생성
            return _photoWidget(controller.imageList[index], 100, builder: (data) {
              return GestureDetector(
                onTap: () => controller.handleImageSelection(controller.imageList[index]),
                child: Obx(()=>Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(data, fit: BoxFit.cover),
                    if(controller.lastSelectImages == controller.imageList[index])
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    if(controller.isMultipleSelection == true && controller.selectedImages.contains(controller.imageList[index]))
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(color: Colors.black)),
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${controller.selectedImages.indexOf(controller.imageList[index]) + 1}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                )),
              );
            });
          },
        ));
  }

  // 이미지 위젯
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // 1. 뒤로가기 버튼
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // 2. 타이틀
        title: const Text(
          '새 게시물',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        // 3. 액션 버튼
        actions: [
          TextButton(
            onPressed: () {
              if (controller.selectedImages.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadDetail()),
                );
              } else {
                Get.snackbar('알림', '이미지를 선택해주세요.');
              }
            },
            child: const Text(
              '다음',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePreview(),
            _header(),
            _imageSelectList(),
          ],
        ),
      ),
    );
  }
}
