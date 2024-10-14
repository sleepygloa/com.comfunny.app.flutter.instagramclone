import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MessagePopup extends StatelessWidget{
  final String? title;
  final String? message;
  final Function()? okCallback;
  final Function()? cancelCallback;


  const MessagePopup({
    super.key,
    required this.title,
    required this.message,
    required this.okCallback,
    this.cancelCallback,
    });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, //세로축에서 중앙정렬
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: 
              Container(
                color: Colors.white, 
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                width: Get.width * 0.7,
                child: Column(children: [
                  Text(title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),),
                  const SizedBox(height: 7,),
                  Text(message!, style: const TextStyle(fontSize: 14, color: Colors.black),),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: okCallback,child: const Text('확인'),),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: cancelCallback,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red ),
                        child: Text('취소'),
                        ),
                    ],
                  )
                ],
              )

            )
          )
        ],
      )
    );
  }
}