import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:flutter_clone_instagram/src/pages/wms/ib_exam.dart';
import 'package:get/get.dart';

import 'pages/wms/st_move.dart';
import 'pages/wms/st_stock_inq.dart';

class AppWms extends GetView<BottomNavController> {
  const AppWms({super.key});

  // 검색
  Future<void> _logout(context) async {
    String url = '/login/logout';

    var result = await ApiService.sendApi(context, url, null);
    if (result != null) {
      Get.to(() => LoginPage());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //그림자 제거
        title: const Text(
          '창고관리앱',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
        actions: [
          GestureDetector(
            onTap: (){
                showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                    leading: Icon(Icons.person),
                    title: Text('프로필'),
                    onTap: () {
                      Navigator.pop(context);
                      // Add your profile navigation logic here
                    },
                    ),
                    ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('로그아웃'),
                    onTap: () {
                      _logout(this);
                    },
                    ),
                  ],
                  );
                },
                );
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> const Setting()));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 16,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const IbExam())),
                  child: const Text('입고검수'),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 16,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => StMove(refVal1: 'IB'),
                        ),
                      );
                  },
                  child: const Text('입고적치'),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 16,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => StMove(refVal1: 'OB'),
                        ),
                      );
                    },
                  child: const Text('출고피킹'),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 16,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => StMove(refVal1: 'ST'),
                        ),
                      );
                    },
                  child: const Text('재고이동'),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 16,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => StStockInq(),
                        ),
                      );
                    },
                  child: const Text('재고조회'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}