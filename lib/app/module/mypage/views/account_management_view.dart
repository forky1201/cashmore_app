import 'package:cashmore_app/app/module/mypage/controller/account_management_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountManagementView extends GetView<AccountManagementController> {
  const AccountManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "계정관리",
        centerTitle: true,
        splitLayout: true,
        height: 85,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 로그아웃 버튼
            SizedBox(
              height: Get.height * 0.08, // 높이를 디바이스 높이에 맞춰 조정
              child: ElevatedButton(
                onPressed: () {
                  controller.logout(); // 컨트롤러의 로그아웃 함수 호출
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 배경색을 검정으로
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "로그아웃",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // 텍스트 색상 흰색
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // 버튼 사이의 간격
            // 탈퇴하기 버튼
            SizedBox(
              height: Get.height * 0.08, // 높이를 디바이스 높이에 맞춰 조정
              child: ElevatedButton(
                onPressed: () {
                  controller.withdraw(); // 컨트롤러의 탈퇴 함수 호출
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // 버튼 배경색을 회색으로
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "탈퇴하기",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // 텍스트 색상 흰색
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
