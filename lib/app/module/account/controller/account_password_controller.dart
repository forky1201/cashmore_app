import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AccountPasswordController extends BaseController {
  final AuthRepository authRepository = AuthRepository();
  // 비밀번호와 비밀번호 확인 입력 필드의 컨트롤러
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var userDi = "".obs;

  @override
  void onInit() {
    super.onInit();
    // arguments로 전달된 값을 foundEmail에 할당
    if (Get.arguments != null) {
      var di = Get.arguments; // 전달된 값으로 초기화
      userDi.value = di;
    }
  }

  // 비밀번호 업데이트 메서드
  Future<void> updatePassword() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("오류", "비밀번호를 입력해주세요.");
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("오류", "비밀번호가 일치하지 않습니다.");
      return;
    }

    Map<String, dynamic> requestBody = {
      "user_di": userDi.value,
      "user_pw": newPassword,
    };

    final response = await authRepository.updateUserInfo(requestBody);

    // 비밀번호 변경 로직 (예: API 호출)
    // 성공 시:
    Get.snackbar("성공", "비밀번호가 성공적으로 변경되었습니다.");
    Get.offAllNamed("/login"); // 변경 후 로그인 페이지로 이동
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
