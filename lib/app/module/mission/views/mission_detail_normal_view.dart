import 'package:cashmore_app/app/module/mission/controller/mission_detail_controller.dart';
import 'package:cashmore_app/app/module/mission/views/common_mission_header.dart';
import 'package:cashmore_app/app/module/mission/views/mission_common_info_warning_box.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class MissionDetailNormalView extends GetView<MissionDetailController> {
  const MissionDetailNormalView({super.key});

  @override
  Widget build(BuildContext context) {
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Obx(() {
                return Column(
                  children: [
                    CommonMissionHeader(
                      missionTitle: "일반 퀘스트",
                      missionPoints: controller.missionPoints.value,
                      avatarRadius: MediaQuery.of(context).size.width * 0.05,
                      missionNumber: controller.missionNumber.value,
                      missionType: controller.missionType.value,
                      path: "assets/images/mission_item_2.png",
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
                      // Wrapping the Html widget in a Container to add border radius
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Background color for the box
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        padding: const EdgeInsets.all(16.0), // Padding inside the box
                        child: Html(
                          data: controller.missionHeaderHtml.value,
                          style: {
                            "h2": Style(
                              fontSize: FontSize.large,
                              fontWeight: FontWeight.bold,
                            ),
                            "li": Style(
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.normal,
                              //padding: HtmlPaddings.only(bottom: 8.0), // Adds space between list items
                            ),
                            "p": Style(
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.normal,
                            ),
                          },
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
                      child: OutlinedButton(
                        onPressed: () {
                          // Controller's WebView popup method call
                          controller.missionStart(controller.missionUrl.value, controller.missionNumber.value,  controller.missionType.value, "");
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
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
