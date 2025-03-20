import 'package:cashmore_app/app/module/mypage/controller/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthView extends GetView<HealthController> {
  HealthView({super.key});

  // 현재 선택된 버튼 인덱스
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 📌 버튼 탭 메뉴
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton('오늘', 0),
                    _buildTabButton('이번달', 1),
                    _buildTabButton('전체', 2),
                  ],
                )),
          ),

          // 📌 선택된 탭에 따른 화면 표시
          Expanded(
            child: Obx(() {
              if (selectedIndex.value == 0) {
                return _buildTodayTab();
              } else if (selectedIndex.value == 1) {
                return _buildMonthTab();
              } else {
                return _buildTotalTab();
              }
            }),
          ),
        ],
      ),
    );
  }

  // 📌 공통 탭 버튼 위젯 (버튼 크기 고정)
  Widget _buildTabButton(String title, int index) {
    return SizedBox(
      width: 100, // 너비 고정
      height: 35, // 높이 고정
      child: OutlinedButton(
        onPressed: () => selectedIndex.value = index,
        style: OutlinedButton.styleFrom(
          backgroundColor: selectedIndex.value == index ? Colors.black : Colors.grey,
          side: selectedIndex.value == index ? const BorderSide(color: Colors.black) : const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.zero, // 내부 패딩 제거
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: selectedIndex.value == index ? Colors.white : Colors.white,
          ),
        ),
      ),
    );
  }


  // 📊 오늘 탭
  Widget _buildTodayTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => ListView(
            children: [
              _buildHealthItem('👣 걸음 수', controller.todaySteps.value),
              _buildHealthItem('❤️ 심박수', controller.todayHeartRate.value),
              _buildHealthItem('🌡 체온', controller.todayTemperature.value),
              _buildHealthItem('🫁 산소 포화도', controller.todayOxygen.value),
              _buildHealthItem('🩸 혈당', controller.todayBloodSugar.value),
              _buildHealthItem('💤 수면 시간', controller.todaySleep.value),
              _buildHealthItem('⚖️ 체중', controller.todayWeight.value),
              _buildHealthItem('📏 키', controller.todayHeight.value),
              _buildHealthItem('🩺 혈압', controller.todayBloodPressure.value),
              _buildHealthItem('💧 수분 섭취량', controller.todayWaterIntake.value),
              _buildHealthItem('🍎 소모 칼로리', controller.todayCalories.value),
            ],
          )),
    );
  }

  // 🗓️ 이번달 탭
  Widget _buildMonthTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => ListView(
            children: [
              _buildHealthItem('👣 총 걸음 수', controller.monthSteps.value),
              _buildHealthItem('❤️ 평균 심박수', controller.monthHeartRate.value),
              _buildHealthItem('💤 평균 수면 시간', controller.monthSleep.value),
              _buildHealthItem('🍎 총 소모 칼로리', controller.monthCalories.value),
              _buildHealthItem('⚖️ 평균 체중', controller.monthWeight.value),
              _buildHealthItem('📏 평균 키', controller.monthHeight.value),
              _buildHealthItem('🩺 평균 혈압', controller.monthBloodPressure.value),
              _buildHealthItem('💧 총 수분 섭취량', controller.monthWaterIntake.value),
            ],
          )),
    );
  }

  // 🌐 전체 탭
  Widget _buildTotalTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => ListView(
            children: [
              _buildHealthItem('👣 전체 걸음 수', controller.totalSteps.value),
              _buildHealthItem('❤️ 전체 심박수 평균', controller.totalHeartRate.value),
              _buildHealthItem('💤 전체 평균 수면 시간', controller.totalSleep.value),
              _buildHealthItem('🍎 전체 소모 칼로리', controller.totalCalories.value),
              _buildHealthItem('⚖️ 전체 평균 체중', controller.totalWeight.value),
              _buildHealthItem('📏 전체 평균 키', controller.totalHeight.value),
              _buildHealthItem('🩺 전체 평균 혈압', controller.totalBloodPressure.value),
              _buildHealthItem('💧 전체 수분 섭취량', controller.totalWaterIntake.value),
            ],
          )),
    );
  }

  // 공통 Health 아이템 위젯
  Widget _buildHealthItem(String title, String value) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
