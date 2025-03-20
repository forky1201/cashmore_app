import 'package:cashmore_app/app/module/home/controller/home_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthController extends BaseController {
  final Health health = Health();

  static const String healthConnectDismissedKey = "healthConnectDismissed";

  // 오늘 데이터
  var todaySteps = ''.obs;
  var todayHeartRate = ''.obs;
  var todaySleep = ''.obs;
  var todayCalories = ''.obs;
  var todayWeight = ''.obs;
  var todayHeight = ''.obs;
  var todayTemperature = ''.obs;
  var todayBloodPressure = ''.obs;
  var todayOxygen = ''.obs;
  var todayBloodSugar = ''.obs;
  var todayWaterIntake = ''.obs;

  // 이번달 데이터
  var monthSteps = ''.obs;
  var monthHeartRate = ''.obs;
  var monthSleep = ''.obs;
  var monthCalories = ''.obs;
  var monthWeight = ''.obs;
  var monthHeight = ''.obs;
  var monthTemperature = ''.obs;
  var monthBloodPressure = ''.obs;
  var monthOxygen = ''.obs;
  var monthBloodSugar = ''.obs;
  var monthWaterIntake = ''.obs;

  // 전체 데이터
  var totalSteps = ''.obs;
  var totalHeartRate = ''.obs;
  var totalSleep = ''.obs;
  var totalCalories = ''.obs;
  var totalWeight = ''.obs;
  var totalHeight = ''.obs;
  var totalTemperature = ''.obs;
  var totalBloodPressure = ''.obs;
  var totalOxygen = ''.obs;
  var totalBloodSugar = ''.obs;
  var totalWaterIntake = ''.obs;

  @override
  void onInit() {
    super.onInit();
    //Platform.isAndroid ? checkAndInstallHealthConnect(Get.context!) : requestPermissionsAndFetchData(); // Health Connect 체크
    Platform.isAndroid ? "" : requestPermissionsAndFetchData(); // Health Connect 체크
  }

  // 📌 권한 요청 및 데이터 가져오기
  Future<void> requestPermissionsAndFetchData() async {
    bool permission = await health.requestAuthorization([
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      if (Platform.isIOS) HealthDataType.BODY_TEMPERATURE,
      if (Platform.isIOS) HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      if (Platform.isIOS) HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      if (Platform.isIOS) HealthDataType.BLOOD_OXYGEN,
      if (Platform.isIOS) HealthDataType.BLOOD_GLUCOSE,
      if (Platform.isIOS) HealthDataType.WATER,
    ]);

    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      if (Platform.isIOS) HealthDataType.BODY_TEMPERATURE,
      if (Platform.isIOS) HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      if (Platform.isIOS) HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      if (Platform.isIOS) HealthDataType.BLOOD_OXYGEN,
      if (Platform.isIOS) HealthDataType.BLOOD_GLUCOSE,
      if (Platform.isIOS) HealthDataType.WATER,
    ];
    //Future<bool?> aa = health.hasPermissions(types);

    if (permission) {
      fetchTodayHealthData();
      fetchMonthHealthData();
      fetchTotalHealthData();
    } else {
      print("건강 데이터 접근 권한이 거부되었습니다.");
    }
  }

  // 📊 오늘 데이터 가져오기
  Future<void> fetchTodayHealthData() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = now;
    //print("startOfDay===>>>" + startOfDay.toString());
    //print("endOfDay===>>>" + endOfDay.toString());
    await fetchHealthData(
      startOfDay,
      endOfDay,
      onUpdate: (data) {
        todaySteps.value = data['steps'] ?? '데이터 없음';
        todayHeartRate.value = data['heartRate'] ?? '데이터 없음';
        todaySleep.value = data['sleep'] ?? '데이터 없음';
        todayCalories.value = data['calories'] ?? '데이터 없음';
        todayWeight.value = data['weight'] ?? '데이터 없음';
        todayHeight.value = data['height'] ?? '데이터 없음';
        todayTemperature.value = data['temperature'] ?? '데이터 없음';
        todayBloodPressure.value = data['bloodPressure'] ?? '데이터 없음';
        todayOxygen.value = data['oxygen'] ?? '데이터 없음';
        todayBloodSugar.value = data['bloodSugar'] ?? '데이터 없음';
        todayWaterIntake.value = data['water'] ?? '데이터 없음';
      },
    );
  }

  // 🗓️ 이번달 데이터 가져오기
  Future<void> fetchMonthHealthData() async {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    await fetchHealthData(
      startOfMonth,
      now,
      onUpdate: (data) {
        monthSteps.value = data['steps'] ?? '데이터 없음';
        monthHeartRate.value = data['heartRate'] ?? '데이터 없음';
        monthSleep.value = data['sleep'] ?? '데이터 없음';
        monthCalories.value = data['calories'] ?? '데이터 없음';
        monthWeight.value = data['weight'] ?? '데이터 없음';
        monthHeight.value = data['height'] ?? '데이터 없음';
        monthTemperature.value = data['temperature'] ?? '데이터 없음';
        monthBloodPressure.value = data['bloodPressure'] ?? '데이터 없음';
        monthOxygen.value = data['oxygen'] ?? '데이터 없음';
        monthBloodSugar.value = data['bloodSugar'] ?? '데이터 없음';
        monthWaterIntake.value = data['water'] ?? '데이터 없음';
      },
    );
  }

  // 🌐 전체 데이터 가져오기
  Future<void> fetchTotalHealthData() async {
    DateTime start = DateTime.now().subtract(const Duration(days: 365));

    await fetchHealthData(
      start,
      DateTime.now(),
      onUpdate: (data) {
        totalSteps.value = data['steps'] ?? '데이터 없음';
        totalHeartRate.value = data['heartRate'] ?? '데이터 없음';
        totalSleep.value = data['sleep'] ?? '데이터 없음';
        totalCalories.value = data['calories'] ?? '데이터 없음';
        totalWeight.value = data['weight'] ?? '데이터 없음';
        totalHeight.value = data['height'] ?? '데이터 없음';
        totalTemperature.value = data['temperature'] ?? '데이터 없음';
        totalBloodPressure.value = data['bloodPressure'] ?? '데이터 없음';
        totalOxygen.value = data['oxygen'] ?? '데이터 없음';
        totalBloodSugar.value = data['bloodSugar'] ?? '데이터 없음';
        totalWaterIntake.value = data['water'] ?? '데이터 없음';
      },
    );
  }

  // 📊 공통 Health 데이터 가져오기 (iPhone 걸음 수 필터 적용)
  Future<void> fetchHealthData(DateTime start, DateTime end, {required Function(Map<String, String>) onUpdate}) async {
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      if (Platform.isIOS) HealthDataType.BODY_TEMPERATURE,
      if (Platform.isIOS) HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      if (Platform.isIOS) HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      if (Platform.isIOS) HealthDataType.BLOOD_OXYGEN,
      if (Platform.isIOS) HealthDataType.BLOOD_GLUCOSE,
      if (Platform.isIOS) HealthDataType.WATER,
    ];

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(types: types, startTime: start, endTime: end);

    Map<String, String> results = {};
    int steps = 0;
    int heartRate = 0;
    double calories = 0;
    double sleepHours = 0;
    double weight = 0;
    double height = 0;
    double temperature = 0;
    double systolic = 0;
    double diastolic = 0;
    double oxygen = 0;
    double bloodSugar = 0;
    double water = 0;

    for (var point in healthData) {
      final value = point.value;

      if (point.type == HealthDataType.STEPS) {
        // 🔹 "iPhone"에서 기록된 걸음 수만 포함
        if (Platform.isIOS && point.sourceName.contains("iPhone")) {
          steps += (value as NumericHealthValue).numericValue?.toDouble()?.toInt() ?? 0;
        }
      } else if (point.type == HealthDataType.HEART_RATE) {
        heartRate = (value as NumericHealthValue).numericValue?.toDouble()?.toInt() ?? 0;
      } else if (point.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
        calories += (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (point.type == HealthDataType.SLEEP_ASLEEP) {
        sleepHours += (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (point.type == HealthDataType.WEIGHT) {
        weight = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (point.type == HealthDataType.HEIGHT) {
        height = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (Platform.isIOS && point.type == HealthDataType.BODY_TEMPERATURE) {
        temperature = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (Platform.isIOS && point.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
        systolic = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (Platform.isIOS && point.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
        diastolic = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (Platform.isIOS && point.type == HealthDataType.BLOOD_OXYGEN) {
        oxygen = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (Platform.isIOS && point.type == HealthDataType.BLOOD_GLUCOSE) {
        bloodSugar = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      } else if (Platform.isIOS && point.type == HealthDataType.WATER) {
        water = (value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
      }
    }

    results['steps'] = '$steps 걸음'; // 🔹 아이폰에서 측정된 걸음 수만 표시
    results['heartRate'] = heartRate > 0 ? '$heartRate bpm' : '데이터 없음';
    results['calories'] = '${calories.toStringAsFixed(2)} kcal';
    results['sleep'] = '${sleepHours.toStringAsFixed(1)}시간';
    results['weight'] = '${weight.toStringAsFixed(1)} kg';
    results['height'] = '${height.toStringAsFixed(1)} m';
    results['temperature'] = temperature > 0 ? '${temperature.toStringAsFixed(1)}℃' : '데이터 없음';
    results['bloodPressure'] = systolic > 0 && diastolic > 0 ? '${systolic.toStringAsFixed(0)}/${diastolic.toStringAsFixed(0)} mmHg' : '데이터 없음';
    results['oxygen'] = oxygen > 0 ? '${oxygen.toStringAsFixed(1)}%' : '데이터 없음';
    results['bloodSugar'] = bloodSugar > 0 ? '${bloodSugar.toStringAsFixed(1)} mg/dL' : '데이터 없음';
    results['water'] = water > 0 ? '${water.toStringAsFixed(1)} mL' : '데이터 없음';

    onUpdate(results);
  }


  /// 📌 Health Connect 설치 여부 및 이전 취소 여부 확인
  Future<void> checkAndInstallHealthConnect(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool dismissed = prefs.getBool(healthConnectDismissedKey) ?? false;

    try {
      bool isAvailable = await health.isHealthConnectAvailable();
      if (!isAvailable) {
        /*if (dismissed) {
          // 이전에 사용자가 취소했으면 요청 안 함
          print('사용자가 이전에 Health Connect 설치 요청을 거부했으므로 다시 요청하지 않음');
          return;
        }*/
        print('Health Connect 설치 필요');
        showHealthConnectDialog(context, prefs);
      } else {
        print('Health Connect가 이미 설치되어 있습니다.');
        fetchTodayHealthData();
        fetchMonthHealthData();
        fetchTotalHealthData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Health Connect 점검 중 오류 발생: $e'),
        ),
      );
    }
  }

  /// 📌 Google Health Connect 설치 다이얼로그 표시
  void showHealthConnectDialog(BuildContext context, SharedPreferences prefs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Google Health Connect 필요'),
        content: const Text(
          '건강정보 및 걸음 수집을 사용하려면 Google Health Connect가 필요합니다. 설치하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 사용자가 취소 시 상태 저장
              prefs.setBool(healthConnectDismissedKey, true);
              Navigator.of(context).pop();
              print('사용자가 Health Connect 설치를 거부함');
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              prefs.setBool(healthConnectDismissedKey, true);
              Navigator.of(context).pop();
              await health.installHealthConnect();
              print('사용자가 Health Connect 설치를 진행함');
            },
            child: const Text('설치'),
          ),
        ],
      ),
    );
  }
}
