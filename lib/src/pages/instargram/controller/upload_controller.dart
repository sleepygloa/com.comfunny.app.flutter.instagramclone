import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadController extends GetxController {
  var currentIndex = 0.obs; // 현재 인덱스
  var headerTitle = ''.obs; // 헤더 타이틀
  RxList<AssetPathEntity> albums = <AssetPathEntity>[].obs; // 앨범 리스트
  RxList<AssetEntity> imageList = <AssetEntity>[].obs; // 이미지 리스트
  var lastSelectImages = AssetEntity(
    id: '0', 
    typeInt: 0, 
    width: 0, 
    height: 0).obs; // 마지막 선택된 이미지
  RxList<AssetEntity> selectedImages = <AssetEntity>[].obs; // 선택된 이미지 리스트
  RxBool isMultipleSelection = false.obs; // 여러 항목 선택 모드 여부

  @override
  void onInit() {
    super.onInit();
    print('UploadController onInit');
    _loadPhotos();

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
    }else{

    }
  }

  // 데이터 불러오기
  void _loadData() async {
    if (albums.isNotEmpty) {
      headerTitle.value = albums.first.name;
      await _pagingPhotos();
    }
  }

  // 사진 페이징
  Future<void> _pagingPhotos() async {
    var photos = await albums.first.getAssetListPaged(page: 0, size: 30);
    imageList.addAll(photos);
    handleImageSelection(imageList.first);
  }

  // 선택 모드 변경
  void toggleSelectionMode() {
    isMultipleSelection.value = !isMultipleSelection.value;
    if (!isMultipleSelection.value) {
      selectedImages.clear();
      selectedImages.add(lastSelectImages.value);
    }
  }

  // 이미지 선택 처리
  void handleImageSelection(AssetEntity asset) {
    if (isMultipleSelection.value) {
      if (selectedImages.contains(asset)) {
        selectedImages.remove(asset);
      } else {
        selectedImages.add(asset);
      }
    } else {
      selectedImages.clear();
      selectedImages.add(asset);
    }
    print('선택된 이미지: $selectedImages');
    lastSelectImages(asset);

    // 강제로 업데이트를 트리거
    // selectedImages.refresh();
  }
}
