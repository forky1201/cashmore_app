import 'package:cashmore_app/app/module/mypage/controller/recommendation_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RecommendationView extends GetView<RecommendationController> {
  const RecommendationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "추천인 목록",
        centerTitle: true,
        height: 45,
        splitLayout: true,
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(8.0), // 첫 번째 항목의 패딩
              child: InkWell(
                child: _buildBoard(),
                onTap: () {
                  controller.moveToNoticeDetail(23);
                },
              )),
          SizedBox(
            height: 15,
          ),
          _buildUserNameSection(), // 사용자 이름 표시 섹션
          Expanded(
            child: Obx(() => RefreshIndicator(
                  onRefresh: controller.refreshRecommenders, // 새로고침 호출
                  child: controller.recommenders.isEmpty
                      ? Center(
                          child: Text(
                            '추천인 목록이 없습니다.', // 리스트가 없을 때 표시할 문구
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: ListView.builder(
                            controller: controller.scrollController, // 컨트롤러에서 스크롤 감지
                            physics: const AlwaysScrollableScrollPhysics(), // 리스트가 꽉 차지 않아도 스크롤 가능
                            itemCount: controller.recommenders.length + 1, // 로딩 인디케이터를 위해 +1
                            itemBuilder: (context, index) {
                              if (index == controller.recommenders.length) {
                                // 리스트의 끝에 로딩 인디케이터 표시
                                return controller.isLoading.value ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
                              }

                              final recommender = controller.recommenders[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                      leading: SvgPicture.asset(
                                        'assets/icons/recomm_icon.svg', // 추천인 아이콘
                                        width: 24,
                                        height: 24,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        recommender.user_name.toString(), // 추천인 이름
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: recommender.my_recommender != null
                                          ? Text(
                                              recommender.my_recommender.toString(), // 추천인 이메일
                                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                                            )
                                          : null,
                                      onTap: () {
                                        // 항목 선택 시 동작 정의
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                )),
          ),
        ],
      ),
    );
  }

  // 사용자 이름 표시 섹션
  Widget _buildUserNameSection() {
    return GestureDetector(
      onTap: () {
        // 클립보드에 복사
        Clipboard.setData(ClipboardData(text: controller.my_recommender.value));
        Get.snackbar(
          '복사 완료',
          '추천인 코드가 클립보드에 복사되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      },
      child: Container(
        color: Colors.grey[200], // 배경 색상 설정
        padding: const EdgeInsets.all(16.0), // 패딩 설정
        width: double.infinity, // 전체 너비 차지
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "추천인 코드 ${controller.my_recommender.value} ",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.content_copy, size: 18, color: Colors.black), // 복사 아이콘 표시
              ],
            )),
      ),
    );
  }

  // 게시판 (광고 메시지)
  Widget _buildBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // 배너 안의 여백 설정
      decoration: BoxDecoration(
        color: Colors.grey[800], // 배경 색상
        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "광고" 텍스트 배경
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
            decoration: BoxDecoration(
              color: Colors.green[300], // "광고" 배경 색상
              borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
            ),
            child: const Text(
              '안내',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8), // "광고"와 텍스트 간의 간격
          // 안내 문구 (Controller에서 메시지 가져오기)
          Expanded(
            child: Text(
              controller.boardMessage,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
