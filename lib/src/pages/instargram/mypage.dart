import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/components/user_card.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/myPage_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_login_controller%20copy.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/profile/mypage_profile_edit.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/profile/setting.dart';
import 'package:get/get.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late TabController tabController;
  final InstargramLoginController loginController = Get.put(InstargramLoginController());
  final InstargramDataController dataController = Get.put(InstargramDataController());

  // var thumbnailPth = '';
  // var postCnt = 0;
  // var followersCnt = 0;
  // var followingCnt = 0;
  // var description = '';

  //내 포스트 리스트
  var myPostList = [];

  @override
  void initState() {
    super.initState();
    
    tabController = TabController(length: 2, vsync: this);
    loginController.checkLoginStatus();
    // MyPage 정보 조회
    // getMyPageUserInfo(context);
    
  }
  //화면이 변경될 때 호출되는 메서드
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginController.checkLoginStatus(); // 화면 진입 시 로그인 상태 확인
    getMyPageUserInfo(context); // 화면 진입 시 MyPage 정보 조회
  }


  //MyPage 의 데이터를 가져오는 메서드
  Future<void> getMyPageUserInfo(BuildContext context) async {
    // API 호출 시뮬레이션
    await Future.delayed(Duration(seconds: 2));

    // ApiService 호출
    var response = await ApiService.sendApi(context, '/api/instargram/mypage/selectMyPage', {});

    // 응답 데이터가 null이 아닌지 확인
    if (response == null) {
      return;
    }

    // mypage_dto.dart 데이터 형식으로 변환
    var userData = MyPageDto.fromJson(response);
    
    // 가져온 데이터로 사용자 데이터 업데이트 
    // setState(() {
    //   // postCnt = userData.postCnt;
    //   // followersCnt = userData.followersCnt;
    //   // followingCnt = userData.followingCnt;
    //   // thumbnailPth = userData.thumbnailPth;
    //   // description = userData.description;
    // });
  }

  //로그아웃
  _logout() async {
    await loginController.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  //통계
  Widget _statisticOne(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  //프로필 정보
  Widget _information() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              //나의 아바타
              GestureDetector(
                child: AvatarWidget(
                  type: AvatarType.type4,
                  thumbPath: dataController.getNullCheckApiData(dataController.apiData["thumbnailPth"]) ? "http://localhost:8080/"+dataController.apiData["thumbnailPth"] : '',
                  size: 80,
                ),
                //클릭시 아바타 확대
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Avatar'),
                        ),
                        body: Center(
                          child: AvatarWidget(
                            type: AvatarType.type4,
                            thumbPath: dataController.getNullCheckApiData(dataController.apiData["thumbnailPth"])? "http://localhost:8080/"+dataController.apiData["thumbnailPth"] : '',
                            size: 200,
                          ),
                        ),
                      ),
                    ),
                  );
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: _statisticOne('Post', dataController.apiData["postCnt"]?? 0 )),
                    Expanded(child: _statisticOne('Followers', dataController.apiData["follwerersCnt"]?? 0 )),
                    Expanded(child: _statisticOne('Following', dataController.apiData["followingCnt"]?? 0 )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Text(
            dataController.apiData["userName"]?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          Text(
            dataController.apiData["description"]?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  //메뉴
  Widget _menu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MypageProfileEdit()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: const Color(0xffdedede),
                  ),
                ),
                child: const Text(
                  '프로필 편집',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ),
          const SizedBox(width: 8,),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: const Color(0xffdedede),
              ),
              color: const Color(0xffefefef),
            ),
            child: ImageData(IconPath.addFriend),
          )
        ],
      ),
    );
  }

  //추천 친구
  Widget _discoverPeople() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discover People',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children:
              List.generate(10, (index) => UserCard(
                userId: '또노$index',
                description: '또노e$index 님이 팔로우합니다.',
                thumbPath: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg'
              )).toList(),
          )
        ),
      ],
    );
  }

  //탭 메뉴
  Widget _tabMenu() {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.black,
      indicatorWeight: 1,
      tabs: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ImageData(IconPath.gridViewOn),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ImageData(IconPath.myTagImageOff),
        ),
      ]
    );
  }

  //탭 뷰
  Widget _tabView() {
    return GridView.builder(
      //SingleCrossAxisExtent : 그리드뷰의 크기를 지정한 값으로 설정
      //위에서 사용중이면 사용 불가 처리 하기 위해 아래 사용
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 100,
      //
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.grey
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '마이 페이지',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: ImageData(
              IconPath.uploadIcon,
              width: 50,
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Setting()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(
                IconPath.menuIcon,
                width: 50,
              ),
            ),
          )
        ],
      ),

      body: RefreshIndicator(
        // 아래로 드래그시 재조회
        onRefresh: () async {
          getMyPageUserInfo(context);
        },
        // 
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _information(),
              _menu(),
              _discoverPeople(),
              _tabMenu(),
              _tabView(),
              // _introduce(),
            ],
          ),
        ),
      ),
    );
  }
}