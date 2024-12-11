import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/message_popup.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload.dart';
import 'package:get/get.dart';

enum PageName{
  home,
  search,
  upload,
  active,
  mypage,
}

class BottomNavController extends GetxController{
  static BottomNavController get to => Get.find(); //싱글톤
  RxInt pageIndex = 0.obs;
  GlobalKey<NavigatorState> searchPageNavigationKey = GlobalKey<NavigatorState>();
  List<int> bottomHistory = [0];
  InstargramDataController dataController = Get.put(InstargramDataController());

  void changeBottomNav(int value, {bool hasGesture = true}){
    var page = PageName.values[value];
    dataController.getBasicData(Get.context!);
    switch(page){
      case PageName.upload:
        Get.to(()=> Upload());
        break;
      case PageName.home:
      case PageName.search:
      case PageName.active:
      case PageName.mypage:
        _changePage(value, hasGesture: hasGesture);
        break;
    }
  }

  void _changePage(int value, {bool hasGesture = true}){
    pageIndex(value);
    if(!hasGesture) return; //제스쳐가 없다면
    if(bottomHistory.contains(value)){ //이미 선택된 페이지라면
      bottomHistory.remove(value);
    }
    bottomHistory.add(value);
  }

  Future<bool> willPopAction() async {
    if(bottomHistory.length == 1){
      showDialog(
        context: Get.context!, 
        builder: (context)=> MessagePopup(
          title: '시스템', 
          message: '종료하시겠습니까?', 
          okCallback: () { exit(0); },
        )
      );
      return true;
    }else{
      var page = PageName.values[bottomHistory.last];
      if(page == PageName.search){
        var value = await searchPageNavigationKey.currentState!.maybePop();
        if(value) return false;
      }
      bottomHistory.removeLast();
      var index = bottomHistory.last;
      changeBottomNav(index, hasGesture: false);
      return false;
    }
  }
} 