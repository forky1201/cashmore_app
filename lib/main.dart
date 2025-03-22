import 'dart:io';

import 'package:cashmore_app/app/module/common/controller/auth_controller.dart';
import 'package:cashmore_app/app/module/intro/controller/session_controller.dart';
import 'package:cashmore_app/pages.dart';
import 'package:cashmore_app/service/app_prefs.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeApp();
  requestPermissions(); // 권한 요청

  if (Platform.isAndroid) {
    // Foreground Task 초기화 (필수)
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'step_counter_channel',
        channelName: '걸음 수 서비스',
        channelDescription: '백그라운드에서 걸음 수를 측정합니다.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(10), // ✅ 10초마다 실행
        autoRunOnBoot: true, // 재부팅 후 자동 실행
        allowWakeLock: true, // 화면 꺼짐 방지
        allowWifiLock: true, // WiFi 절전 모드 방지
      ),
    );
  }
 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        ),
        debugShowCheckedModeBanner: false,
        title: '겟잇머니',
        theme: ThemeData(fontFamily: "Pretendard"),
        getPages: Pages.routes,
        initialRoute: Pages.initial,
      ),
    );
  }
}

/// 📌 **앱 초기화**
Future<void> initializeApp() async {
  await AppPrefs.init(); // SharedPreferences 초기화

  Get.lazyPut(() => AppService());
  Get.put(SessionController());
  Get.put(AuthController());

  // ✅ Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'ab18a221cb1c3054430fbec3e97cf5f4',
    javaScriptAppKey: 'de0da86fee794e9525e6c7287f762f8a',
  );
}

/// 📌 **권한 요청**
Future<void> requestPermissions() async {
  if (Platform.isIOS) {
    await requestIOSPermissions();
  } else {
    await requestAndroidPermissions();
  }
}

/// 📌 **iOS 권한 요청**
Future<void> requestIOSPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.photosAddOnly, // iOS 사진 권한
    Permission.activityRecognition, // 활동 인식
  ].request();

  if (statuses[Permission.photosAddOnly]?.isGranted == true) {
    print("📸 iOS - 사진 권한 허용됨");
  } else {
    print("🚨 iOS - 사진 권한 거부됨");
  }

  if (statuses[Permission.activityRecognition]?.isGranted == true) {
    print("🏃 iOS - 활동 인식 권한 허용됨");
  } else {
    print("🚨 iOS - 활동 인식 권한 거부됨");
  }
}

/// 📌 **Android 권한 요청**
Future<void> requestAndroidPermissions() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  Map<Permission, PermissionStatus> statuses = await [
    Permission.photos, // 갤러리 접근
    Permission.activityRecognition, // 활동 인식
  ].request();

  if (statuses[Permission.photos]?.isGranted == true) {
    print("📸 Android - 사진 권한 허용됨");
  } else {
    print("🚨 Android - 사진 권한 거부됨");
  }

  if (statuses[Permission.activityRecognition]?.isGranted == true) {
    print("🏃 Android - 활동 인식 권한 허용됨");
  } else {
    print("🚨 Android - 활동 인식 권한 거부됨");
  }

  // ✅ Android 13 이상에서는 알림 권한 요청
  if (androidInfo.version.sdkInt >= 33) {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      print("✅ 알림 권한 허용됨");
    } else {
      print("🚨 알림 권한 거부됨");
    }
  }

  // ✅ 배터리 최적화 무시 권한 요청
  await requestIgnoreBatteryOptimizations();
}

/// 📌 **배터리 최적화 무시 권한 요청**
Future<void> requestIgnoreBatteryOptimizations() async {
  if (await Permission.ignoreBatteryOptimizations.isGranted) {
    print("✅ 배터리 최적화 무시 권한 이미 허용됨");
    return;
  }

  var status = await Permission.ignoreBatteryOptimizations.request();
  if (status.isGranted) {
    print("✅ 배터리 최적화 무시 권한 허용됨");
  } else {
    print("🚨 배터리 최적화 무시 권한 거부됨 → 설정 페이지 열기");
    openAppSettings(); // 설정 페이지로 이동
  }
}
