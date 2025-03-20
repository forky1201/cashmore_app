import 'package:cashmore_app/app/module/mypage/controller/notice_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cashmore_app/app/extensions/datetime_extension.dart';
import 'package:get/get.dart';

class NoticePage extends GetView<NoticeController> {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "공지사항",
        centerTitle: true,
        height: 85,
        splitLayout: true,
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.refreshNotices, // 새로고침 호출
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 전체 패딩 설정
              child: ListView.builder(
                controller: controller.scrollController, // 컨트롤러에서 스크롤 감지
                physics: const AlwaysScrollableScrollPhysics(), // 리스트가 꽉 차지 않아도 스크롤 가능
                itemCount: controller.notices.length + 1, // 로딩 인디케이터를 위해 +1
                itemBuilder: (context, index) {
                  if (index == controller.notices.length) {
                    // 리스트의 끝에 로딩 인디케이터 표시
                    return controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }

                  final notice = controller.notices[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0), // 각 항목 위아래 공백
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0), // 양옆 공백 추가
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              notice.elapsed_days == 0
                                  ? Text(
                                      '오늘',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    )
                                  : Text(
                                      '${notice.elapsed_days}일 전',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                              const SizedBox(height: 4),
                              Text(
                                notice.title!, // 공지사항 제목
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () {
                            // 항목 선택 시 동작 정의
                            controller.moveToNoticeDetail(notice.id);
                          },
                        ),
                        const Divider(thickness: 0.3,), // 항목 간의 구분선
                      ],
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}
