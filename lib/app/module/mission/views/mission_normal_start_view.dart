import 'package:cashmore_app/app/module/mission/controller/mission_detail_controller.dart';
import 'package:cashmore_app/app/module/mission/views/mission_common_info_warning_box.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MissionNormalStartView extends GetView<MissionDetailController> {
  final String url;

  const MissionNormalStartView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // 로딩 애니메이션 시작
    controller.startLoadingAnimation();
    return Scaffold(
      appBar: const CommonAppBar(
        title: "",
        centerTitle: true,
        height: 45,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Html(
                data: controller.missionHeaderHtml.value,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 0.5,
              ),
              Expanded(
                child: controller.buildWebViewIf(controller.decode.value, url, context),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 0.5,
              ),
              const SizedBox(height: 10),
              const CommonInfoWarningBox(),
              const SizedBox(height: 16),
            ],
          ),
          Obx(() {
            if (controller.loadingProgress.value < 1.0) {
              return Center(
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 6.0,
                  percent: controller.loadingProgress.value,
                  center: Text(
                    '${(controller.loadingProgress.value * 100).toInt()}%',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  progressColor: Colors.blue,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
