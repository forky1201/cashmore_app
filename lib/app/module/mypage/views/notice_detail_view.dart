import 'package:cashmore_app/app/module/mypage/controller/notice_detail_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cashmore_app/app/extensions/datetime_extension.dart';
import 'package:get/get.dart';

class NoticeDetailView extends GetView<NoticeDetailController> {
  const NoticeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "공지사항", centerTitle: true, height: 85, splitLayout: true,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final notice = controller.noticeDetail.value;
        if (notice == null) {
          return const Center(child: Text("공지사항을 불러올 수 없습니다."));
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title ?? '제목 없음',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${notice.regdate?.format()}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    notice.content ?? '상세 내용이 없습니다.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
