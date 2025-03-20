import 'package:cashmore_app/app/module/mypage/controller/myInfo_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInfoView extends GetView<MyInfoController> {
  const MyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "내 정보 관리",
        centerTitle: true,
        height: 85,
        splitLayout: true,
      ),
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면이 자동으로 조정되도록 설정
      body: Container(
        color: Colors.white,
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //const SizedBox(height: 20),
                  // 사용자 정보
                  Obx(() => Column(
                        children: [
                          Text(
                            controller.userName.value, // 컨트롤러에서 가져온 사용자 이름
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.userId.value, // 컨트롤러에서 가져온 사용자 ID
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.phoneNumber.value.toString(), // 컨트롤러에서 가져온 전화번호
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),
                  // 연락처 변경 / 비밀번호 수정 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showPhoneEditDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            '연락처 수정',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      */
                      AppService.to.snsType != 'kakao' ?
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showChangePasswordDialog(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            '비밀번호 수정',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ): Container()
                      ,
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 체크박스 리스트
                  Column(
                    children: [
                      Obx(() => CheckboxListTile(
                            value: controller.marketingConsent.value,
                            onChanged: (bool? value) {
                              controller.marketingConsent.value = value ?? false;
                            },
                            title: const Text('마케팅 정보 수신동의'),
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: Colors.white,
                            activeColor: Colors.black,
                          )),
                      Obx(() => CheckboxListTile(
                            value: controller.serviceAlertConsent.value,
                            onChanged: (bool? value) {
                              controller.serviceAlertConsent.value = value ?? false;
                            },
                            title: const Text('서비스알림 수신 동의'),
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: Colors.white,
                            activeColor: Colors.black,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 수정하기 버튼을 하단에 배치
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.updateInfo, // 수정하기 버튼 클릭 시
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      )
    );
  }

  // 연락처 수정 다이얼로그를 띄우는 함수
  void _showPhoneEditDialog(BuildContext context) {
    final TextEditingController phoneController =
        TextEditingController(text: controller.phoneNumber.value.toString());
    final String originalPhoneNumber = controller.phoneNumber.value.toString(); // 기존 연락처 저장

    Get.dialog(
      AlertDialog(
        title: const Text('연락처 수정'),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: '새 연락처 입력'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              String newPhoneNumber = phoneController.text;
              if (newPhoneNumber != originalPhoneNumber) {
                controller.phoneNumber.value = newPhoneNumber; // 연락처 업데이트
              }
              controller.changeContact(); // 연락처 변경 함수 호출
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  // 비밀번호 수정 다이얼로그를 띄우는 함수
  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor:Colors.white,
        title: const Text('비밀번호 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '현재 비밀번호'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '새 비밀번호'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '새 비밀번호 확인'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                controller.changePassword(
                  oldPasswordController.text,
                  newPasswordController.text,
                );
              } else {
                Get.snackbar('오류', '새 비밀번호가 일치하지 않습니다.');
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
