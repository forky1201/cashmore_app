import 'package:cashmore_app/app/module/account/controller/find_account_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindAccountPage extends GetView<FindAccountController> {
  const FindAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "", // AppBar에서 타이틀을 비워 둠
        centerTitle: true,
        height: 35,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32), // 상단 여백
            // 아이디 및 비밀번호 찾기 제목 텍스트
            const Center(
              child: Text(
                "아이디 • 비밀번호 찾기",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // 설명 텍스트
            const Center(
              child: Text(
                "아이디 • 비밀번호를 찾기 위해\n본인인증을 먼저 진행해 주세요.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // 본인 인증 버튼
            ElevatedButton(
              onPressed: () {
                // 본인 인증 클릭 시 로직 추가
                controller.identityVerification();
                //controller.verifyIdentity();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50), // 버튼의 높이 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '본인 인증하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
