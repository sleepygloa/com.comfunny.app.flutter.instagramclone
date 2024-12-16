import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/upload_adjustment_dto.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image/image.dart' as img;

class UploadController extends GetxController {
  var currentIndex = 0.obs; // 현재 인덱스
  var headerTitle = ''.obs; // 헤더 제목
  RxList<AssetPathEntity> albums = <AssetPathEntity>[].obs; // 앨범 목록
  RxList<AssetEntity> imageList = <AssetEntity>[].obs; // 이미지 목록
  var lastSelectImages = AssetEntity(id: '0', typeInt: 0, width: 0, height: 0).obs; // 마지막 선택된 이미지
  RxList<AssetEntity> filteredImages = <AssetEntity>[].obs; // 필터 적용된 이미지
  RxList<File> tempFilteredSaveFiles = <File>[].obs; // 필터 기능 이용을 위한 임시 저장 파일 리스트
  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs; // 선택된 이미지
  RxBool isMultipleSelection = false.obs; // 멀티 선택 모드 여부

  // RxList<AdjustmentModel> adjustmentValues =
  //     RxList<AdjustmentModel>.generate(3, (_) => AdjustmentModel(tilt: 0.0));
  RxList<AdjustmentModel> adjustmentValues =
      RxList<AdjustmentModel>.generate(3, (_) => AdjustmentModel(tilt: 0.0));


  RxList<double> tiltValues = <double>[].obs; // 각 이미지의 기울기 값

  @override
  void onInit() {
    super.onInit();
    _loadPhotos();

  }

  @override
  void onClose() {
    super.onClose();
    _clearTemporaryFiles();
  }

  // 사진의 조정 값 초기화
  void initializeAdjustmentValues() {
    adjustmentValues.clear();
    for (int i = 0; i < filteredImages.length; i++) {
      adjustmentValues.add(AdjustmentModel()); // 초기값 생성
    }
    // adjustmentValues.clear();
    // for (int i = 0; i < filteredImages.length; i++) {
    //   adjustmentValues.add(AdjustmentModel()); 
    //   // 초기값 생성
    // }

    selectedImages.refresh();
    filteredImages.refresh();
  }

  // // 조정 값 업데이트
  // void updateAdjustmentValue(int index, AdjustmentModel adjustment) {
  //   if (index >= 0 && index < adjustmentValues.length) {
  //     adjustmentValues[index] = adjustment;
  //     adjustmentValues.refresh();
  //   }
  // }

  // void updateAdjustment(int tabIndex, AdjustmentModel adjustment) {
  //   adjustmentValues[tabIndex] = adjustment;
  //   adjustmentValues.refresh(); // UI와 동기화
  // }

  
  // 임시 파일 정리
  Future<void> _clearTemporaryFiles() async {
    try {
      print(tempFilteredSaveFiles.length);
      for (var file in tempFilteredSaveFiles) {
        if (await file.exists()) {
          await file.delete();
        }
      }
      tempFilteredSaveFiles.clear();
      print('필터 임시 파일 정리 완료');
    } catch (e) {
      print('임시 파일 정리 중 오류 발생: $e');
    }
  }

  // 사진 불러오기
  void _loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
      ),
    );
    if (result.isAuth) {
      var albumList = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );
      albums.addAll(albumList);
      _loadData();
    }
  }

  // 앨범 데이터 로드
  void _loadData() async {
    if (albums.isNotEmpty) {
      headerTitle.value = albums.first.name;
      await _pagingPhotos();
    }
  }

  // 페이징 처리
  Future<void> _pagingPhotos() async {
    var photos = await albums.first.getAssetListPaged(page: 0, size: 30);
    imageList.addAll(photos);
    handleImageSelection(imageList.first);
  }

  // 이미지 선택 모드 토글
  void toggleSelectionMode() {
    isMultipleSelection.value = !isMultipleSelection.value;
    if (!isMultipleSelection.value) {
      selectedImages.clear();
      selectedImages.add(lastSelectImages.value);
      filteredImages.clear();
      filteredImages.add(lastSelectImages.value);
    }
  }

  // 이미지 선택
  void handleImageSelection(AssetEntity asset) async {
    if (isMultipleSelection.value) {
      if (selectedImages.contains(asset)) {
        selectedImages.remove(asset);
        filteredImages.remove(asset);
      } else {
        selectedImages.add(asset);
        filteredImages.add(asset);
      }
    } else {
      selectedImages.clear();
      filteredImages.clear();
      selectedImages.add(asset);
      filteredImages.add(asset);
      tiltValues.add(0.0); // 초기 기울기 값을 0으로 설정
    }
    tiltValues.clear();
    tiltValues.addAll(List.filled(selectedImages.length, 0.0));

    lastSelectImages(asset);
    selectedImages.refresh();
    filteredImages.refresh();
  }

  // 필터 적용
  Uint8List? applyFilter(Uint8List imageBytes, String filter) {
    // 이미지 형식 확인
    final String format = detectImageFormat(imageBytes);
    print('이미지 형식: $format');

    // HEIC 및 기타 형식 처리
    Uint8List? jpegBytes = convertToJpeg(imageBytes, format);
    if (jpegBytes == null) {
      print('이미지를 변환할 수 없습니다.');
      return null;
    }

    // JPEG 데이터로 필터 적용
    final img.Image? image = img.decodeImage(jpegBytes);
    if (image == null) {
      print('이미지 디코딩 실패');
      return null;
    }

    // 필터 적용 로직
    switch (filter) {
      case '흑백':
        return Uint8List.fromList(img.encodeJpg(img.grayscale(image)));
      case '밝게':
        img.adjustColor(image, brightness: 1.2);
        return Uint8List.fromList(img.encodeJpg(image));
      case '어둡게':
        img.adjustColor(image, brightness: 0.8);
        return Uint8List.fromList(img.encodeJpg(image));
      default:
        return jpegBytes; // 기본 필터 (변화 없음)
    }
  }

  // Uint8List 이미지를 JPEG 형식으로 변환
  Uint8List? convertToJpeg(Uint8List imageBytes, String format) {
    try {
      if (format == 'HEIC') {
        print('HEIC 이미지를 JPEG로 변환 중...');
        return _heicToJpeg(imageBytes);
      }
      if (format == 'JPEG' && isValidJpeg(imageBytes)) {
        return fixJpeg(imageBytes);
      }
      final img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        print('이미지 디코딩 실패');
        return null;
      }
      return Uint8List.fromList(img.encodeJpg(image));
    } catch (e) {
      print('JPEG 변환 중 오류 발생: $e');
      return null;
    }
  }

  // HEIC 데이터를 JPEG 이미지로 변환
  Uint8List? _heicToJpeg(Uint8List heicBytes) {
    try {
      final tempDir = Directory.systemTemp;
      final heicFile = File('${tempDir.path}/temp_image.heic');
      heicFile.writeAsBytesSync(heicBytes);

      final jpegFile = File('${tempDir.path}/temp_image.jpg');
      tempFilteredSaveFiles.add(jpegFile); // 파일을 관리 리스트에 추가
      return heicFile.readAsBytesSync(); // HEIC -> JPEG 변환 로직
    } catch (e) {
      print('HEIC -> JPEG 변환 중 오류 발생: $e');
      return null;
    }
  }

  // JPEG 파일인지 확인
  bool isValidJpeg(Uint8List imageBytes) {
    return imageBytes.length > 4 &&
        imageBytes[0] == 0xFF &&
        imageBytes[1] == 0xD8 &&
        imageBytes[imageBytes.length - 2] == 0xFF &&
        imageBytes[imageBytes.length - 1] == 0xD9;
  }

  // JPEG 파일 수정
  Uint8List fixJpeg(Uint8List imageBytes) {
    if (isValidJpeg(imageBytes)) return imageBytes;
    return Uint8List.fromList([...imageBytes, 0xFF, 0xD9]);
  }

  // 이미지 형식 확인
  String detectImageFormat(Uint8List imageBytes) {
    if (imageBytes.length > 4) {
      final header = imageBytes.sublist(0, 4);
      if (header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF) return 'JPEG';
      if (header[0] == 0x89 && header[1] == 0x50 && header[2] == 0x4E && header[3] == 0x47) return 'PNG';
      if (header[0] == 0x00 && header[1] == 0x00 && header[2] == 0x00 && (header[3] == 0x18 || header[3] == 0x1C)) return 'HEIC';
    }
    return 'Unknown';
  }

  /// Uint8List 데이터를 AssetEntity로 변환하는 함수
  Future<AssetEntity?> convertUint8ListToAssetEntity(Uint8List imageBytes, {String title = 'image.jpg'}) async {
    try {
      // 임시 디렉토리에 파일 저장
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$title');
      await tempFile.writeAsBytes(imageBytes);

      // 파일을 AssetEntity로 변환
      final AssetEntity? asset = await PhotoManager.editor.saveImage(
        await tempFile.readAsBytes(),
        title: title, filename: 'temp_image.jpg',
      );

      tempFilteredSaveFiles.add(tempFile); // 파일을 관리 리스트에 추가

      if (asset == null) {
        print('AssetEntity 변환 실패');
      } else {
        print('AssetEntity 변환 성공: ${asset.title}');
      }

      return asset;
    } catch (e) {
      print('Uint8List -> AssetEntity 변환 중 오류 발생: $e');
      return null;
    }
  }


  // 기울기 값 업데이트
  void updateTiltValue(int index, double value) {
    if (index >= 0 && index < tiltValues.length) {
      tiltValues[index] = value;
      tiltValues.refresh();
    }
  }
}
