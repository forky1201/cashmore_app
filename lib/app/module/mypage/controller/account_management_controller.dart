import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';

class AccountManagementController extends BaseController {
  AppService appService = Get.find<AppService>();
  MypageRepsitory mypageRepsitory = MypageRepsitory();

  // 로그아웃 다이얼로그
  void logout() {
    Get.dialog(
      _buildCustomDialog(
        title: "로그아웃",
        message: "정말 로그아웃 하시겠습니까?",
        onConfirm: () {
          appService.logout();
          Get.back();
        },
      ),
    );
  }

  // 계정 탈퇴 다이얼로그
  void withdraw() {
    Get.dialog(
      _buildCustomDialog(
        title: "탈퇴하기",
        message: "정말 계정을 탈퇴하시겠습니까?",
        onConfirm: () async {
          await delete();
          Get.snackbar("탈퇴하기", "성공적으로 탈퇴되었습니다.");
        },
      ),
    );
  }

  // 탈퇴 로직
  Future<void> delete() async {
    try {
      Map<String, dynamic> requestBody = {"user_id": appService.userId};

      await mypageRepsitory.userDelete(requestBody).then((result) {
        appService.logout();
      });
    } catch (e) {
      print('오류 발생: $e');
      Get.snackbar('오류', '탈퇴에 실패했습니다.');
    }
  }

  // 커스텀 다이얼로그 위젯
  Widget _buildCustomDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDialogButton(
                  label: "취소",
                  backgroundColor: Colors.grey[300]!,
                  textColor: Colors.black87,
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 10),
                _buildDialogButton(
                  label: "확인",
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: onConfirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 위젯
  Widget _buildDialogButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        //height: 50, // 버튼 높이 설정
        //width: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
