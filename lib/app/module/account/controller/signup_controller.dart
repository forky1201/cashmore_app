import 'dart:convert';
import 'dart:io';
import 'package:cashmore_app/app/module/common/controller/auth_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends BaseController {
  final appService = Get.find<AppService>();
  final AuthRepository authRepository = AuthRepository();

  // 입력 필드 컨트롤러
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var nicknameController = TextEditingController();
  var referralNicknameController = TextEditingController();

  // 인증 후 받은 데이터
  var phoneController = TextEditingController();
  var diController = TextEditingController();
  var birthdateController = TextEditingController();
  var genderController = TextEditingController();

  // 약관 동의 관련 상태값
  var isAllAgreed = false.obs; // 전체 동의 여부
  var isTermsAgreed = false.obs; // 이용약관 동의 여부
  var isPrivacyAgreed = false.obs; // 개인정보처리방침 동의 여부
  var isMarketingAgreed = false.obs; // 마케팅 정보 수신 동의 여부
  var isServiceNoticeAgreed = false.obs; // 서비스 알림 수신 동의 여부

  // 폼 유효성 검사를 위한 상태값
  var isFormValid = false.obs;
  var isVerified = false.obs; // 본인인증 성공 여부

  // SNS 정보
  var snstype = "1".obs;
  var snskey = "".obs;

  // Validation 메시지 상태
  var passwordErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 전달받은 arguments 처리
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final arguments = Get.arguments as Map<String, dynamic>;
      emailController.text = arguments['email'] ?? '';
      snstype.value = arguments['snstype'] ?? '1'; // 기본값 설정
      snskey.value = arguments['snskey'] ?? '';
      nicknameController.text = arguments['name'] ?? '';

      if (snstype.value == 'kakao') {
        phoneController.text = arguments['phoneNumber'] ?? '';
        diController.text = arguments['di'] ?? '';
        birthdateController.text = arguments['birth'] ?? '';
        genderController.text = arguments['gender'] ?? '';
      }
    }

    // 입력 필드 상태가 변경될 때마다 유효성 검사 실행
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  // 전체 동의 상태 변경
  void setAllAgreements(bool value) {
    isAllAgreed.value = value;
    isTermsAgreed.value = value;
    isPrivacyAgreed.value = value;
    isMarketingAgreed.value = value;
    isServiceNoticeAgreed.value = value;

    if (snstype.value == "1") {
      validateForm();
    } else if (snstype.value == "kakao") {
      validateFormKakao();
    } else {
      validateFormSns();
    }
  }

  // 개별 항목 체크 후 전체 동의 상태 확인
  void checkAllAgreements() {
    isAllAgreed.value = isTermsAgreed.value && isPrivacyAgreed.value && isMarketingAgreed.value && isServiceNoticeAgreed.value;

    if (snstype.value == "1") {
      validateForm();
    } else if (snstype.value == "kakao") {
      validateFormKakao();
    } else {
      validateFormSns();
    }
  }

  // 폼 유효성 검사 (일반 회원가입)
  void validateForm() {
    passwordErrorMessage.value = validatePassword(passwordController.text.trim());
    isFormValid.value = emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim() == passwordController.text.trim() &&
        passwordErrorMessage.value.isEmpty && // 비밀번호 유효성 확인
        isTermsAgreed.value &&
        isPrivacyAgreed.value &&
        isVerified.value; // 본인인증 성공 여부 추가
  }

  // 폼 유효성 검사 (SNS 회원가입)
  void validateFormSns() {
    isFormValid.value = isTermsAgreed.value && isPrivacyAgreed.value && isVerified.value; // 본인인증 성공 여부 추가
  }

  // 폼 유효성 검사 (SNS 회원가입) 본인인증 제거
  void validateFormKakao() {
    isFormValid.value = isTermsAgreed.value && isPrivacyAgreed.value;
  }

  // 비밀번호 Validation
  String validatePassword2(String password) {
    if (password.length < 8) {
      return "비밀번호는 최소 8자리여야 합니다.";
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$').hasMatch(password)) {
      return "비밀번호는 영문, 숫자, 특수문자를 포함해야 합니다.";
    }
    return ""; // 유효성 검사를 통과하면 빈 문자열 반환
  }

  // 비밀번호 Validation
  String validatePassword(String password) {
    if (password.length < 8) {
      return "비밀번호는 최소 8자리여야 합니다.";
    }

    bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(password); // 영문 포함 여부
    bool hasDigit = RegExp(r'\d').hasMatch(password); // 숫자 포함 여부
    bool hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password); // 특수문자 포함 여부

    // 최소 2가지 종류 이상 포함 여부 확인
    int count = (hasLetter ? 1 : 0) + (hasDigit ? 1 : 0) + (hasSpecial ? 1 : 0);
    if (count < 2) {
      return "비밀번호는 영문, 숫자, 특수문자 중 최소 2가지를 포함해야 합니다.";
    }

    return ""; // 유효성 검사를 통과하면 빈 문자열 반환
  }

  // 회원가입 로직
  Future<void> signup() async {
    if (snstype.value == "1") {
      validateForm();
      if (!isFormValid.value) {
        Get.snackbar("오류", "모든 필드를 올바르게 입력해주세요.");
        return;
      }
    } else if (snstype.value == "kakao") {
      validateFormKakao();
      if (!isFormValid.value) {
        Get.snackbar("오류", "모든 필드를 올바르게 입력해주세요.");
        return;
      }
    } else {
      validateFormSns();
      if (!isFormValid.value) {
        Get.snackbar("오류", "모든 필드를 올바르게 입력해주세요.");
        return;
      }
    }

    try {
      Map<String, dynamic> requestBody = {
        "user_id": emailController.text.trim(),
        "user_pw": confirmPasswordController.text.trim(),
        "user_name": nicknameController.text.trim(),
        "user_hp": phoneController.text.trim(),
        "user_gender": genderController.text.trim(),
        "user_birthdate": birthdateController.text.trim(),
        "user_di": diController.text.trim(),
        "recommender": referralNicknameController.text.trim(),
        "marketing": isMarketingAgreed.value ? 0 : 1,
        "service_alert": isServiceNoticeAgreed.value ? 0 : 1,
        "snskey": snskey.value,
        "snstype": snstype.value,
        "email": emailController.text.trim(),
        "user_device_type": Platform.isAndroid ? "ANDROID" : "IOS"
      };

      print("requestBody===> " + requestBody.toString());

      await authRepository.join(requestBody).then((response) async {
        if (response.status == false) {
          Get.snackbar("오류", response.message.toString());
          return;
        }
        await authRepository.login(requestBody).then((response1) {
          logger.i(["[token] ${response1.token}", "[userId] ${emailController.text.trim()}"]);
          appService.saveTokenAndGoMain(response1, emailController.text.trim());
        });
      });
    } catch (e) {
      Get.snackbar("오류", "회원가입 중 문제가 발생했습니다. 다시 시도해주세요.\n$e");
    }
  }

  // 본인인증 로직
  Future<void> identityVerification() async {
    final authController = Get.find<AuthController>();

    try {
      final result = await authController.startAuth();

      if (result == null) {
        isVerified.value = false;
        Get.snackbar("본인인증", "본인인증에 실패했습니다. 다시 시도해주세요.");
        return;
      }

      if (result['status'] == 'success') {
        isVerified.value = true;

        phoneController.text = result["data"]["mobileno"];
        diController.text = result["data"]["di"];
        birthdateController.text = result["data"]["birthdate"];
        genderController.text = result["data"]["gender"];
        nicknameController.text = result["data"]["name"];

        Get.snackbar("본인인증", "본인인증이 완료되었습니다.");
        validateForm();
      } else {
        isVerified.value = false;
        Get.snackbar("본인인증", "본인인증에 실패했습니다.");
      }
    } catch (e) {
      isVerified.value = false;
      Get.snackbar("본인인증", "본인인증 중 문제가 발생했습니다.\n$e");
      logger.e("본인인증 에러: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nicknameController.dispose();
    phoneController.dispose();
    referralNicknameController.dispose();
    diController.dispose();
    birthdateController.dispose();
    genderController.dispose();
    super.onClose();
  }
}
