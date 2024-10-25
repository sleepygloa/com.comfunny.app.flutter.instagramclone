import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class Upload extends StatefulWidget{
  const Upload({super.key});

  @override
  State<StatefulWidget> createState() => _UploadState();
}

class _UploadState extends State<Upload>{
  var albums = <AssetPathEntity>[]; //앨범 리스트
  var imageList = <AssetEntity>[]; //이미지 리스트
  var headerTitle = '';
  AssetEntity? selectedImage;

  @override
  void initState(){
    super.initState();
    _loadPhotos();
  }

  void _loadPhotos() async {
    //사진 불러오기
    var result = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,  // 읽기 및 쓰기 권한
      ),
    );
    if(result.isAuth){
      //권한이 있을 때
      albums = await PhotoManager.getAssetPathList( //앨범 리스트 가져오기
        type: RequestType.image,  //이미지 타입
        filterOption: FilterOptionGroup( 
          imageOption: const FilterOption( 
            sizeConstraint: SizeConstraint(
              minWidth: 100,
              minHeight: 100
            ),
          ),
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: false
            ),
          ]
        )
      );

      _loadData();
    }else{
      //권한이 없을 때 권한요청

    }
  }

  void _loadData() async {
    headerTitle = albums.first.name; 
    await _pagingPhotos();
    update();
  }

  Future<void> _pagingPhotos() async {
    //앨범의 사진 리스트 가져오기
    var photos = await albums.first.getAssetListPaged(page:0, size:30);
    imageList.addAll(photos);
    selectedImage = imageList.first;
  }

  void update() => setState((){}); //화면 갱신

  Widget _imagePreview(){
  var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: width,
      color: Colors.grey,
      child: selectedImage == null 
      ? Container() 
      : _photoWidget(
        selectedImage!, 
        width.toInt(),
        builder: (data){
          return Image.memory(
            data,
            fit: BoxFit.cover,
          );
        }
      )
    );
  }

  Widget _header(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              //앨범 선택
              showModalBottomSheet(
                context: context, 
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
                //showModalBottomSheet 화면끝까지 올라오게
                // isScrollControlled: true,
                // constraints: BoxConstraints(
                //   maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top
                // ),
                //
                builder: (_)=>SizedBox(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: 
                      [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 7),
                            color: Colors.black54,
                            width: 40,
                            height: 4,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: 
                              List.generate(
                                albums.length,
                                (index)=>Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  child: Text(
                                    albums[index].name,
                                    style: const TextStyle(color: Colors.black, fontSize: 18),
                                  ),
                                )
                              ),
                            ),
                          ),
                        )
                      ]
                    ,
                  )
                )
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    headerTitle,
                    style: const TextStyle(color: Colors.black, fontSize: 18)
                    ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black)
                ]
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xff808080),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Row(
                  children: [
                    ImageData(IconPath.imageSelectIcon),
                    const SizedBox(width: 7,),
                    const Text(
                      '여러 항목 선택',
                      style: TextStyle(color: Colors.white, fontSize: 14)
                    )
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff808080),
                ),
                child: ImageData(IconPath.cameraIcon),
              )
            ],
          )
        ],
      ),
    );
  }

  //이미지 선택 리스트
  Widget _imageSelectList(){
    return GridView.builder(
      //뷰가 스크롤 되지 않도록
      physics: const NeverScrollableScrollPhysics(), //스크롤 금지
      shrinkWrap: true, //사이즈에 맞게 축소

      //그리드뷰 설정
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, //한줄에 4개
        childAspectRatio: 1, //가로세로 비율
        mainAxisSpacing: 1, //세로 간격
        crossAxisSpacing: 1, //가로 간격
      ), 
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index){
        return _photoWidget(imageList[index], 100, builder:(data){
          return GestureDetector
          (
            onTap: (){
              selectedImage = imageList[index];
              update();
            },
            child: Opacity(
              opacity: imageList[index] == selectedImage ? 0.3 : 1 ,
              child : Image.memory(
              data,
              fit: BoxFit.cover,
              )
            ),
          );
        });
      }
    );
  }

  //이미지 위젯
  Widget _photoWidget(AssetEntity asset, int size, {required Widget Function(Uint8List) builder}){
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)), //이미지 데이터 가져오기 
      builder: (_, AsyncSnapshot<Uint8List?> snapshot){
        if(snapshot.hasData){
          return builder(snapshot.data!);
        }else{
          return Container();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(IconPath.closeImage),
          ),
        ),
        title: const Text(
          'New post', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.black, 
            fontSize: 20
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(IconPath.nextImage, width: 50),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePreview(),
            _header(),
            _imageSelectList(),
          ],
        )
      ),
    );
  }
  
}