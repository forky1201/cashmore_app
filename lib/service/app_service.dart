import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cashmore_app/app/module/main/views/main_view.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/auth_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:cashmore_app/service/app_prefs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppService extends GetxService {
  static AppService get to => Get.find();

  // Repository
  AuthRepository authRepository = AuthRepository();

  // Rx<UserModel>? userModel;
  RxBool isLogged = false.obs;
  String? get accessToken => AppPrefs.instance.getString(kAccessToken);

  String? get userId => AppPrefs.instance.getString(currentUserId);
  int? get totalPoint => AppPrefs.instance.getInt(currentTotalPoint);
  String? get userName => AppPrefs.instance.getString(currentUserName);
  String? get snsType => AppPrefs.instance.getString(currentSnstype);

  /// 로그인 사용자 정보, flutter_secure_storage는 IOS적용 이슈로 나중에 적용하는걸로...
  Future<UserModel> getUser() async {
    String? userString = AppPrefs.instance.getString(currentUser);
    if (userString == null) {
      // 로그인 정보가 없으면 에러를 낼지? 아니면 로그인 페이지로 이동시킬지?
      return Future.error("로그인 정보 없음.");
    } else {
      Map<String, dynamic> json = jsonDecode(userString);
      return UserModel.fromJson(json);
    }
  }

  Future<void> loginInfoRefresh() async {
    try {
      LoggedIn loggedIn = await authRepository.loggedIn(userId!); // 사용자 정보 조회 및 firebaseToken
      UserModel user = loggedIn.data;
      //String firebaseToken = loggedIn.firebaseToken;
      //await firebaseSignInWithCustomToken(firebaseToken); // firebase sign-in

      await AppPrefs.instance.setString(currentUserId, user.user_id.toString());
      await AppPrefs.instance.setString(currentUser, jsonEncode(user));
      await AppPrefs.instance.setInt(currentTotalPoint, user.total_point!);
      await AppPrefs.instance.setString(currentUserName, user.user_name.toString());
      await AppPrefs.instance.setString(currentSnstype, user.snstype.toString());
    } catch (e) {
      logger.e('requestGetUserInfo error: $e');
      logout();
    }
  }

  Future<String?> getSession() async {
    final expiryDate = DateTime.parse(AppPrefs.instance.getString('session_expiry') ?? DateTime.now().toIso8601String());
    if (expiryDate.isAfter(DateTime.now())) {
      return AppPrefs.instance.getString(kAccessToken); // 유효한 세션일 경우 반환
    }
    return null; // 세션 만료 시 null 반환
  }

  Future<void> saveToken(AuthModel authModel) async {
    //user?.value = responseSignUp.user;
    // accessToken = authModel.accessToken;
    // refreshToken = authModel.refreshToken;
    logger.i(["[token] ${authModel.token}"]);
    await AppPrefs.instance.setString(kAccessToken, authModel.token!);
    await AppPrefs.instance.setString('session_expiry', DateTime.now().add(Duration(days: 365)).toIso8601String());
  }

  void saveTokenAndGoMain(AuthModel authModel, String userId) async {
    await saveToken(authModel);
    loginProcess(userId);
  }

  Future<void> logout() async {
    await AppPrefs.instance.remove(currentUserId);
    await AppPrefs.instance.remove(currentUser);
    await AppPrefs.instance.remove(currentUserName);

    AppPrefs.instance.remove(kAccessToken);
    Get.offAllNamed("/intro");
  }

  // 로그인 처리
  void loginProcess(String userId) async {
    try {
      LoggedIn loggedIn = await authRepository.loggedIn(userId); // 사용자 정보 조회 및 firebaseToken
      UserModel user = loggedIn.data;

      await AppPrefs.instance.setString(currentUserId, user.user_id.toString());
      await AppPrefs.instance.setString(currentUser, jsonEncode(user));
      await AppPrefs.instance.setInt(currentTotalPoint, user.total_point!);
      await AppPrefs.instance.setString(currentUserName, user.user_name.toString());

      //Get.offAllNamed(page);
      Get.offAll(() => const MainPage());
    } catch (e) {
      logger.e('requestGetUserInfo error: $e');
      logout();
    }
  }

  /// 자동 로그인 프로세스
  void autoLoginProcess() async {
    final token = await getSession();
    if (token == null) {
      // 토큰이 없을 경우
      logger.i('no Token');
      Get.offAllNamed("/intro");
    } else {
      logger.i('Token1: ${accessToken.toString()}');

      // ✅ userId가 null인지 확인 후 처리
      if (userId == null) {
        logger.e('❌ userId is null. Cannot proceed with login.');
        Get.offAllNamed("/login"); // 또는 다른 처리
        return;
      }

      loginProcess(userId!);
    }
  }

  

  Future<bool> confirmExit(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "앱을 종료하시겠습니까?",
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("취소", style: TextStyle(fontSize: 16)),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("종료", style: TextStyle(fontSize: 16)),
                  onPressed: () => exit(0),
                )
              ],
            )) as Future<bool>;
  }

  Future<String?> getDeviceUniqueId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // Android ID 가져오기
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android 고유 ID
    } else if (Platform.isIOS) {
      // iOS identifierForVendor 가져오기
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS 고유 ID
    }
    return null;
  }

  Future<String?> getloadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
    return appVersion;
  }
}
