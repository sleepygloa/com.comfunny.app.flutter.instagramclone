import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/avatar_widget.dart';

class MypageProfileEdit extends StatefulWidget {
  const MypageProfileEdit({super.key});

  @override
  State<StatefulWidget> createState() => _MypageProfileEditState();
}

class _MypageProfileEditState extends State<MypageProfileEdit> with TickerProviderStateMixin {
  bool _isLoggedIn = false; //로그인 상태

  final InstargramDataController dataController = Get.put(InstargramDataController());


  //초기화
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _checkLoginStatus();
  }

  //화면 로딩할때 dataController 에서 값을 불러와서 세팅
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userNameController.text = dataController.apiData["userName"] ?? '';
    _descriptionController.text = dataController.apiData["description"] ?? '';
  }

  //사진
  File? _image;
  //사진,카메라 열기
  Future<void> _pickImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _uploadImage();
      });
    }
  }
  //사진,앨범에서 선택
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _uploadImage();
      });
    }
  }
  //프로필 이미지
  Widget _getProfileImage([double? radius]) {
    return (
        dataController.getNullCheckApiData(dataController.apiData["thumbnailPth"])?
        AvatarWidget(
          type: AvatarType.type4,
          thumbPath: "http://localhost:8080/"+dataController.apiData["thumbnailPth"],
          size: (radius != null ? radius * 2 : 80),
        )
        : (
          _image == null
            ? AvatarWidget(
                type: AvatarType.type4,
                thumbPath: '',
                size: (radius != null ? radius * 2 : 80),
              )
              :
            CircleAvatar(
              radius: radius ?? 40,
              backgroundImage: FileImage(_image!),
            )
          )
    );
  }
  //이미지 업로드
  Future<void> _uploadImage() async {
    final String userName = _userNameController.text;
    final String description = _descriptionController.text;

    // if (_image == null) return;

    var result = await ApiService.sendApiFile(context, '/api/instargram/mypage/saveMyProfileImg', {
      'image': _image,
      'userName': userName,
      'description': description,
    });

    dataController.apiData["thumbnailPth"] = _image;
    dataController.apiData["userName"] = userName;
    dataController.apiData["description"] = description;
  }
  //탭
  late TabController tabController;

  //입력 컨트롤러
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  //로그인 상태 확인
  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }
  //설정 저장
  Future<void> _saveSettings() async {
    final String userName = _userNameController.text;
    final String description = _descriptionController.text;

    dataController.apiData["userName"] = userName;
    dataController.apiData["description"] = description;

    final result = await ApiService.sendApi(context, '/api/instargram/mypage/saveMyPage', {
        'userName': userName,
        'description': description,
    });

    //실패시
    if(result == null || result['stsCd'] != 200) return;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '프로필 편집',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            //설정 저장
            _uploadImage();
            // 뒤로가기
            print('뒤로가기');
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(IconPath.backBtnIcon),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          _profileImg(),
          _profile(),
        ],
      ),
    );
  }

  //프로필 이미지
  Widget _profileImg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //이미지
        GestureDetector(
          onTap: () {
            //하단 모달 바텀시트(사진선택, 사진찍기, 사진삭제))
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        controller: tabController,
                        indicatorColor: Colors.black,
                        tabs: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _getProfileImage(20),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(IconPath.defaultAvatar),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('라이브러리에서 선택'),
                                  onTap: () {
                                    //showModalBottomSheet 닫기
                                    Navigator.of(context).pop();
                                    // 라이브러리에서 선택 기능 추가
                                    _pickImage();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('사진 찍기'),
                                  onTap: () {
                                    // 사진 찍기 기능 추가
                                    Navigator.of(context).pop();
                                    // 카메라 열기
                                    _pickImageFromCamera();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete, color: Colors.red),
                                  title: const Text(
                                    '현재 사진 삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () {
                                    // 현재 사진 삭제 기능 추가
                                    Navigator.of(context).pop();
                                    // 이미지 삭제
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                    child: Text(
                                      '회원님의 또다른 모습을 보여주세요\n현재 아바타 기능은 작동하지 않습니다.', 
                                      style: TextStyle(
                                        fontSize: 14, 
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      ),
                                      onPressed: () {
                                        // Implement camera functionality here
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '아바타 만들기',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  _getProfileImage(),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(IconPath.defaultAvatar),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '사진 또는 아바타 수정',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //
  Widget _profile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  '이름',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    hintText: '이름을 편집하세요',
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  '소개',
                  style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                  hintText: '소개를 입력하세요',
                  border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}