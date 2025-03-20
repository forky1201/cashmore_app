import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cashmore_app/app/module/account/controller/signup_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginController extends BaseController {
  final appService = Get.find<AppService>();

  // 이메일과 비밀번호 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // BaseApiService 인스턴스 생성
  AuthRepository authRepository = AuthRepository();

  // 로그인 메서드
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('입력 오류', '이메일과 비밀번호를 모두 입력해주세요.');
      return;
    }

    Map<String, dynamic> requestBody = {
      "user_id": email,
      "user_pw": password,
      "snskey": "",
      "snstype": "1",
      "email": email,
    };

    try {
      // 로그인 시도
      logger.i('로그인 시도: 이메일 = $email, 비밀번호 = $password');
      final response = await authRepository.login(requestBody);

      // 로그인 성공 처리
      logger.i(["[token] ${response.token}", "[userId] ${email}"]);

      if (response.code == 401) {
        Get.snackbar('오류', "아이디 또는 비밀번호가 다릅니다.");
        return;
      }

      appService.saveTokenAndGoMain(response, email);
    } on DioException catch (err) {
      // DioException 처리
      logger.e(err);
      if (err.type == DioExceptionType.badResponse) {
        if (err.response?.statusCode == 401) {
          Get.snackbar('오류', "아이디 또는 비밀번호가 다릅니다.");
        } else {
          Get.snackbar('오류', '서버 응답 오류: ${err.response?.statusMessage}');
        }
      } else if (err.type == DioExceptionType.connectionTimeout) {
        Get.snackbar('네트워크 오류', '서버에 연결할 수 없습니다. 연결 상태를 확인해주세요.');
      } else if (err.type == DioExceptionType.receiveTimeout) {
        Get.snackbar('네트워크 오류', '서버 응답이 지연되고 있습니다. 나중에 다시 시도해주세요.');
      } else {
        Get.snackbar('오류', '아이디 또는 비밀번호가 다릅니다.');
      }
    } catch (e) {
      // 기타 예외 처리
      logger.e('Unexpected error: $e');
      Get.snackbar('오류', '아이디 또는 비밀번호가 다릅니다.');
    }
  }

  // 페이지 이동
  Future<void> moveToUrl(String url) async {
    Get.toNamed(url);
  }

  //애플 로그인
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> appleLogin() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    List<String> jwt = appleCredential.identityToken?.split('.') ?? [];
    String payload = jwt[1];
    payload = base64.normalize(payload);

    final List<int> jsonData = base64.decode(payload);
    final userInfo = jsonDecode(utf8.decode(jsonData));
    String email = userInfo['email'];
    String snsKey = userInfo['sub'];
    String name = '';
    if (appleCredential.familyName != null && appleCredential.givenName != null) {
      name = '${appleCredential.familyName} ${appleCredential.givenName}';
    }

    print('애플 로그인  ========>  $email/$snsKey');
    requestLogin(email, "apple", snsKey, name);
  }

  Future<void> requestLogin(String email, String type, String snsKey, String name) async {
    Map<String, dynamic> requestBody = {
      "user_id": email,
      "user_pw": "",
      "snskey": snsKey,
      "snstype": type,
      "email": email,
    };

    try {
      // 로그인 시도
      final response = await authRepository.login(requestBody);
      logger.i("code====>>>" + response.code.toString());
      if (response.code == 404) {
        _moveToSnsJoin(email, type, snsKey, name);
      } else {
        // 로그인 성공 처리
        logger.i(["[token] ${response.token}", "[userId] ${email}"]);
        appService.saveTokenAndGoMain(response, email);
      }
    } on DioException catch (err) {
      // DioException 처리
      logger.e(err);
      if (err.type == DioErrorType.badResponse) {
        switch (err.response!.statusCode) {
          case 404:

            /*Get.find<CustomDialogController>().onConfirmDialog(
                () => _moveToSnsJoin(email, joinType, snsKey, name),
                "아이디가 없습니다. 회원가입 하시겠습니까?");*/
            break;
        }
      }
    } catch (e) {
      // 기타 예외 처리
      logger.e('Unexpected error: $e');
      Get.snackbar('오류', '아이디 또는 비밀번호가 다릅니다.');
    }
  }

  Future<void> requestLoginKakao(String email, String type, String snsKey, String name, String birth, String gender, String phoneNumber, String di) async {
    Map<String, dynamic> requestBody = {
      "user_id": email,
      "user_pw": "",
      "snskey": snsKey,
      "snstype": type,
      "email": email,
    };

    try {
      // 로그인 시도
      final response = await authRepository.login(requestBody);
      logger.i("code====>>>" + response.code.toString());
      if (response.code == 404) {
        setSnsJoinKakao(email, type, snsKey, name, birth, gender, phoneNumber, di);
      } else {
        // 로그인 성공 처리
        logger.i(["[token] ${response.token}", "[userId] ${email}"]);
        appService.saveTokenAndGoMain(response, email);
      }
    } on DioException catch (err) {
      // DioException 처리
      logger.e(err);
      if (err.type == DioErrorType.badResponse) {
        switch (err.response!.statusCode) {
          case 404:

            /*Get.find<CustomDialogController>().onConfirmDialog(
                () => _moveToSnsJoin(email, joinType, snsKey, name),
                "아이디가 없습니다. 회원가입 하시겠습니까?");*/
            break;
        }
      }
    } catch (e) {
      // 기타 예외 처리
      logger.e('Unexpected error: $e');
      Get.snackbar('오류', '아이디 또는 비밀번호가 다릅니다.');
    }
  }

  void _moveToSnsJoin(String email, String joinType, String snsKey, String name) {
    setSnsJoin(email, joinType, snsKey, name);
  }

  Future<void> setSnsJoin(String email, String snstype, String snskey, String name) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "snstype": snstype,
      "snskey": snskey,
      "name": name,
    };

    Get.toNamed("/signup", arguments: requestBody);
  }

  Future<void> setSnsJoinKakao(String email, String snstype, String snskey, String name, String birth, String gender, String phoneNumber, String di) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "snstype": snstype,
      "snskey": snskey,
      "name": name,
      "birth": birth,
      "gender": gender,
      "phoneNumber": phoneNumber,
      "di": di,
    };

    Get.toNamed("/signup", arguments: requestBody);
  }

  /// 카카오 로그인
  Future<void> kakaoLogin() async {
    try {
      OAuthToken token;

      // 카카오톡 앱을 통한 로그인 시도
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡 앱을 통한 로그인 성공: ${token.accessToken}');
        //Get.snackbar('성공', '카카오톡 앱을 통한 로그인 성공: ${token.accessToken}');
      } catch (error) {
        print('카카오톡 앱을 통한 로그인 실패: $error');
        //Get.snackbar('성공', '카카오톡 앱을 통한 로그인 실패: ${error}');
        // 카카오톡 미설치 또는 로그인 실패 시 웹뷰 로그인 시도
        token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오 계정 웹뷰를 통한 로그인 성공: ${token.accessToken}');
        //Get.snackbar('성공', '카카오톡 앱을 통한 로그인 성공: ${token.accessToken}');
      }

      

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String email = user.kakaoAccount?.email ?? '';
      String di = user.uuid ?? '';
      String name = user.kakaoAccount?.name ?? '';

      String birthday = user.kakaoAccount?.birthday ?? '';
      String birthdayYear = user.kakaoAccount?.birthyear ?? '';
      Gender? gender = user.kakaoAccount!.gender;
      String phoneNumber = user.kakaoAccount?.phoneNumber ?? '';
      String snsKey = user.id.toString();

      String birth = birthdayYear + birthday;

      String strGender = gender == Gender.male ? '1' : '0';

      print('카카오 사용자 정보: $email, $snsKey, $name, $birth, $strGender, $phoneNumber, $di');

      // 서버에 로그인 요청
      requestLoginKakao(email, "kakao", snsKey, name, birth, strGender, phoneNumber, di);
    } catch (error) {
      print('카카오 로그인 실패: $error');
      //Get.snackbar('오류', '카카오 로그인에 실패했습니다.' + error.toString());
    }
  }
}
