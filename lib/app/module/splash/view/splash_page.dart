import 'package:cashmore_app/app/module/splash/controller/splash_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sdPrimaryColor,  // 스플래시 화면의 배경색
      body: Center(
        child: FutureBuilder(
          future: controller.checkSessionAndNavigate(),  // 세션 확인 및 페이지 이동 비동기 작업
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 로딩 중일 때 스플래시 화면 표시
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),  // 로딩 인디케이터
                ],
              );
            } else {
              // 세션 확인 후 페이지 이동이 완료되면 빈 화면 유지
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(), // 로딩 인디케이터
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
