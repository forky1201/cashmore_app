// lib/app/module/point/controller/point_withdrawal_controller.dart
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cashmore_app/app/module/common/controller/auth_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/point_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointWithdrawalController extends BaseController {
  final appService = Get.find<AppService>();

  PointRepsitory pointRepsitory = PointRepsitory();

  // 통장 인증 상태 (초기값: false)
  var accountVerified = false.obs;

  // 출금 가능 상태
  var withdrawVerifed = false.obs;

  // 출금 금액 리스트
  var withdrawAmount = '11000'.obs;

  // 출금 가능한 포인트
  var availablePoints = 1000.obs;

  var totalPoint = 0.obs;

  // 보유 포인트 텍스트
  String get formattedAvailablePoints => '${totalPoint.value}P';

  @override
  void onInit() {
    super.onInit();
    userInfo();
  }

  // 통장 인증 토글 (예제용)
  Future<void> verifyAccount() async {
    final authController = Get.find<AuthController>();
    try {
      final result = await authController.startAccount();

      if (result == null) {
        accountVerified.value = false;
        //Get.snackbar("계좌인증", "계좌인증에 실패했습니다.");
        return;
      }

      if (result['status'] == 'success') {
        accountVerified.value = true;
        Get.snackbar("계좌인증", "계좌인증이 완료되었습니다.");
      } else {
        accountVerified.value = false;
        Get.snackbar("계좌인증", "계좌인증에 실패했습니다.");
      }
    } catch (e) {
      accountVerified.value = false;
      Get.snackbar("계좌인증", "계좌인증 데이터 처리 중 문제가 발생했습니다.");
      logger.e("계좌인증 에러: $e");
    } finally {
      //await userInfo(); // 최종적으로 유저 정보를 갱신
    }
  }

  // 출금 금액 선택
  void selectWithdrawAmount(String value) {
    withdrawAmount.value = value;
  }

  // 출금하기 (예제용)
  Future<void> requestWithdrawal() async {
    var user = await AppService().getUser();

    Map<String, dynamic> requestBody = {"user_id": user.user_id, "point": withdrawAmount.value};

    if (withdrawVerifed.value) {
      //total point 11000 이상인지 체크 후 api 태우기
      if (totalPoint.value < 11000) {
        Get.snackbar('출금 실패', '포인트가 11000 이상이어야 합니다.');
        return;
      }

      bool? confirmed = await showDialog<bool>(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('확인'),
            content: Text('출금 요청을 하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // 취소
                },
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // 확인
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );

      // 확인을 누른 경우에만 동작 수행
      if (confirmed == true) {
        pointRepsitory.pointwitDrawal(requestBody).then((response) async {
          Get.snackbar('출금 신청 완료', '출금이 성공적으로 신청되었습니다.');
          //await userInfo();
          Get.back(closeOverlays: true, result: true);
        });
      }
    } else {
      Get.snackbar('출금 실패', '통장 인증이 필요합니다.');
    }
  }

  Future<void> userInfo() async {
    
    await AppService.to.loginInfoRefresh();
    UserModel user = await AppService().getUser();
    totalPoint.value = user.total_point!;
    var point = totalPoint.value - 11000;
print("user.bank_number======>> " + user.bank_number.toString());
    if (user.bank_number == '') {
      accountVerified.value = false;
      withdrawVerifed.value = false;
    } else {
        accountVerified.value = true;
      if (point < 0) {
        availablePoints.value = 0;
        withdrawVerifed.value = false;
        //accountVerified.value = false;
      } else {
        availablePoints.value = totalPoint.value;
        withdrawVerifed.value = true;
        //accountVerified.value = true;
      }
    }
  }
}
