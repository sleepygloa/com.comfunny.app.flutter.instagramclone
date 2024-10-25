import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InstargramDataController extends GetxController {
  // 기본 데이터 변수
  var basicData = ''.obs;

  // API 데이터 변수
  var apiData = {}.obs;

  // 로그인 상태 변수
  var isLoggedIn = false.obs;


  // 기본 데이터 업데이트 메서드
  void updateBasicData(String newData) {
    basicData.value = newData;
  }

  // API 데이터 업데이트 메서드
  void updateApiData(Map<String, dynamic> newData) {
    apiData.value = newData;
  }

  // 로그인 상태 업데이트 메서드
  void updateLoginStatus(bool status) {
    isLoggedIn.value = status;
  }

  // 로그인 상태 확인 메서드
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('isLoggedIn') ?? false;
    updateLoginStatus(status);
    return status;
  }

  // 로그인 메서드
  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    updateLoginStatus(true);
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    updateLoginStatus(false);
  }

  // 로그인시 앱 콤보 선택 데이터 가져오기 _selectedRole
  Future<String> getSelectedRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString('_selectedRole') ?? '인스타그램';
    return status;
  }
}