import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  // 기본 데이터 변수
  var basicData = ''.obs;

  // API 데이터 변수
  var apiData = {}.obs;

  // 로그인 상태 변수
  var isLoggedIn = false.obs;

  // Post, Followers, Following 값 변수
  var postCount = 0.obs;
  var followersCount = 0.obs;
  var followingCount = 0.obs;

  // 사용자 프로필 이미지 경로 변수
  var thumbPath = ''.obs;

  // 사용자의 설명
  var description = ''.obs;

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
    clearUserData();
  }

  // Post, Followers, Following 값 업데이트 메서드
  void updateCounts(int post, int followers, int following) {
    postCount.value = post;
    followersCount.value = followers;
    followingCount.value = following;
  }

  // 사용자 프로필 이미지 경로 업데이트 메서드
  void updateThumbPath(String path) {
    thumbPath.value = path;
  }

  // API 데이터 가져오기 메서드 (예시)
  Future<void> fetchDataFromApi() async {
    // API 호출 시뮬레이션
    await Future.delayed(Duration(seconds: 2));

    // 예시 API 응답
    Map<String, dynamic> response = {
      'id': 1,
      'name': 'Example Data',
      'description': 'This is an example description'
    };

    // 가져온 데이터로 apiData 업데이트
    updateApiData(response);
  }

  // 사용자 데이터 업데이트 메서드
  void updateUserData(Map<String, dynamic> userData) {
    print('updateUserData');
    print(userData);
    if(userData.isEmpty) return;
    updateCounts(
      userData['postCount'],
      userData['followersCount'],
      userData['followingCount'],
    );
    updateThumbPath(userData['thumbPath']);
    description.value = userData['description'];
  }

  // 사용자 데이터 초기화 메서드
  void clearUserData() {
    updateCounts(0, 0, 0);
    updateThumbPath('');
    description.value = '';
  }
}