import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image/image.dart' as img;

class UploadDetailPhotoFilter extends StatefulWidget {
  final AssetEntity image; // 필터를 적용할 이미지

  UploadDetailPhotoFilter({Key? key, required this.image}) : super(key: key);

  @override
  State<UploadDetailPhotoFilter> createState() => _UploadDetailPhotoFilterState();
}

class _UploadDetailPhotoFilterState extends State<UploadDetailPhotoFilter> {
  final ValueNotifier<String> _selectedFilter = ValueNotifier<String>('기본'); // 선택된 필터
  final UploadController controller = Get.put(UploadController()); // UploadController 인스턴스

  /// 원본 이미지 데이터를 Uint8List로 가져오기
  Future<Uint8List?> _getImageBytes() async {
    return await widget.image.originBytes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3, // 필터 UI의 높이 비율 설정
      child: Column(
        children: [
          const SizedBox(height: 60), // 상단 여백
          Expanded(
            // 이미지 로드 및 필터 옵션 제공
            child: FutureBuilder<Uint8List?>(
              future: _getImageBytes(), // 원본 이미지 로드
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // 로딩 중 표시
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('이미지를 로드할 수 없습니다.')); // 로드 실패 메시지
                }

                final imageBytes = snapshot.data!; // 로드된 이미지 데이터
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    // 필터 옵션 리스트
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _filterOption('기본', imageBytes),
                          _filterOption('흑백', imageBytes),
                          _filterOption('밝게', imageBytes),
                          _filterOption('어둡게', imageBytes),
                        ],
                      ),
                    ),
                    // 버튼: 취소, 필터, 완료
                    SizedBox(
                      height: 80,
                      child: Column(
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                              const Spacer(),
                              const Text('필터', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  print('필터 적용 완료: ${_selectedFilter.value}');
                                  Navigator.pop(context);
                                },
                                child: const Text('완료', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 필터 옵션 위젯 생성
  Widget _filterOption(String label, Uint8List imageBytes) {
    Uint8List? filteredBytes = _applyFilterEffect(imageBytes, label); // 필터 적용

    if (filteredBytes == null) {
      print('$label 필터 적용 중 오류 발생');
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () async {
        Uint8List? filteredAsset = controller.applyFilter(filteredBytes, label); // 필터 저장
        if (filteredAsset != null) {
          print('필터 적용 성공: $label');
          print('필터 적용 완료: ${controller.currentIndex.value}');
          print('필터 적용 완료: ${controller.filteredImages[controller.currentIndex.value]}');
          controller.filteredImages[controller.currentIndex.value] = (await controller.convertUint8ListToAssetEntity(filteredAsset))!; // 필터 적용된 이미지 저장
          controller.filteredImages.refresh(); // 필터 적용된 이미지 갱신
          Navigator.pop(context);
        } else {
          print('필터 적용 실패: $label');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                filteredBytes,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 필터 효과 적용
  Uint8List? _applyFilterEffect(Uint8List imageBytes, String filter) {
    final String imageFormat = detectImageFormat(imageBytes); // 이미지 형식 확인

    if (imageFormat == 'Unknown') {
      print('이미지 형식 확인 실패');
      return null;
    }

    // HEIC 이미지 변환
    if (imageFormat == 'HEIC') {
      imageBytes = controller.convertToJpeg(imageBytes, 'jpeg')!;
    }

    final img.Image? decodedImage = img.decodeImage(imageBytes); // 이미지 디코딩

    if (decodedImage == null) {
      print('이미지 디코딩 실패');
      return null;
    }

    if (filter == '흑백') {
      return Uint8List.fromList(img.encodeJpg(img.grayscale(decodedImage)));
    } else if (filter == '밝게') {
      img.adjustColor(decodedImage, brightness: 1.2);
      return Uint8List.fromList(img.encodeJpg(decodedImage));
    } else if (filter == '어둡게') {
      img.adjustColor(decodedImage, brightness: 0.8);
      return Uint8List.fromList(img.encodeJpg(decodedImage));
    }

    return imageBytes; // 기본 필터 (변화 없음)
  }

  /// 이미지 형식 확인
  String detectImageFormat(Uint8List imageBytes) {
    if (imageBytes.length > 4) {
      final header = imageBytes.sublist(0, 4);

      if (header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF) {
        return 'JPEG';
      } else if (header[0] == 0x89 &&
          header[1] == 0x50 &&
          header[2] == 0x4E &&
          header[3] == 0x47) {
        return 'PNG';
      } else if (header[0] == 0x00 &&
          header[1] == 0x00 &&
          header[2] == 0x00 &&
          (header[3] == 0x18 || header[3] == 0x1C)) {
        return 'HEIC';
      }
    }
    return 'Unknown';
  }
}
