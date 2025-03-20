import 'package:cashmore_app/app/module/mission/controller/mission_detail_controller.dart';
import 'package:cashmore_app/app/module/mission/views/common_mission_header.dart';
import 'package:cashmore_app/app/module/mission/views/mission_common_info_warning_box.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class MissionDetailSpecialView extends GetView<MissionDetailController> {
  const MissionDetailSpecialView({super.key});

 @override
  Widget build(BuildContext context) {
    TextEditingController answerController = TextEditingController();

    void showAnswerPopup() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '공유링크 입력',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: answerController,
                    decoration: const InputDecoration(
                      hintText: '정답을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String answer = answerController.text;
                        RegExp urlRegex = RegExp(r'^(https?:\/\/)?' // 프로토콜 (http, https) 선택적
                            r'([\da-z\.-]+)\.([a-z\.]{2,6})' // 도메인 이름
                            r'([\/\w \.-]*)*\/?$' // 경로
                            );
                        if (urlRegex.hasMatch(answer)) {
                          // 정답 제출 처리 로직
                            Navigator.pop(context);
                            controller.missionEnd(controller.missionNumber.value);
                          //Navigator.pop(context); // 팝업 닫기
                        }else{
                           Get.snackbar(
                            '퀘스트',
                            '정답이 아닙니다. 다시 확인하시고 작성해주세요.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        '링크 제출',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: CommonAppBar(
            title: "퀘스트 상세",
            centerTitle: true,
            showReportButton: true,
            questNumber: controller.missionNumber.value,
            splitLayout: true,
            height: 70,
          ),
      body: Obx(() {
        final mission = controller.missionDetail.value;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Obx(() {
                return Column(
                  children: [
                    CommonMissionHeader(
                      missionTitle: "프리미엄 퀘스트",
                      missionPoints: controller.missionPoints.value,
                      avatarRadius: MediaQuery.of(context).size.width * 0.05,
                      missionNumber: controller.missionNumber.value,
                      missionType: controller.missionType.value,
                      path: "assets/images/mission_item_3.png",
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
                      Html(
                        data: controller.missionHeaderHtml.value,
                        style: {
                          "h2": Style(
                            fontSize: FontSize.large,
                            fontWeight: FontWeight.bold,
                          ),
                          "li": Style(
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.normal,
                            padding: HtmlPaddings.only(bottom: 8.0),
                          ),
                          "p": Style(
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.normal,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.grey, thickness: 0.5, height: 0.5),
              const SizedBox(height: 10),
              const CommonInfoWarningBox(),
              const SizedBox(height: 16),
              Obx(() {
                return controller.missionKeywordCopy.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: controller.missionKeywordCopy.value),
                                  );
                                  Get.snackbar(
                                    '키워드 복사됨',
                                    '키워드가 클립보드에 복사되었습니다.'
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('키워드 복사'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.missionStart(
                            controller.missionStartUrl.value,
                            controller.missionNumber.value,
                            controller.missionType.value,
                            controller.missionQuestBrowserType.value,
                          );
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
                        onPressed:(){
                            if(controller.missionClick.value){
                              showAnswerPopup(); // 다이어그램 팝업 호출
                            }else{
                              Get.snackbar(
                              '알림',
                              '미션을 시작해주세요.'
                              );
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          '링크 제출하기',
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
