import 'package:cashmore_app/app/module/account/controller/signup_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/util/dialog_utils.dart';
import 'package:cashmore_app/util/phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // TextInputFormatter 사용을 위해 추가

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "회원가입",
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // 이메일, 비밀번호, 비밀번호 확인 필드
            Obx(() {
              if (controller.snstype.value == "1") {
                return Column(
                  children: [
                    _buildInputField("이메일 *", "이메일을 입력해주세요.", controller.emailController),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildInputField("비밀번호 확인 *", "비밀번호를 한 번 더 입력해주세요.", controller.confirmPasswordController, isPassword: true),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return const SizedBox.shrink(); // snstype이 "1"이 아니면 빈 공간 반환
            }),

            // 본인인증 버튼
            Obx(() {
              if (controller.snstype.value != "kakao") {
                return ElevatedButton(
                  onPressed: controller.isVerified.value ? null : controller.identityVerification, // isVerified가 false일 때만 실행
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isVerified.value ? Colors.grey : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    controller.isVerified.value ? '본인인증 완료' : '본인인증',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              }else{
                return SizedBox.shrink();
              }
              
            }),

            const SizedBox(height: 32),

            // 추천인 코드 필드
            _buildInputField("추천인 코드", "추천한 유저의 코드를 입력해주세요.", controller.referralNicknameController),
            const SizedBox(height: 32),

            // 약관 동의 섹션
            Obx(() => _buildAgreementSection()),
            const SizedBox(height: 32),

            // 회원가입 버튼
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isFormValid.value ? controller.signup : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: sdPrimaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // 이메일, 비밀번호, 추천인 코드 등 입력 필드 위젯
  Widget _buildInputField(String label, String hint, TextEditingController controller, {bool isPassword = false, List<TextInputFormatter>? inputFormatters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          inputFormatters: inputFormatters, // TextInputFormatter 추가
          keyboardType: inputFormatters != null ? TextInputType.phone : null, // 전화번호 입력일 경우 키보드 타입 설정
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }

  // 비밀번호 필드 (검증 에러 메시지 포함)
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("비밀번호 *", "비밀번호를 입력해주세요.", controller.passwordController, isPassword: true),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.passwordErrorMessage.value.isNotEmpty) {
            return Text(
              controller.passwordErrorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // 약관 동의 섹션
  Widget _buildAgreementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text('전체 동의'),
          value: controller.isAllAgreed.value,
          onChanged: (bool? value) {
            controller.setAllAgreements(value ?? false);
          },
        ),
        _buildAgreementItem('이용약관 (필수)', controller.isTermsAgreed, url: 'https://getitmoney.co.kr/api/terms_of_use'),
        _buildAgreementItem('개인정보처리방침 (필수)', controller.isPrivacyAgreed, url: 'https://getitmoney.co.kr/api/privacy_policy'),
        _buildAgreementItem('마케팅정보 수신동의', controller.isMarketingAgreed, url: ''),
        _buildAgreementItem('서비스 알림 수신동의', controller.isServiceNoticeAgreed, url: ''),
      ],
    );
  }

  // 개별 약관 항목 체크박스
  Widget _buildAgreementItem(String label, RxBool isChecked, {required String url}) {
    return Obx(() => CheckboxListTile(
          title: InkWell(
            onTap: () {
              url == '' ? null : DialogUtils.showWebViewDialog(title: label, url: url);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
          value: isChecked.value,
          onChanged: (bool? value) {
            isChecked.value = value ?? false;
            controller.checkAllAgreements();
            if (controller.snstype.value == "1") {
              controller.validateForm();
            } else if (controller.snstype.value == "kakao") {
              controller.validateFormKakao();
            }  else {
              controller.validateFormSns();
            }
          },
        ));
  }
}
