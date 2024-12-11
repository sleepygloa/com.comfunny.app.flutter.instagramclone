import 'package:flutter_clone_instagram/src/pages/instargram/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/upload_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController(), permanent: true);
    // Get.put(AuthController(), permanent: true);
  }
  
  static additionalBindings() {
    
  }
}