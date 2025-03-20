import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashmore_app/app/module/home/controller/home_controller.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아올 때 실행
      print('🔄 앱이 포그라운드로 돌아옴: ${DateTime.now()}');

      // HomeController 인스턴스 가져오기
      HomeController homeController = Get.find<HomeController>();
      //homeController.startBackgroundStepCounter();
      
    }
  }
}
