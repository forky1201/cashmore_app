import 'dart:convert';
import 'dart:math';
import 'dart:io';


import 'package:cashmore_app/app/module/common/view/auth_new_webView.dart';
import 'package:cashmore_app/app/module/common/view/auth_webView.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:cashmore_app/service/app_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs; // 로딩 상태 관리

  AuthRepository authRepository = AuthRepository(); // 변수명 오타 수정

  // 본인인증 실행 메서드
  Future<Map<String, dynamic>?> startAuth() async {
    isLoading.value = true; // 로딩 시작
    try {
      // 인증 URL 가져오기
      String url = await _fetchAuthUrl();

      // WebView 화면 이동
      final result = await Get.to(() => Platform.isAndroid ? AuthNewWebView(url: url)
      : AuthWebView(url: url,));
      
      if (result == null) {
        return null; // 인증 실패
      }

      // `result`를 JSON 형태로 반환
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        // 예상치 못한 형식
        throw FormatException("Invalid result format");
      }
    } catch (e) {
      debugPrint("본인인증 에러1: $e");
      return null;
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }

  // 백엔드에서 본인인증 URL 가져오기
  Future<String> _fetchAuthUrl() async {
    try {
      final response = await authRepository.personalAuthentication();

      /*var domain = "https://cashmore.co.kr";
      
      await _syncSessionCookies({
        "key": response.key,
        "iv": response.iv,
        "hmac_key": response.hmac_key,
        "req_no": response.req_no,
      }, domain);*/

      logger.i("111111111");

      return response.authUrl;
    } catch (e) {
      throw Exception("본인인증 URL을 가져오는 데 실패했습니다.\n오류: $e");
    }
  }

  // 계좌인증 실행 메서드
  Future<Map<String, dynamic>?> startAccount() async {
    isLoading.value = true; // 로딩 시작
    try {
      // 백엔드에서 인증 URL 가져오기
      String? userId = AppPrefs.instance.getString(currentUserId);
      String url = "https://getitmoney.co.kr/api/input_a?user_id=" + userId.toString();

      // WebView 화면으로 이동하여 본인인증 진행
      final result = await Get.to(() => AuthWebView(url: url));

      if (result == null) {
        return null; // 인증 실패
      }

      // `result`를 JSON 형태로 반환
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        // 예상치 못한 형식
        throw FormatException("Invalid result format");
      }
    } catch (e) {
      //Get.snackbar('오류', '본인인증 과정에서 문제가 발생했습니다.\n오류: $e');
      debugPrint("계좌인증 에러: $e");
      return null;
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }
}
