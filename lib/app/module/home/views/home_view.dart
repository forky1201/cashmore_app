// lib/pages/home_page.dart
import 'dart:io';

import 'package:cashmore_app/app/module/home/controller/home_controller.dart';
import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/app/module/mission/views/mission_view.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends GetView<HomeController> {
  // 숫자 포맷 설정: 천 단위 쉼표 추가
  final numberFormat = NumberFormat('#,###');

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "겟잇머니",
        //actions: [Padding(padding: const EdgeInsets.only(right: 16), child: Text(controller.name.value))],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        //padding: const EdgeInsets.all(16.0),
        children: [
          // _buildBoard(),
          // const SizedBox(height: 16),
          // _buildTotalPointsCard(context), // 보유 포인트 카드
          // const SizedBox(height: 16),
          // _buildAccumulatedPointsCard(), // 현재까지 지급된 포인트 카드

          Container(
            padding: const EdgeInsets.all(8.0), // 첫 번째 항목의 패딩
            color: sdPrimaryColor,
            child: _buildBoard(context),
          ),
          Container(
              padding: const EdgeInsets.all(8.0), // 첫 번째 항목의 패딩
              color: sdPrimaryColor,
              child: _buildHealthKitBanner()),
          //만보기부분
          Container(
              padding: const EdgeInsets.all(8.0), // 첫 번째 항목의 패딩
              color: sdPrimaryColor,
              child: _buildStepCounterSection()),

          Container(
              padding: const EdgeInsets.all(8.0), // 첫 번째 항목의 패딩
              color: sdPrimaryColor,
              child: _buildRewardButtons(controller)),

          Container(
            child: Stack(
              children: [
                // 상단 절반 배경색
                Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1, // 상단 절반
                        child: Container(color: sdPrimaryColor),
                      ),
                      Expanded(
                        flex: 1, // 하단 절반
                        child: Container(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // 콘텐츠 레이아웃
                Container(
                  padding: const EdgeInsets.all(8.0), // 두 번째 항목의 패딩
                  child: _buildTotalPointsCard(context),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0), // 세 번째 항목의 패딩
            child: _buildAccumulatedPointsCard(),
          ),

          /*const SizedBox(height: 16),
          _buildSectionTitle('지금, 받을 수 있는 포인트'),
          const SizedBox(height: 16),
          HomeMenuCard(
            imagePath: 'assets/images/rock_paper_scissors.png', // 이미지 경로 설정
            title: '가위, 바위, 보',
            description: '최대 2000포인트 받기',
            onTap: () {
              print('가위, 바위, 보 클릭');
            },
          ),*/
          Container(
            padding: const EdgeInsets.all(8.0), // 세 번째 항목의 패딩
            child: _buildSectionTitle('지금, 받을 수 있는 포인트'),
          ),
          Obx(
            () => Container(
              padding: const EdgeInsets.all(8.0), // 세 번째 항목의 패딩
              child: HomeMenuCard(
                imagePath: 'assets/images/invite_friend.png', // 친구 초대 이미지
                title: '친구 초대하기',
                description: '현재 ${numberFormat.format(controller.invitedFriendsCount.value)}명 초대 완료',
                onTap: () {
                  controller.inviteFriend(); // 친구 초대 (테스트용)
                },
              ),
            ),
          ),

          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(8.0), // 세 번째 항목의 패딩
            child: HomeMenuCard(
              imagePath: 'assets/images/starbucks.png',
              title: '스타벅스 무료 마시기',
              description: '아이스 아메리카노',
              onTap: () {
                controller.inviteCoupon();
              },
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHealthKitBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, color: Colors.red),
          const SizedBox(width: 8),
          Obx(() => Text(
                controller.pedometerStatus.value,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              )),
        ],
      ),
    );
  }

  // 기존 _buildBoard 함수 수정
  Widget _buildBoard(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            // 현재 메시지에 해당하는 noticeId를 가져옴
            int noticeId = controller.currentNoticeId.value;
            // 상세 보드 페이지로 이동 (경로와 인자 전달은 프로젝트에 맞게 조정)
            //Get.toNamed('/noticeDetail', arguments: {'noticeId': noticeId});
            //print(noticeId);
            if (noticeId == 2) {
              Get.toNamed('/notice_detail', arguments: 23);
            } else if (noticeId == 1) {
              final mainController = Get.find<MainController>();
              mainController.showInquiryPopup(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Text(
                    '광고',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.boardMessage.value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // 보유 포인트 카드
  Widget _buildTotalPointsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 인사말 및 사용자 이름과 포인트
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      '안녕하세요!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          '${controller.name.value}님',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/point_icon.png',
                      height: 50,
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          '${numberFormat.format(controller.points.value)} P',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 진행바 및 출금 가능 포인트
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Obx(() => LinearProgressIndicator(
                        value: (controller.availablePoints.value >= 11000 ? 1.0 : controller.availablePoints.value / 11000),
                        color: const Color.fromRGBO(39, 165, 136, 1),
                        backgroundColor: Colors.grey[300],
                      )),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '포인트 출금 가능',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '11,000P',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 포인트 모으기 버튼
            ElevatedButton(
              onPressed: () async {
                final mainController = Get.find<MainController>();
                mainController.updateIndex(1);
                await mainController.navigateTo(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '포인트 모으러 가자!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    //fontWeight: FontWeight.w600,
                    color: sdPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 현재까지 지급된 포인트 카드
  Widget _buildAccumulatedPointsCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '현재까지 지급된 포인트',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return TweenAnimationBuilder<int>(
                    duration: const Duration(milliseconds: 2200), // 애니메이션 지속 시간
                    tween: IntTween(
                      begin: 0,
                      end: controller.accumulatedPoints.value,
                    ),
                    builder: (context, value, child) {
                      return Text(
                        '${numberFormat.format(value)} P',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
            Image.asset(
              'assets/images/point_bag.png', // 포인트 주머니 이미지 (경로 지정)
              width: 60, // 이미지 너비
              height: 60, // 이미지 높이
              fit: BoxFit.contain, // 이미지 크기 맞춤
            ),
          ],
        ),
      ),
    );
  }

  // 섹션 타이틀 위젯
  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStepCounterSection() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: SvgPicture.asset('assets/icons/work.svg'),
              ),
              Column(
                children: [
                  Text(
                    "오늘의 걸음 횟수",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Obx(() => Text(
                            "${numberFormat.format(controller.stepCount.value)}",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(width: 10),
                      Text("걸음", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 8),

          // 프로그레스 바 (걸음 수에 따라 채워짐)
          Obx(() => ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearProgressIndicator(
                  color: const Color.fromRGBO(39, 165, 136, 1), // 진행 색상
                  backgroundColor: Colors.white, // 배경색
                  value: (controller.stepCount.value >= 5000)
                      ? 1.0 // 5000 이상이면 꽉 채우기
                      : controller.stepCount.value / 5000, // 걸음 수 비율 적용
                  minHeight: 10,
                ),
              )),
          SizedBox(height: 8),

          // 5000 걸음 목표 안내
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("5천 걸음도 걸을 수 있죠!", style: TextStyle(fontSize: 14)),
              Text("5,000", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardButtons(HomeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRewardButton(500, controller.step500, controller.point500),
            _buildRewardButton(1000, controller.step1000, controller.point1000),
            _buildRewardButton(2000, controller.step2000, controller.point2000),
            _buildRewardButton(3000, controller.step3000, controller.point3000),
            _buildRewardButton(5000, controller.step5000, controller.point5000),
            _buildRewardButton(10000, controller.step10000, controller.point10000),
          ],
        ),
      ),
    );
  }

  /// 📌 **개별 보상 버튼 위젯**
  Widget _buildRewardButton(int step, RxString stepStatus, RxInt point) {
    return Obx(() {
      bool isReceived = stepStatus.value == "Y"; // Y면 비활성화, N이면 활성화
      int currentSteps = controller.stepCount.value; // 현재 걸음 수 가져오기

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: isReceived ? Colors.grey[200] : Colors.white,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${numberFormat.format(step)}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text("걸음", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              // 적립받기 버튼
              GestureDetector(
                onTap: isReceived
                    ? null
                    : () {
                        if (currentSteps < step) {
                          // 걸음 수 목표 도달 못했을 경우
                          Get.snackbar(
                            "알림",
                            "아직 ${numberFormat.format(step)} 걸음을 달성하지 못했습니다!",
                            snackPosition: SnackPosition.BOTTOM,
                            //backgroundColor: Colors.redAccent,
                            colorText: Colors.black,
                          );
                        } else {
                          // 목표 도달 시 적립 실행
                          print("$step 걸음 적립 요청");
                          controller.stepPointAdd(step, point.value);
                        }
                        //controller.stepPointAdd(step, point.value);
                      },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReceived ? Colors.grey : Color.fromRGBO(39, 165, 136, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isReceived ? "✔" : "보상받기",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// 홈 메뉴 카드 위젯
class HomeMenuCard extends StatelessWidget {
  final String imagePath; // 이미지 경로를 매개변수로 받도록 설정
  final String title;
  final String description;
  final VoidCallback onTap;

  HomeMenuCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // 카드 모서리를 둥글게 설정
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          decoration: BoxDecoration(
            //color: backgroundColor,  // 카드 배경색 설정
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: AssetImage(imagePath), // 배경 이미지 경로
              fit: BoxFit.cover, // 이미지가 전체 배경을 덮도록 설정
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 좌측 텍스트와 설명 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 타이틀 텍스트
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 색상
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 서브 타이틀 텍스트
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 우측 화살표 아이콘
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
