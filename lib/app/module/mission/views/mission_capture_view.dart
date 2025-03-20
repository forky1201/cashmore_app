import 'package:cashmore_app/app/module/mission/views/mission_banner.dart';
import 'package:cashmore_app/app/module/mission/controller/mission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionCaptureView extends GetView<MissionController> {
  const MissionCaptureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
      children: [
        Expanded(
          child: Obx(() {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.refreshCaptureMissions(); // 새로고침 호출
              },
              child: controller.isLoadingCapture.value && controller.captureMissions.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : controller.captureMissions.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(), // 빈 리스트에서도 스크롤 가능하게 함
                          children: const [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 200.0),
                                child: Text('미션이 없습니다.'),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하게 만듦
                          controller: controller.captureScrollController, // 스크롤 컨트롤러
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: controller.captureMissions.length + 1, // 로딩 인디케이터를 위해 +1
                          itemBuilder: (context, index) {
                            if (index == controller.captureMissions.length) {
                              // 리스트의 끝에 로딩 인디케이터 표시
                              return controller.isLoadingMoreCapture.value
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink();
                            }

                            final mission = controller.captureMissions[index];
                            return GestureDetector(
                                onTap: () {
                                  // 리스트 항목을 클릭하면 미션 상세 페이지로 이동
                                  //controller.moveToUrl("/mission_capture", mission.quest_number);
                                },
                                child: _buildMissionListItem(
                                  "캡처 퀘스트",
                                  mission.quest_use_price.toString(),
                                  mission.boost_price.toString(),
                                  controller.getButtonText(mission.quest_total_count!, mission.quest_ing_count!), // 컨트롤러에서 상태 가져오기
                                ),
                              );
                          },
                        ),
            );
          }),
        ),
        const MissionBanner(), // 공통 배너 위젯 사용
      ],
    )
    );
  }

  // 미션 리스트 항목 구현
  Widget _buildMissionListItem(String title, String points, String boostPoint, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // 아이콘
          Image.asset(
            'assets/images/mission_item_4.png', // PNG 파일 경로
            width: 48, // 적절한 크기 설정
            height: 48,
            fit: BoxFit.cover, // 이미지 크기 조정
          ),
          const SizedBox(width: 16),
          // 텍스트 섹션
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "$points 포인트",
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      boostPoint != "0"
                          ? TextSpan(
                              text: " + $boostPoint ",
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            )
                          : const TextSpan(), 
                      const TextSpan(
                        text: ' 받기',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 상태 버튼
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: status == '곧 마감되요!' ? Colors.pinkAccent : Colors.grey, // 상태에 따른 색상 변경
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status, // 상태 텍스트 (진행중, 마감임박, 완료 등)
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
