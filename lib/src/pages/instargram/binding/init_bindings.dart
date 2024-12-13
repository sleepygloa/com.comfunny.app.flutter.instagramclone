import 'package:flutter_clone_instagram/src/pages/instargram/controller/bottom_nav_controller.dart';
import 'package:get/get.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController(), permanent: true);
    // Get.put(AuthController(), permanent: true);
  }
  
  static additionalBindings() {
    
  }
}