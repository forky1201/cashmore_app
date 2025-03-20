import 'dart:io';

import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/point/views/point_payment_view.dart';
import 'package:cashmore_app/app/module/point/views/point_return_view.dart';
import 'package:cashmore_app/app/module/point/views/point_wait_view.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointPage extends GetView<PointController> {
  final numberFormat = NumberFormat('#,###');

  PointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        splitLayout: false,
        height: 17,
        title: "",
        /*actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                //controller.movePage("/coupon");
                Get.snackbar('준비중',' 보유쿠폰은 준비중 입니다.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                //padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text(
                "보유쿠폰",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],*/
      ),
     body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
              children: [
                Text(
                  "포인트 관리",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),),
            
            _buildTabBar(controller), // 탭바
            const SizedBox(height: 20), // 기존 20에서 10으로 줄임
            _buildPointCard(), // 포인트 카드
            const SizedBox(height: 20), // 필요시 더 줄일 수 있음
            Expanded(
              child: TabBarView(
                 controller: controller.tabController,
                children: [
                  PointPaymentView(), // 지급 내역 탭
                  PointWaitView(), // 대기 탭
                  PointReturnView(), // 반려 탭
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

 Widget _buildTabBar(PointController controller) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller.tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 1.0, // 기본 선 두께
        labelPadding: const EdgeInsets.symmetric(vertical: 5.0),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Colors.black), // 하단 선 두께와 색상
          insets: EdgeInsets.symmetric(horizontal: 60.0), // 양쪽으로 여백 추가
        ),
        tabs: const [
          Tab(text: '지급'),
          Tab(text: '대기'),
          Tab(text: '반려'),
        ],
         onTap: (index) => controller.onTabSelected(index), // 탭 선택 이벤트 처리
      ),
    );
  }

  Widget _buildPointCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color.fromRGBO(39, 165, 136, 1.0)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
      
                  const SizedBox(width: 8),
                  const Text(
                    '보유 포인트',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Obx(() => Text(
                        '${numberFormat.format(controller.totalPoints.value)} P',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ],
              ),
              Platform.isAndroid ? const SizedBox(height: 16) : Container(),
              Platform.isAndroid ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildCardButton(
                      '출금 내역',
                      Colors.black,
                      Colors.white,
                      "/withdrawal",
                    ),
                  ),
                  const SizedBox(width: 8), // 버튼 사이에 간격 추가
                  Expanded(
                    child: _buildCardButton(
                      '포인트 출금',
                      Color.fromRGBO(39, 165, 136, 1.0),
                      Colors.white,
                      "/pointWithdrawal",
                    ),
                  ),
                ],
              ) : Container(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton(String text, Color color, Color fontColor, String page) {
    return ElevatedButton(
      onPressed: () {
        controller.movePage(page);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      ),
      child: Text(
        text,
        style: TextStyle(color: fontColor, fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}
