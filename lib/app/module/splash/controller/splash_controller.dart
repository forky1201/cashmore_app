import 'dart:io';

import 'package:cashmore_app/app/module/intro/controller/session_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/app_info_model.dart';
import 'package:cashmore_app/common/view/dialog_box.dart';
import 'package:cashmore_app/repository/app_info_repository.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashController extends BaseController {
  late SessionController sessionController;
  bool isNavigating = false; // 중복 네비게이션 방지 플래그

  @override
  void onInit() {
    super.onInit();
    sessionController = Get.find<SessionController>(); // 세션 컨트롤러 연결
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 세션 확인 후 페이지 이동 로직
  Future<void> checkSessionAndNavigate() async {
    if (isNavigating) return; // 이미 네비게이션 중이면 return
    isNavigating = true; // 네비게이션 중 상태로 설정
    try {
      //await Future.delayed(Duration(seconds: 2)); // 2초간 대기 (데이터 로딩 시뮬레이션)
      /*await sessionController.checkSession();  // 세션 확인 로직 실행

      if (sessionController.isLoggedIn.value) {
        logger.i("로그인 상태 확인됨. 홈 화면으로 이동");
        Get.offNamed("/home");  // 세션이 있으면 HomePage로 이동
      } else {
        logger.i("로그인 상태가 아님. Intro 화면으로 이동");
        Get.offNamed("/intro");  // 세션이 없으면 IntroPage로 이동
      }*/
      //autoLoginProcess();
      checkAppVersion();
    } catch (e) {
      logger.e("세션 확인 중 오류 발생: $e");
    }
  }

  // 로그인 처리
  void autoLoginProcess() async {
    AppService.to.autoLoginProcess();
  }

  /// 앱 버전 체크
  /// 신규 버전이 있으면 업데이트 유도
  /// 없으면 로그인
  void checkAppVersion() async {
    // 신규 버전 조회 api

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print("앱버전체크====>>> " + version);
    AppInfoModel appInfo = await AppInfoRepository().appInfo(Platform.isAndroid ? "0" : "1", version);

    normalYn = appInfo.quest_type_1_yn == "Y" ? true : false;
    answerYn = appInfo.quest_type_2_yn == "Y" ? true : false;
    shareYn = appInfo.quest_type_3_yn == "Y" ? true : false;
    spYn = appInfo.quest_type_4_yn == "Y" ? true : false;

    bool updateYn = appInfo.os_update_yn == "Y" ? true : false;
    String text = appInfo.description.toString();

    /*if (appInfo.isEmpty()) {
      autoLoginProcess();
      return;
    }*/

    //test
    //autoLoginProcess();
    //return;
    // 업데이트 알림일 경우
    //지금은 안드로이드만..
    //if (Platform.isAndroid) {
      if (!updateYn) {
        String storeUri = Platform.isAndroid ? "https://play.google.com/store/apps/details?id=com.getit.getitmoney" : "https://apps.apple.com/kr/app/%EA%B2%9F%EC%9E%87%EB%A8%B8%EB%8B%88/id6741067173";
        goStore(storeUri, text);
      } else {
        await Future.delayed(Duration(seconds: 2)); // 2초간 대기 (데이터 로딩 시뮬레이션)
        autoLoginProcess();
      }
    //}
  }

  Future<void> goStore(String storeUrl, String text) async {
    Get.dialog(
      _buildCustomDialog(
        title: "최신버전 업데이트",
        message: text,
        onConfirm: () async {
          //storeUrl 로 이동하기
          moveToUrl(storeUrl);
        },
      ),
    );
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
                  onPressed: () =>autoLoginProcess(),
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

  void moveToUrl(String downloadUrl) async {
    final url = Uri.parse(downloadUrl);
    if (await canLaunchUrl(url)) {
      bool isOpened = await launchUrl(url, mode: LaunchMode.platformDefault);
      logger.d("isOpened: $isOpened");
    } else {
      logger.e("Can't launch $url");
      //스토어 이동 실패시 자동로그인을 진행한다.
      //autoLoginProcess();
    }
  }
}
