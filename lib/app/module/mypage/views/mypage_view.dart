import 'dart:io';

import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/app/module/mypage/views/health_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cashmore_app/app/module/mypage/controller/mypage_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/util/dialog_utils.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 탭 목록 설정
    final List<Tab> tabs = [
      const Tab(text: '기본설정'),
      if (!Platform.isAndroid) const Tab(text: '건강데이터'),
    ];

    // ✅ 탭 뷰 목록 설정
    final List<Widget> tabViews = [
      _buildSettingsTab(),
       if (!Platform.isAndroid) HealthView(),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CommonAppBar(
          title: "",
          height: 17,
        ),
        body: Column(
          children: [
            // 기존 상단 유저 정보
            Obx(() {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        controller.userName.value,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        controller.userEmail.value,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // 탭바 추가
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: Colors.black), // 밑줄 두께와 색상
                insets: EdgeInsets.symmetric(horizontal: 0), // 탭 전체 크기만큼 밑줄
              ),
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(
                children:
                    // 탭 1 (기본설정): 기존 MyPage 내용 포함

                    // 탭 2 (건강데이터): 빈 화면
                    /*const Center(
                    child: Text(
                      '건강데이터 화면입니다.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),*/
                    // 건강데이터 (탭2)
                    //HealthView(),
                    tabViews,
              ),
            ),
            // 문의하기 배너
            GestureDetector(
              onTap: () {
                final mainController = Get.find<MainController>();
                mainController.showInquiryPopup(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/images/mypageBanner2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 기본설정 탭
  /// 기본설정 탭 - 스크롤 가능하게 수정
  Widget _buildSettingsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16), // 여백 추가
                ListView(
                  shrinkWrap: true, // 내용만큼만 높이 차지
                  physics: const NeverScrollableScrollPhysics(), // 외부 스크롤만 사용
                  children: [
                    // 기존 설정 리스트
                    SettingsList(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      contentPadding: EdgeInsets.zero,
                      lightTheme: const SettingsThemeData(
                        settingsListBackground: Colors.white,
                      ),
                      sections: [
                        SettingsSection(
                          tiles: [
                            if(Platform.isAndroid)
                            SettingsTile.switchTile(
                              title: const Text('걸음수 수집', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              //description: Text("포그라운드 여부"),
                              leading: const Icon(LucideIcons.personStanding),
                              onToggle: (value) {
                                controller.toggleStepCountCollection(value);
                              },
                              initialValue: controller.isStepCountEnabled.value,
                            ),
                            SettingsTile.navigation(
                              title: const Text('내 정보', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.user),
                              onPressed: (context) => controller.movePage('/myInfo'),
                            ),
                            SettingsTile.navigation(
                              title: const Text('추천인 목록', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.users),
                              onPressed: (context) => controller.movePage('/recommen'),
                            ),
                            SettingsTile.navigation(
                              title: const Text('안내 · 이벤트', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.info),
                              onPressed: (context) => controller.movePage('/notice'),
                            ),
                            SettingsTile.navigation(
                              title: const Text('로그인정보', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.lock),
                              onPressed: (context) => controller.movePage('/settings'),
                            ),
                            SettingsTile.navigation(
                              title: const Text('약관', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.fileText),
                              onPressed: (context) {
                                DialogUtils.showWebViewDialog(title: '약관', url: 'https://getitmoney.co.kr/api/terms_of_use');
                              },
                            ),
                            SettingsTile.navigation(
                              title: const Text('개인정보 처리방침', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.fileText),
                              onPressed: (context) {
                                DialogUtils.showWebViewDialog(title: '개인정보 처리방침', url: 'https://getitmoney.co.kr/api/privacy_policy');
                              },
                            ),
                            SettingsTile.navigation(
                              title: const Text('사업자 정보', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.briefcase),
                              onPressed: (context) => DialogUtils.showInfoDialog(),
                            ),
                            SettingsTile(
                              title: const Text('앱 정보', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16)),
                              leading: const Icon(LucideIcons.info),
                              trailing: Text(controller.version.value, style: const TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16), // 하단 여백
              ],
            ),
          ),
        );
      }
    });
  }
}
