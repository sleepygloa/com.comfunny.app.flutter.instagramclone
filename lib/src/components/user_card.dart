import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';

class UserCard extends StatelessWidget{
  final String userId;
  final String description;
  final String thumbPath;
  const UserCard({super.key, required this.userId, required this.description, required this.thumbPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 150,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black12),
      ),
      child: Stack(
        children:[
          Positioned(
            left: 15,
            right: 15,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(height: 10),
                AvatarWidget(
                  type: AvatarType.type1,
                  thumbPath: thumbPath,
                  size: 80
                ),
                const SizedBox(height: 10),
                Text(
                  userId,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: (){}, 
                  child: const Text('팔로우'),
                )
              ]
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: (){},
              child: const Icon(
                Icons.close, 
                size: 14,
                color: Colors.grey,
              ),
            )
          ),
        ],
      ),
    );
  }

}