import 'package:flutter/material.dart';

class SwipeAdjustmentUI extends StatefulWidget {
  final void Function(double value) onValueChange; // 값 변경 콜백 추가

  const SwipeAdjustmentUI({super.key, required this.onValueChange});

  @override
  State<SwipeAdjustmentUI> createState() => _SwipeAdjustmentUIState();
}

class _SwipeAdjustmentUIState extends State<SwipeAdjustmentUI> {
  double _value = 0.0; // 조정 값
  double _startValue = 0.0; // 드래그 시작 시 값 저장
  double _offsetMultiplier = 5.0; // 드래그 민감도

  // Min/Max 값을 변수로 설정
  double _minValue = -25.0; // 최소값
  double _maxValue = 25.0; // 최대값

  // 색상 변수
  Color _backgroundColor = Colors.white54; // 배경 색상
  Color _swipeBarColor = Colors.white54; // 스와이프 영역 색상
  Color _contentColor = Colors.grey.shade900; // 라인 색상

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // 배경 색상 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // // 조정된 값 표시
            // Text(
            //   'Value: ${_value.toStringAsFixed(2)}', // 현재 _value 값을 표시
            //   style: TextStyle(color: _contentColor, fontSize: 20),
            // ),
            // const SizedBox(height: 20),
            // 스와이프 조정 영역
            GestureDetector(
              onHorizontalDragStart: (details) {
                _startValue = _value; // 드래그 시작 시 현재 값을 저장
              },
              onHorizontalDragUpdate: (details) {
                setState(() {
                  // 드래그에 따라 _value를 업데이트
                  _value = (_startValue + details.primaryDelta! / _offsetMultiplier)
                      .clamp(_minValue, _maxValue);
                  _startValue = _value; // 드래그 시작 시 현재 값을 저장
                  widget.onValueChange(_value); // 부모에게 값 전달
                });
              },
              child: Column(
                children: [
                  // 중앙 고정된 점
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.black, // 검은색 고정 점
                      shape: BoxShape.circle,
                    ),
                  ),
                  Stack(
                    children: [
                      // 라인 배경 (라인이 움직이도록 구성)
                      Container(
                        width: MediaQuery.of(context).size.width, // 화면 너비
                        height: 60, // 고정 높이
                        decoration: BoxDecoration(
                          color: _swipeBarColor, // 스와이프 영역 배경 색상
                          borderRadius: BorderRadius.circular(30), // 둥근 모서리
                        ),
                        child: CustomPaint(
                          painter: _SwipePainter(
                            value: _value,
                            offsetMultiplier: _offsetMultiplier,
                            contentColor: _contentColor, // 라인의 색상
                          ),
                        ),
                      ),
                      // 투명도 효과
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _backgroundColor.withOpacity(1.0), // 외곽이 불투명
                              _backgroundColor.withOpacity(0.1), // 정중앙이 투명
                              _backgroundColor.withOpacity(1.0), // 외곽이 불투명
                            ],
                            stops: const [0.0, 0.5, 1.0], // 위치별 색상 변화
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
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
      ),
    );
  }
}

class _SwipePainter extends CustomPainter {
  final double value; // 현재 조정 값
  final double offsetMultiplier; // 드래그 민감도
  final Color contentColor; // 라인 색상

  _SwipePainter({
    required this.value,
    required this.offsetMultiplier,
    required this.contentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = contentColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final totalBars = 50; // 라인의 총 개수
    final barSpacing = size.width / (totalBars / 2); // 라인 간 간격

    // 반복되는 라인 패턴을 그리는 로직
    for (int i = -totalBars; i <= totalBars; i++) {
      double barHeight = size.height / 2; // 라인의 높이
      double barX = (i * barSpacing) + (value * offsetMultiplier) % barSpacing;
      canvas.drawLine(
        Offset(barX, size.height / 2 - barHeight / 2),
        Offset(barX, size.height / 2 + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 항상 다시 그리도록 설정
  }
}
