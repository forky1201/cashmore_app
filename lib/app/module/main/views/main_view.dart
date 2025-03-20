// lib/pages/main_page.dart
import 'package:cashmore_app/app/module/home/controller/home_controller.dart';
import 'package:cashmore_app/app/module/home/views/home_view.dart';
import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/app/module/mission/controller/mission_controller.dart';
import 'package:cashmore_app/app/module/mission/views/mission_view.dart';
import 'package:cashmore_app/app/module/mypage/controller/health_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/mypage_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/notice_controller.dart';
import 'package:cashmore_app/app/module/mypage/views/mypage2_view.dart';
import 'package:cashmore_app/app/module/mypage/views/mypage_view.dart';
import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/point/views/point_view.dart';
import 'package:cashmore_app/app/module/store/controller/store_controller.dart';
import 'package:cashmore_app/app/module/store/views/store_view.dart';

import 'package:cashmore_app/app/widgets/common_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MainController를 이 페이지에서 접근할 수 있도록 초기화
    final MainController controller = Get.put(MainController());

    final HomeController homeController = Get.put(HomeController());
    final PointController pointController = Get.put(PointController());
    final MissionController missionController = Get.put(MissionController());
    final MyPageController myPageController = Get.put(MyPageController());
    final StoreController storeController = Get.put(StoreController());
    final NoticeController noticeController = Get.put(NoticeController());
    final HealthController healthController = Get.put(HealthController());

    // 페이지 리스트
    final _pages = [
      HomePage(),
      const MissionPage(),
      StoreView(),
      PointPage(),
      const MyPage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        // 뒤로 가기 버튼 동작
        if (controller.selectedIndex.value != 0) {
          controller.updateIndex(0); // 홈으로 이동
          return false; // 앱 종료 방지
        }
        return true; // 앱 종료 허용
      },
      child: Scaffold(
        body: Obx(() => IndexedStack(
              index: controller.selectedIndex.value,
              children: _pages,
            )),
        bottomNavigationBar: const CommonBottomNavBar(),
      ),
    );
  }
}
