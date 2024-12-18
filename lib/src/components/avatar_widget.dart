import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';

enum AvatarType {type1, type2, type3, type4}

class AvatarWidget extends StatelessWidget{ 
  bool? hasStory;
  String thumbPath;
  String? nickname;
  AvatarType type;
  double? size;

  AvatarWidget({
    super.key,
    required this.type,
    required this.thumbPath,
    this.hasStory,
    this.nickname,
    this.size = 65,
    });

  Widget type1Widget(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.purple, Colors.orange]),
        shape: BoxShape.circle,
      ),
      child: type2Widget()
    );
  }


  Widget type2Widget(){
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size!),
          child: SizedBox(
            width: size,
            height: size,
            child: CachedNetworkImage(
              imageUrl: thumbPath,
              fit: BoxFit.cover,
            )
          )
        ),
      );
  }

  Widget type3Widget(){
    return Row(
      children: [
        type1Widget(),
        Text(
          nickname??'', 
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold),
        ),
      ],
    );
  }


  Widget type4Widget(){
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size!),
          child: SizedBox(
            width: size,
            height: size,

            child: (thumbPath == '' ? 
            ImageData(IconPath.defaultImage) 
            : 
            (
              thumbPath.startsWith('http') ?
                CachedNetworkImage(
                  imageUrl: thumbPath,
                  fit: BoxFit.cover,
                ) :
                Image.memory(
                  base64Decode(thumbPath),
                  fit: BoxFit.cover,
                )
              )
            ),
          )
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    switch(type){
      case AvatarType.type1:
        return type1Widget();
      case AvatarType.type2:
        return type2Widget();
      case AvatarType.type3:
        return type3Widget();
      case AvatarType.type4:
        return type4Widget();
    }
  }
}