import 'dart:isolate';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cashmore_app/repository/StepDatabase.dart';

@pragma('vm:entry-point')
class StepForegroundService extends TaskHandler {
  static const String resetStepsCommand = 'resetSteps';
  StreamSubscription<StepCount>? _stepSubscription;
  int _stepCount = 0;
  final StepDatabase _stepDatabase = StepDatabase();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("📢 Foreground Service onStart 실행됨 ✅");
    FlutterForegroundTask.updateService(
      notificationTitle: "걸음 수 측정 중",
      notificationText: "백그라운드에서 걸음 수를 기록 중입니다.",
    );

    print("📢 Foreground Service Started: Listening for Steps");

    _stepSubscription = Pedometer.stepCountStream.listen((StepCount event) async {
      _stepCount = event.steps;
      final date = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      await _stepDatabase.insertOrUpdateStepData("userId", date, 0, 0, _stepCount);
      FlutterForegroundTask.saveData(key: 'stepCount', value: _stepCount);
      FlutterForegroundTask.sendDataToMain(_stepCount);
      print("✅ 걸음 수 업데이트: $_stepCount");
    }, onError: (error) {
      print("🚨 걸음 수 측정 오류: $error");
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    FlutterForegroundTask.updateService(
      notificationTitle: "걸음 수 측정 중",
      notificationText: "현재 걸음 수: $_stepCount",
    );
  }

  @override
  void onReceiveData(Object data) {
    if (data == resetStepsCommand) {
      _resetSteps();
    }
  }

  void _resetSteps() async {
    final date = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    await _stepDatabase.insertOrUpdateStepData("userId", date, 0, 0, 0);
    _stepCount = 0;
    FlutterForegroundTask.updateService(
      notificationTitle: "걸음 수 초기화됨",
      notificationText: "걸음 수가 0으로 초기화되었습니다.",
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    await _stepSubscription?.cancel();
    print("📢 Foreground Service Stopped");
  }
}

class StepForegroundServiceManager {
  static Future<void> startForegroundService() async {
    if (Platform.isAndroid) {
      final isRunning = await FlutterForegroundTask.isRunningService;
      print("📢 Foreground Service 실행 여부: $isRunning");

      if (!isRunning) {
        print("📢 Foreground Service 실행 시작 🚀");
        await FlutterForegroundTask.startService(
          notificationTitle: "걸음 수 측정 중",
          notificationText: "백그라운드에서 걸음 수를 기록 중입니다.",
          callback: startCallback, // 🔹 startCallback 등록 필수
        );
        print("📢 Foreground Service Started ✅");
      } else {
        print("🚨 Foreground Service already running");
      }
    }
  }




  static Future<void> stopForegroundService() async {
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      await FlutterForegroundTask.stopService();
      print("📢 Foreground Service Stopped");
    } else {
      print("🚨 Foreground Service is not running");
    }
  }

  @pragma('vm:entry-point')
  static void startCallback() {
     print("📢 Foreground Service startCallback 실행됨 ✅");
    FlutterForegroundTask.setTaskHandler(StepForegroundService());
  }
}

