// lib/app/module/session/controller/session_controller.dart
import 'dart:async';

import 'package:cashmore_app/app/module/login/controller/login_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController extends BaseController {
  var isLoggedIn = false.obs; // 로그인 상태 변수
  final appService = Get.find<AppService>();
  final loginController = Get.put(LoginController());

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    //startTimer();
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      //movePage("D");
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  // 세션 값 확인 함수
  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false; // 세션 값 확인
  }

  void movePage(String type) {
    // 타이머 취소
    cancelTimer();

    if (type == "D") {
      Get.toNamed("/login");
    } else if (type == "N") {
    } else if (type == "K") {
      //kakao
      loginController.kakaoLogin();
    } else if (type == "G") {
    } else if (type == "I") {
      //ios
      loginController.appleLogin();
    }
  }

  @override
  void onClose() {
    // 컨트롤러가 파괴될 때 타이머 취소
    //cancelTimer();
    super.onClose();
  }
  

     
}

