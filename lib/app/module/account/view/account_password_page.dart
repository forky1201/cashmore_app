import 'package:cashmore_app/app/module/account/controller/account_password_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPasswordPage extends GetView<AccountPasswordController> {
  const AccountPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "",  // AppBar에서 타이틀을 비워 둠
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  // 키보드가 올라왔을 때 스크롤 가능하도록 설정
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),  // 상단 여백
            // 페이지 타이틀 텍스트
            const Center(
              child: Text(
                "새로운 비밀번호 입력",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 새 비밀번호 입력 필드
            const Text(
              "새 비밀번호 *",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.newPasswordController,
              obscureText: true,  // 비밀번호 가리기
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력해주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            const SizedBox(height: 24),
            // 비밀번호 확인 입력 필드
            const Text(
              "비밀번호 확인 *",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.confirmPasswordController,
              obscureText: true,  // 비밀번호 가리기
              decoration: const InputDecoration(
                hintText: '비밀번호를 한 번 더 입력해주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            const SizedBox(height: 32),
            // 비밀번호 변경 버튼
            ElevatedButton(
              onPressed: controller.updatePassword,  // 비밀번호 변경 함수 호출
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),  // 버튼의 높이 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '변경하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
