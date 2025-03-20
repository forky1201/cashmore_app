import 'package:cashmore_app/app/module/mission/controller/mission_controller.dart';
import 'package:cashmore_app/app/module/mission/views/mission_answer_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_capture_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_normal_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_share_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_special_view.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionPage extends GetView<MissionController> {
  const MissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = _buildTabs();
    final views = _buildTabViews();

    return Scaffold(
      appBar: const CommonAppBar(
        title: "",
        height: 17,
      ),
      body: DefaultTabController(
        length: controller.tabLength, // 탭 개수를 동적으로 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTabBar(controller, tabs),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: views,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(MissionController controller, List<Tab> tabs) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller.tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 1.0,
        labelPadding: const EdgeInsets.symmetric(vertical: 5.0),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Colors.black),
          insets: EdgeInsets.symmetric(horizontal: 60.0),
        ),
        tabs: tabs,
        onTap: (index) => controller.onTabSelected(index),
      ),
    );
  }

  // 탭 목록을 normalYn 값에 따라 다르게 설정
  List<Tab> _buildTabs() {
    List<Tab> tabs = [];

    if (answerYn) {
      tabs.add(const Tab(text: '정답'));
    }
    if (shareYn) {
      tabs.add(const Tab(text: '공유'));
    }
    if (normalYn) {
      tabs.add(const Tab(text: '일반'));
    }
    if (spYn) {
      tabs.add(const Tab(text: '프리미엄'));
    }

    return tabs;
  }

  // TabView 구성
  List<Widget> _buildTabViews() {
    List<Widget> views = [];

    if (answerYn) {
      views.add(const MissionAnswerView());
    }
    if (shareYn) {
      views.add(const MissionShareView());
    }
    if (normalYn) {
      views.add(const MissionNormalView());
    }
    if (spYn) {
      views.add(const MissionSpecialView());
    }

    return views;
  }
}

