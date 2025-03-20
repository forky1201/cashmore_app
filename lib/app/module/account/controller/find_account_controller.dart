import 'dart:convert';

import 'package:cashmore_app/app/module/common/controller/auth_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:get/get.dart';

class FindAccountController extends BaseController {
  var isVerified = false.obs; // 본인인증 성공 여부


  Future<void> identityVerification() async {
    final authController = Get.find<AuthController>();
    // 본인인증 실행
    try {
      // 본인인증 실행
      final result = await authController.startAuth();

      if (result == null) {
        // result가 null인 경우 처리
        isVerified.value = false;
        Get.snackbar("본인인증", "본인인증에 실패했습니다. 다시 시도해주세요.");
        return;
      }

      if (result['status'] == 'success') {
          //Get.snackbar("본인인증", "본인인증이 완료되었습니다.");
          // 인증 후 페이지 이동
          print("di==========>>>> "+ result["data"]["di"].toString());
          Get.toNamed("/find_account_result", arguments: result["data"]["di"]);
        } else {
          isVerified.value = false;
          Get.snackbar("본인인증", "본인인증에 실패했습니다.");
        }
    } catch (e) {
      // 예외 처리
      isVerified.value = false;
      Get.snackbar("본인인증", "본인인증 중 문제가 발생했습니다. 오류: $e");
      logger.e("본인인증 에러: $e");
    }
  }

  
}
