import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_login_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/mypost/my_post_widget.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //로그인 컨트롤러
  final InstargramLoginController loginController = Get.find<InstargramLoginController>();
  final InstargramDataController dataController = Get.find<InstargramDataController>();


  @override
  void initState() {
    super.initState();
    loginController.checkLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginController.checkLoginStatus(); // 화면 진입 시 로그인 상태 확인
  }

  // 나의 스토리
  Widget _myStory(){
    return Stack(
      children: [
        Obx(()=>AvatarWidget(
          type: AvatarType.type4,
          thumbPath: dataController.myProfile.value.thumbnailPth,
          size: 70,
        )),
        Positioned(
          right: 5,
          bottom: 0,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(
              child: Text(
                '+', 
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            )
          ),
        ),
      ],
    );
  }

  //가로 스크롤 리스트
  Widget _storyBoardList(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      //스토리 리스트
      child: Row(
        children: [
          const SizedBox(width: 20,),
          //나의 스토리
          _myStory(),
          const SizedBox(width: 5,),
          //친구 스토리 리스트
            Obx(() => Row(
            children: List.generate(
              dataController.followUserList.length,
              (index) => AvatarWidget(
              type: AvatarType.type1,
              thumbPath: dataController.followUserList[index].thumbnailPth,
              ),
            ),
            )),
        ]
      ),
    );
  }

  //포스트 리스트
  Widget _postList(){
    return Obx(()=>Column(
      children: List.generate(dataController.postList.length, (index) => MyPostWidget(post: dataController.postList[index], index: 3)).toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: ImageData(IconPath.logo, width: 270,),
        actions: [
          GestureDetector(
            onTap: (){},
            child: Padding(padding: const EdgeInsets.all(15.0),
            child: ImageData(IconPath.directMessage, width: 50,),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 데이터 재조회
          await dataController.getPostList(context);
        },
        child: ListView(
          children: [
            _storyBoardList(),
            _postList(),
          ],
        ),
      ),
    );
  }
} 