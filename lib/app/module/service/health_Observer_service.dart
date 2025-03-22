import 'dart:async';
import 'package:health/health.dart';
import 'package:flutter/services.dart';

class HealthObserverService {
  static const MethodChannel _channel = MethodChannel('com.getit.getitmoney.health_observer');
  static const EventChannel _eventChannel = EventChannel('com.getit.getitmoney.health_events');

  static Future<void> startObserver() async {
    await _channel.invokeMethod('startObserver');
  }

  static Timer? _debounceTimer;
  static DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  static final Health _health = Health();

  /// 실시간 업데이트 리스너
  static void listenToUpdates(Function(int steps) onStepUpdate) {
    _eventChannel.receiveBroadcastStream().listen((event) {
      print("🍎 [Observer] 걸음수 변경 이벤트 감지됨");

      final now = DateTime.now();
      if (now.difference(_lastUpdate) < Duration(seconds: 5)) {
        print("⏱️ 요청 너무 잦음, 무시");
        return;
      }
      _lastUpdate = now;

      _debounceTimer?.cancel();
      _debounceTimer = Timer(Duration(seconds: 1), () async {
        final steps = await _getStepsFromIPhoneOnly();
        if (steps != null) {
          onStepUpdate(steps);
        }
      });
    });
  }

  /// 앱 초기 실행 시 수동 초기화
  static Future<void> initStepFromHealth(Function(int steps) onStepUpdate) async {
    final steps = await _getStepsFromIPhoneOnly();
    if (steps != null) {
      onStepUpdate(steps);
    }
  }

  /// 아이폰에서 측정된 걸음수만 합산
 static Future<int?> _getStepsFromIPhoneOnly() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    bool authorized = await _health.requestAuthorization([HealthDataType.STEPS]);
    if (!authorized) {
      print("🚫 HealthKit 권한 없음");
      return null;
    }

    try {
      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: start,
        endTime: now,
      );

      var totalSteps = data.where((e) => e.sourceName.toLowerCase().contains("iphone") && e.value is NumericHealthValue).fold<int>(0, (sum, e) {
        final numericValue = (e.value as NumericHealthValue).numericValue;
        return sum + (numericValue?.toInt() ?? 0);
      });


      print("📱 iPhone 걸음수 합계: $totalSteps");
      return totalSteps;
    } catch (e) {
      print("🚨 걸음 수 가져오기 오류: $e");
      return null;
    }
  }
}
