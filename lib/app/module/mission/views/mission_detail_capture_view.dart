import 'package:cashmore_app/app/module/mission/controller/mission_detail_controller.dart';
import 'package:cashmore_app/app/module/mission/views/common_mission_header.dart';
import 'package:cashmore_app/app/module/mission/views/mission_common_info_warning_box.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionDetailCaptureView extends GetView<MissionDetailController> {
  const MissionDetailCaptureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // Set your desired height
        child: Obx(() {
          return CommonAppBar(
            title: "퀘스트 상세",
            centerTitle: true,
            showReportButton: true,
            questNumber: controller.missionNumber.value,
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // 로딩 중일 때 로딩바 표시
          return const Center(child: CircularProgressIndicator());
        } else {
          // 로딩이 완료되면 실제 내용을 표시
          return Column(
            children: [
              // 공통화된 미션 제목 및 포인트 표시
              Obx(() {
                return Column(
                  children: [
                    CommonMissionHeader(
                      missionTitle: "캡처 퀘스트",
                      missionPoints: controller.missionPoints.value,
                      avatarRadius: MediaQuery.of(context).size.width * 0.05,
                      missionNumber: controller.missionNumber.value,
                      missionType: controller.missionType.value,
                      path: "assets/images/mission_item_4.png",
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 0.5,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬 적용
                        child: Text(
                          '미션 완수 방법',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬 적용
                        child: Text(
                          controller.missionDescription.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬 적용
                        child: Text(
                          '🔍 미션 질문',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 미션 질문이 있을 때만 보이게 처리
                      if (controller.missionInstruction.value.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft, // 왼쪽 정렬 적용
                            child: Text(
                              controller.missionInstruction.value,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 0.5,
              ),
              const SizedBox(height: 10),
              const CommonInfoWarningBox(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 미션 시작하기 로직
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          '퀘스트 시작하기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 캡처 제출하기 로직
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          '캡처 제출하기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }
      }),
    );
  }
}
