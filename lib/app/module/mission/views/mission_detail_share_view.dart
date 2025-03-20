import 'package:cashmore_app/app/module/mission/controller/mission_detail_controller.dart';
import 'package:cashmore_app/app/module/mission/views/common_mission_header.dart';
import 'package:cashmore_app/app/module/mission/views/mission_common_info_warning_box.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

class MissionDetailShareView extends GetView<MissionDetailController> {
  const MissionDetailShareView({super.key});

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
                      missionTitle: "공유 퀘스트",
                      missionPoints: controller.missionPoints.value,
                      avatarRadius: MediaQuery.of(context).size.width * 0.05,
                      missionNumber: controller.missionNumber.value,
                      missionType: controller.missionType.value,
                      path: "assets/images/mission_item_5.png",
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
                      HtmlWidget(
                        controller.missionHeaderHtml.value,
                        /*customStylesBuilder: (element) {
                          if (element.localName == 'img') {
                            return {'width': '100%'};
                          }
                          return null;
                        },*/
                      ),
                      const SizedBox(height: 10),
                      controller.fileUpload1 != null && controller.fileUpload1.isNotEmpty
                          ? Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: Image.network(
                                  domain + controller.fileUpload1.value.replaceFirst('/var/www/getitmoney', ''),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 10),
                      controller.fileUpload2 != null && controller.fileUpload2.isNotEmpty
                          ? Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: Image.network(
                                  domain + controller.fileUpload2.value.replaceFirst('/var/www/getitmoney', ''),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 10),
                      controller.fileUpload3 != null && controller.fileUpload3.isNotEmpty
                          ? Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: Image.network(
                                  domain + controller.fileUpload3.value.replaceFirst('/var/www/getitmoney', ''),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 10),
                      controller.fileUpload4 != null && controller.fileUpload4.isNotEmpty
                          ? Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: Image.network(
                                  domain + controller.fileUpload4.value.replaceFirst('/var/www/getitmoney', ''),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 10),
                      controller.fileUpload5 != null && controller.fileUpload5.isNotEmpty
                          ? Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: Image.network(
                                  domain + controller.fileUpload5.value.replaceFirst('/var/www/getitmoney', ''),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.grey, thickness: 0.5, height: 0.5),
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
                                  Clipboard.setData(
                                    ClipboardData(text: controller.missionKeyword.value),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.missionStart(
                            mission!.quest_start_url.toString(),
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
