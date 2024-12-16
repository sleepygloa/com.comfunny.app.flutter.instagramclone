import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/component/SwipeAdjustmentUI.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadDetailAdjustmentAdjustment extends StatefulWidget {
  const UploadDetailAdjustmentAdjustment({super.key});

  @override
  State<UploadDetailAdjustmentAdjustment> createState() =>
      _UploadDetailAdjustmentAdjustmentState();
}

class _UploadDetailAdjustmentAdjustmentState
    extends State<UploadDetailAdjustmentAdjustment>
    with TickerProviderStateMixin {
  late TabController tabController;
  final controller = Get.find<UploadController>();
  List<double> currentValues = [0.0, 0.0, 0.0]; // 각 탭의 현재 값을 저장
  List<bool> showValues = [false, false, false]; // 각 탭의 텍스트 표시 여부
  var currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    currentTabIndex = 0;
    tabController = TabController(length: 3, vsync: this); // 탭 컨트롤러 초기화
    tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose(); // 탭 컨트롤러 해제
    super.dispose();
  }

  void handleValueChange(int tabIndex, double value) {
    setState(() {
      currentValues[tabIndex] = value; // 해당 탭의 값을 저장
      showValues[tabIndex] = value != 0.0; // 값 변경 시 텍스트 표시
    });

    // 기울기 값 업데이트
    controller.updateTiltValue(tabIndex, value);
    controller.filteredImages.refresh();
  }

  void _onTabChanged() {
    setState(() {
      currentTabIndex = tabController.index;
      for (int i = 0; i < showValues.length; i++) {
        if(currentTabIndex == i && (currentValues[currentTabIndex] != 0.0)) {
          showValues[i] = true; // 선택된 탭의 텍스트를 표시
        } else {
          showValues[i] = false; // 모든 탭의 텍스트를 숨김
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('조정'),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 2,
          tabs: [
            for (int i = 0; i < 3; i++) _buildTab(i),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SwipeAdjustmentUI(
            onValueChange: (value) => handleValueChange(0, value), // 탭 1 콜백
          ),
          SwipeAdjustmentUI(
            onValueChange: (value) => handleValueChange(1, value), // 탭 2 콜백
          ),
          SwipeAdjustmentUI(
            onValueChange: (value) => handleValueChange(2, value), // 탭 3 콜백
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int tabIndex) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          );
        },
        child: showValues[tabIndex]
            ? Container(
                key: ValueKey('visibleTabWithText_$tabIndex'),
                // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // 배경색
                  borderRadius: BorderRadius.circular(16), // 라운딩
                  border: Border.all(
                    color: Colors.grey.shade400, // 테두리 색
                    width: 1.0, // 테두리 두께
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tab(
                      icon: ImageData(IconPath.imgAdjustmentOneWhite),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentValues[tabIndex].toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentValues[tabIndex] = 0.0; // 값 초기화
                          showValues[tabIndex] = false; // 텍스트 숨김
                        });
                      },
                      child: ImageData(IconPath.closeImage),
                    )
                  ],
                ),
              )
            : 
            Container(
                key: ValueKey('visibleTabWithText_$tabIndex'),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tab(
                      icon: ImageData(IconPath.imgAdjustmentOneWhite),
                    ),
                    if(!(-0.01 < currentValues[tabIndex] && currentValues[tabIndex] < 0.01))
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            currentValues[tabIndex].toStringAsFixed(2),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              )
      ),
    );
  }
}
