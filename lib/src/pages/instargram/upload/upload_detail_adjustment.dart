import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/upload/modal/upload_detail_adjustment_adjustment.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadDetailAdjustment extends StatefulWidget {
  final AssetEntity image;
  final void Function(double brightness, double contrast) onAdjust;

  const UploadDetailAdjustment({
    Key? key,
    required this.image,
    required this.onAdjust,
  }) : super(key: key);

  @override
  State<UploadDetailAdjustment> createState() => _UploadDetailAdjustmentState();

}

class _UploadDetailAdjustmentState extends State<UploadDetailAdjustment> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3, // 필터 UI의 높이 비율 설정
      child: Column(
        children: [
          const SizedBox(height: 60), // 상단 여백
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterButton("조정", Icon(Icons.adjust_sharp), () {
                  print('조정 버튼 클릭');
                  showModalDetail(UploadDetailAdjustmentAdjustment());
                }),
                _buildFilterButton("조도", Icon(Icons.auto_fix_high)), // 조도
                _buildFilterButton("밝기", Icon(Icons.light_mode)), 
                _buildFilterButton("대비", Icon(Icons.contrast)), // 대비
                _buildFilterButton("구조", Icon(Icons.contrast)),
                _buildFilterButton("온도", Icon(Icons.thermostat)), // 온도 
                _buildFilterButton("채도", Icon(Icons.water_drop)), // 채도
                _buildFilterButton("색", Icon(Icons.color_lens)), // 색
                _buildFilterButton("흐리게", Icon(Icons.cloud)), // 흐리게
                _buildFilterButton("하이라이트", Icon(Icons.tonality)), // 하이라이트
                _buildFilterButton("그림자", Icon(Icons.brightness_6)), 
                _buildFilterButton("배경흐리게", Icon(Icons.mode_standby)), // 배경흐리게
                _buildFilterButton("미니어쳐 효과", Icon(Icons.filter_tilt_shift_rounded)), // 미니어쳐 효과
                _buildFilterButton("선명하게", Icon(Icons.filter_tilt_shift_rounded)), 
              ],
            ),
          ),
          // 버튼: 취소, 필터, 완료
          SizedBox(
            height: 80,
            child: Column(
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    const Text('조정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // print('조정 적용 완료: ${_selectedFilter.value}');
                        Navigator.pop(context);
                      },
                      child: const Text('완료', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  // 버튼
  GestureDetector _buildFilterButton(
    String title,
    Widget icon, 
    [VoidCallback? onPressed]
  ) {
    return GestureDetector(
      onTap: onPressed ?? () {
        print('버튼 클릭: $title');
      },
      child: SizedBox(
        width: 100,
        height: 180,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            icon,
          ],
        ),
      ),
    );
  }


  // 조정 상세 모달
  Future showModalDetail (Widget widget){
    return  showModalBottomSheet(
            barrierColor: Colors.transparent, // 배경을 투명하게 설정
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            builder: (context) => SizedBox(
              height: 300,
              child: widget,
            )
          );
  }
}