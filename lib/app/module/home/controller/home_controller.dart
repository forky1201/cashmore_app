// lib/controllers/home_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/app/module/service/health_Observer_service.dart';
import 'package:cashmore_app/app/module/service/step_foreground_service.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/recommender_model.dart';
import 'package:cashmore_app/common/model/totalPoint_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/StepDatabase.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:cashmore_app/repository/home_repsitory.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// pedometer 패키지 사용

/// ── HomeController ───────────────────────────────────────────────────────────────
class HomeController extends BaseController {
  // 포인트, 초대 친구 등 기존 변수
  var points = 0.obs;
  var availablePoints = 0.obs;
  var invitedFriendsCount = 1.obs;
  var accumulatedPoints = 0.obs;
  var boardMessage = '문의는 제휴/광고 게시판으로 연락주세요'.obs;
  var isDontShowChecked = false.obs;

  // 걸음 수 관련 변수 (health 패키지 사용)
  var stepCount = 0.obs;
  var baseStepCount = 0.obs; // 자정 기준 걸음 수 저장

  // Pedometer 상태 메시지 (UI 표시 용)
  var pedometerStatus = '걸음수 대기 중'.obs;
  final StepDatabase _stepDatabase = StepDatabase();

  // 사용자 관련 변수
  var user = Rxn<UserModel>();
  var name = "".obs;

  // 미션/보상 관련 변수
  var step500 = "N".obs;
  var step1000 = "N".obs;
  var step2000 = "N".obs;
  var step3000 = "N".obs;
  var step5000 = "N".obs;
  var step10000 = "N".obs;

  var point500 = 0.obs;
  var point1000 = 0.obs;
  var point2000 = 0.obs;
  var point3000 = 0.obs;
  var point5000 = 0.obs;
  var point10000 = 0.obs;

  // 메시지 관련 타이머
  late Timer _messageTimer = Timer(Duration.zero, () {});
  late Timer pointTimer = Timer(Duration.zero, () {});
  int _messageIndex = 0;
  final List<String> _messages = [
    '문의는 제휴/광고 게시판으로 연락주세요',
    '최신 이벤트: 지금 참여하세요!',
  ];

  final List<int> _noticeIds = [1, 2];

  // 현재 메시지에 해당하는 noticeId 저장 변수
  var currentNoticeId = 1.obs;

  // 걸음 측정 활성화 여부
  var isStepCountEnabled = true.obs;

  Timer? _midnightResetTimer;
  Timer? _stepUpdateTimer; // Android 걸음수 업데이트
  Timer? _iosStepUpdateTimer; // iOS 걸음수 업데이트

  StreamSubscription<StepCount>? _stepSubscription;
  final Health health = Health();

  @override
  Future<void> onInit() async {
    super.onInit();
    userInfo();

    await requestPermissions();

    if (Platform.isAndroid) {
      await loadSavedStepCount();

      startForegroundService();
      scheduleMidnightReset();
      startStepTracking();
      await loadStepCountSetting(); // ✅ 앱 시작 시 걸음 수 설정 불러오기
      // Foreground Service 실행 여부 확인 후 시작
      if (isStepCountEnabled.value) {
        await StepForegroundServiceManager.startForegroundService();
      }
    } else {
      requestHealthPermissions();
      // 초기 걸음수 불러오기 (앱 시작 시)
      await HealthObserverService.initStepFromHealth((steps) {
        stepCount.value = steps;
      });

      // observer query 수신
      HealthObserverService.startObserver();
      HealthObserverService.listenToUpdates((steps) {
        stepCount.value = steps;
      });


    }

    
    totalPoint();
    pointAdd();
    friend();
    _startMessageRotation();
    startTotalPointUpdate();

    //pedometerStatus.value = '걸음수 측정 중';

    //WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void onClose() {
    _messageTimer.cancel();
    pointTimer.cancel();
    _midnightResetTimer?.cancel();
    _stepUpdateTimer?.cancel();
    _iosStepUpdateTimer?.cancel();
    _stepSubscription?.cancel();
    //WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    stopForegroundService();
    super.onClose();
  }

  /// ── 메시지 타이머 (10초마다 변경) ──────────────────────────────────────────
  void _startMessageRotation() {
    // 초기값 설정 (첫 번째 메시지)
    boardMessage.value = _messages[0];
    currentNoticeId.value = _noticeIds[0];

    _messageTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _messageIndex = (_messageIndex + 1) % _messages.length;
      boardMessage.value = _messages[_messageIndex];
      currentNoticeId.value = _noticeIds[_messageIndex];
    });
  }

  /// ── totalPoint 업데이트 (20초마다) ───────────────────────────────────────
  void startTotalPointUpdate() {
    pointTimer = Timer.periodic(Duration(seconds: 20), (timer) async {
      await totalPoint();
    });
  }

  Future<int> getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return -1; // 안드로이드가 아닌 경우
  }

  /// 🚀 권한 요청
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      int androidVersion = await getAndroidSdkVersion();
      print("✅ 현재 Android SDK 버전: $androidVersion");
      await Permission.activityRecognition.request();
      // ✅ Android 14(API 34) 이상이면 Foreground Service 권한 요청
      if (androidVersion >= 34) {
        // Android 14(API 34) 이상
        await requestForegroundServicePermission();
      }
    }
  }

  Future<void> requestForegroundServicePermission() async {
    int androidVersion = await getAndroidSdkVersion();
    final prefs = await SharedPreferences.getInstance();
    if (androidVersion >= 34) {
      var status = await Permission.ignoreBatteryOptimizations.request();

      if (status.isGranted) {
        print("✅ Foreground Service 권한 허용됨");
      } else {
        print("🚨 Foreground Service 권한 거부됨");
        await prefs.setBool('isStepCountEnabled', false);
      }
    }
  }

  /// 🚀 Health API 권한 요청 (iOS만 사용)
  Future<void> requestHealthPermissions() async {
    if (!Platform.isIOS) return;

    List<HealthDataType> types = [HealthDataType.STEPS];
    bool authorized = await health.requestAuthorization(types);

    if (!authorized) {
      print("🚨 Apple Health 권한 요청 실패");
      pedometerStatus.value = '걸음수 대기 중';
    } else {
      print("✅ Apple Health 권한 요청 성공");
      pedometerStatus.value = '걸음수 측정 중';
    }
  }

  //안드로이드용
  Future<void> loadStepCountSetting() async {
    final prefs = await SharedPreferences.getInstance();
    isStepCountEnabled.value = prefs.getBool('isStepCountEnabled') ?? true;
    await toggleStepCount(isStepCountEnabled.value);
  }

  Future<void> toggleStepCount(bool enable) async {
    isStepCountEnabled.value = enable;
    if (enable) {
      pedometerStatus.value = '걸음수 측정 중';
      stepCount.value = 0;
      baseStepCount.value = 0;
      await loadSavedStepCount();
      startForegroundService();
      startStepTracking();
    } else {
      pedometerStatus.value = '걸음수 측정 중지';
      stepCount.value = 0;
      baseStepCount.value = 0;
      await _stepDatabase.insertOrUpdateStepData("userId", "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}", 0, 0, 0);
      stopForegroundService();
      _stepSubscription?.cancel();
    }
  }

  void startStepTracking() {
    _stepSubscription = Pedometer.stepCountStream.listen((StepCount event) async {
      final date = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      // 기존 저장된 걸음 수 가져오기
      final stepData = await _stepDatabase.getStepData("userId", date);
      int lastSavedSteps = stepData?['stepCount'] ?? 0;
      int savedBaseStep = stepData?['todayStepBase'] ?? 0;

      // ✅ 앱 첫 실행이거나 저장된 데이터가 없으면 baseStepCount 초기화
      if (savedBaseStep == 0) {
        baseStepCount.value = event.steps;
        stepCount.value = 0;
      } else {
        baseStepCount.value = savedBaseStep;
        stepCount.value = event.steps - baseStepCount.value;
      }

      // ✅ SQLite에 데이터 업데이트
      await _stepDatabase.insertOrUpdateStepData("userId", date, baseStepCount.value, lastSavedSteps, stepCount.value);

      print("✅ 현재 걸음 수: ${event.steps}, 기준 걸음 수: ${baseStepCount.value}, 저장된 걸음 수: ${stepCount.value}");
    }, onError: (error) {
      print("🚨 걸음 수 측정 오류: $error");
    });
  }

  Future<void> loadSavedStepCount() async {
    final now = DateTime.now();
    final date = "${now.year}-${now.month}-${now.day}";
    final stepData = await _stepDatabase.getStepData("userId", date);
    stepCount.value = stepData?["stepCount"] ?? 0;
    baseStepCount.value = stepData?["todayStepBase"] ?? 0;
  }

  void scheduleMidnightReset() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final timeUntilMidnight = midnight.difference(now);

    _midnightResetTimer = Timer(timeUntilMidnight, () async {
      final previousDate = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day - 1}";
      await _stepDatabase.deleteStepData("userId", previousDate);
      final date = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      baseStepCount.value = 0;
      stepCount.value = 0;

      await _stepDatabase.insertOrUpdateStepData("userId", date, baseStepCount.value, 0, 0);

      print("✅ 자정 걸음 수 초기화 완료");

      // Foreground Service에도 초기화 요청 (백그라운드 대비)
      FlutterForegroundTask.sendDataToTask("resetSteps");

      // 다음 자정에도 다시 실행
      scheduleMidnightReset();
    });

    print("✅ 자정 리셋 예약됨: ${midnight}");
  }

  void startForegroundService() async {
    //await Permission.activityRecognition.request();
    //await Permission.ignoreBatteryOptimizations.request();

    FlutterForegroundTask.startService(
      notificationTitle: "걸음 수 측정 중",
      notificationText: "백그라운드에서 걸음 수를 기록 중입니다.",
      callback: StepForegroundServiceManager.startCallback,
    );

    _listenForForegroundUpdates();
  }

  void _listenForForegroundUpdates() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      var data = await FlutterForegroundTask.getData(key: 'stepCount');
      if (data is int) {
        stepCount.value = data;
        print("📢 Foreground Service에서 걸음 수 업데이트: $stepCount");
      }
    });
  }

  void stopForegroundService() async {
    bool isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      await StepForegroundServiceManager.stopForegroundService();
      print("✅ Foreground Service 중지");
    } else {
      print("⚠️ Foreground Service 실행 중이 아님");
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  // 이하 기존 포인트, 사용자 정보, 미션 관련 로직 (변경 없이 유지)
  //////////////////////////////////////////////////////////////////////////////

  void pointAdd() async {
    AuthRepository authRepository = AuthRepository();
    Map<String, dynamic> requestBody = {"user_id": AppService.to.userId};
    final response = await authRepository.pointAdd(requestBody);
    if (response.code == 200) {
      userInfo();
      _showPointAddBottomSheet();
    }
  }

  Future<void> friend() async {
    UserModel user = await AppService().getUser();
    MypageRepsitory mypageRepsitory = MypageRepsitory();
    List<RecommenderModel> list = await mypageRepsitory.recommendersList(
      user.user_id,
      user.my_recommender.toString(),
      0,
      100,
    );
    invitedFriendsCount.value = list.length;
  }

  void _showPointAddBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 231, 203, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                "오늘 출석체크를 완료했습니다.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/popup1.png'),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "적립완료 !!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final mainController = Get.find<MainController>();
                  mainController.updateIndex(3);
                  await mainController.navigateTo(3);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "포인트 확인 하기",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: isDontShowChecked.value,
                              onChanged: (value) {
                                isDontShowChecked.value = value ?? false;
                              },
                            )),
                        const Text(
                          "오늘 그만 보기",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("닫기", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: Colors.transparent,
    );
  }

  void collectPoints() {
    // 포인트 적립 후 초기화 등 관련 로직 구현 (필요 시)
  }

  Future<void> inviteFriend() async {
    Get.toNamed("/recommen");
  }

  Future<void> inviteCoupon() async {
    final mainController = Get.find<MainController>();
    mainController.updateIndex(2);
    await mainController.navigateTo(2);
  }

  Future<void> userInfo() async {
    await AppService.to.loginInfoRefresh();
    UserModel fetchedUser = await AppService().getUser();
    points.value = fetchedUser.total_point!;
    availablePoints.value = points.value;

    step500.value = fetchedUser.step500 ?? "N";
    step1000.value = fetchedUser.step1000 ?? "N";
    step2000.value = fetchedUser.step2000 ?? "N";
    step3000.value = fetchedUser.step3000 ?? "N";
    step5000.value = fetchedUser.step5000 ?? "N";
    step10000.value = fetchedUser.step10000 ?? "N";

    point500.value = fetchedUser.point500!;
    point1000.value = fetchedUser.point1000!;
    point2000.value = fetchedUser.point2000!;
    point3000.value = fetchedUser.point3000!;
    point5000.value = fetchedUser.point5000!;
    point10000.value = fetchedUser.point10000!;

    user.value = fetchedUser;
    name.value = fetchedUser.user_name!;
  }

  Future<void> totalPoint() async {
    HomeRepsitory homeRepsitory = HomeRepsitory();
    TotalPointModel totalPoint = await homeRepsitory.totalPoint(AppService.to.userId!);
    accumulatedPoints.value = totalPoint.total_point!;
  }

  Future<void> movetoUrl() async {
    final mainController = Get.find<MainController>();
    await mainController.navigateTo(1);
  }

  Future<void> stepPointAdd(int step, int point) async {
    HomeRepsitory homeRepsitory = HomeRepsitory();
    Map<String, dynamic> requestBody = {
      "user_id": AppService.to.userId!,
      "steps": step,
    };

    await homeRepsitory.stepPointAdd(requestBody).then((response) async {
      Get.dialog(
        _buildCustomDialog(
          title: "미션완료",
          message: "$point 포인트 적립 되었습니다.",
          onConfirm: () {
            userInfo();
            Get.back();
          },
        ),
      );
    });
  }

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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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

  Widget _buildDialogButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
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
