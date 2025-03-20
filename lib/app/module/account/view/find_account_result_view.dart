import 'package:cashmore_app/app/module/account/controller/find_account_result_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Clipboard 사용을 위해 추가

class FindAccountResultPage extends GetView<FindAccountResultController> {
  const FindAccountResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "", // AppBar에서 타이틀을 비워 둠
        centerTitle: true,
        height: 85, // AppBar 높이 설정
        splitLayout: true, // 위아래 분리
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32), // 상단 여백

            // 아이디 찾기 결과 텍스트
            const Center(
              child: Text(
                "입력한 정보와 일치하는\n아이디를 찾았습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 찾은 아이디 정보 표시 및 복사 기능 추가
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: controller.foundEmail.value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('아이디가 클립보드에 복사되었습니다.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // 배경색 설정
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
                ),
                child: Obx(() => Text(
                      controller.foundEmail.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 32),

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                controller.moveToUrl("/login"); // 로그인 페이지로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50), // 버튼의 높이 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '로그인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // 비밀번호 재설정 버튼
            OutlinedButton(
              onPressed: () {
                controller.moveToUrl("/reset_password"); // 비밀번호 재설정 페이지로 이동
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // 버튼의 높이 설정
                side: const BorderSide(color: Colors.black), // 테두리 색상 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '비밀번호 재설정',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
