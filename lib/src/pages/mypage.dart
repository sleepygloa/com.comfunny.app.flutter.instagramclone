import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/components/user_card.dart';

class MyPage extends StatefulWidget{
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin{ 
  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }


  Widget _statisticOne(String title, int value){
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
  Widget _information(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AvatarWidget(
                type: AvatarType.type3, 
                thumbPath: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg',
                size: 80,
                ),
              const SizedBox(width: 10,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: _statisticOne('Post', 15)),
                    Expanded(child: _statisticOne('Followers', 12)),
                    Expanded(child: _statisticOne('Following', 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          const Text(
            '안녕하세요, 또노님입니다. 구독과 좋아요 부탁드립니다',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  //메뉴
  Widget _menu(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
      child: Row( 
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: const Color(0xffdedede),
                ),
              ),
              child: const Text(
                'Edit Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
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
  Widget _discoverPeople(){
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
                List.generate(10, (index)=> UserCard(
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
  Widget _tabMenu(){
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
  Widget _tabView(){
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
      itemBuilder: (BuildContext context, int index){
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
            onTap: (){},
            child: ImageData(
              IconPath.uploadIcon,
              width: 50,
            ),
          ),
          GestureDetector(
            onTap: (){},
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _information(),
            _menu(),
            _discoverPeople(),
            const SizedBox(height: 20),
            _tabMenu(),
            _tabView(),
          ],
        ),
      ),
    );
  }
}