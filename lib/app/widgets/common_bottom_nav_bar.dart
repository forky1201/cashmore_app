// lib/widgets/common_bottom_nav_bar.dart
import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CommonBottomNavBar extends GetView<MainController> {
  const CommonBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          backgroundColor:Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.updateIndex(index),  // 인덱스 업데이트
          items:  [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/home_icon.svg",
                color: controller.selectedIndex.value == 0 ? Colors.black : null
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/mission_icon.svg",
                color: controller.selectedIndex.value == 1 ? Colors.black : null
              ),
              label: '퀘스트',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/store_icon.svg",
                color: controller.selectedIndex.value == 2 ? Colors.black : null
              ),
              label: '스토어',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/point_icon.svg",
                color: controller.selectedIndex.value == 3 ? Colors.black : null
              ),
              label: '포인트관리',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/mypage_icon.svg",
                color: controller.selectedIndex.value == 4 ? Colors.black : null
              ),
              label: '마이페이지',
            ),
          ],
        ));
  }
}
