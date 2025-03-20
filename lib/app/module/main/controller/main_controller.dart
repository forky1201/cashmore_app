import 'package:cashmore_app/app/module/home/controller/home_controller.dart';
import 'package:cashmore_app/app/module/mission/controller/mission_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/mypage_controller.dart';
import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/store/controller/store_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/repository/mission_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends BaseController {
  final appService = Get.find<AppService>();
  final TextEditingController reportTextController = TextEditingController();

  // 선택된 하단 네비게이션 바 인덱스
  var selectedIndex = 0.obs;

  // 선택된 페이지 업데이트
  void updateIndex(int index) async {
    selectedIndex.value = index;

    final homeController = Get.find<HomeController>();
    homeController.pointTimer.cancel(); // 포인트 타이머 해제

    if (index == 1) {
      // 미션 탭이 선택될 때만 미션 데이터를 불러옴
      final missionController = Get.find<MissionController>();
      if (missionController.missions.isEmpty) {
        missionController.fetchMissions(); // 미션 데이터 불러오기
      }
      if (missionController.shareMissions.isEmpty) {
        missionController.fetchShareMissions(); // 미션 데이터 불러오기
      }
      if (missionController.normalMissions.isEmpty) {
        missionController.fetchNormalMissions(); // 미션 데이터 불러오기
      }
      if (missionController.specialMissions.isEmpty) {
        missionController.fetchSpecialMissions(); // 미션 데이터 불러오기
      }
      if (missionController.captureMissions.isEmpty) {
        missionController.fetchCaptureMissions(); // 미션 데이터 불러오기
      }
    } else if (index == 2) {
      final storeController = Get.find<StoreController>();
      storeController.userInfo();
    } else if (index == 3) {
      final pointController = Get.find<PointController>();
      pointController.userInfo();
      pointController.refreshPayments();
    } else if (index == 0) {
      //final myPageController = Get.find<MyPageController>();
      await homeController.userInfo();
      await homeController.totalPoint(); // 애니메이션 트리거
      homeController.startTotalPointUpdate();

    }
  }

  // 페이지 이동 메서드
  Future<void> navigateTo(int index) async {
    selectedIndex.value = index;
  }

  void openReportModal(BuildContext context, String quest_number) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => _buildReportModal(context, quest_number),
    );
  }

  Widget _buildReportModal(BuildContext context, String quest_number) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // 키보드 높이 고려
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '신고하기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: reportTextController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '신고할 내용을 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.back(); // 모달 닫기
                },
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await saveReport(quest_number, context);
                  } finally {
                    // 비동기 작업 상태와 상관없이 모달 닫기
                    if (Get.isBottomSheetOpen ?? false) {
                      Get.back();
                    }
                  }
                },
                child: const Text('제출'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveReport(String quest_number, BuildContext context) async {
    final reportText = reportTextController.text.trim();
    if (reportText.isNotEmpty) {
      // 신고 내용을 저장하는 로직 구현
      MissionRepsitory missionRepsitory = MissionRepsitory();

      Map<String, dynamic> requestBody = {
        "user_id": appService.userId,
        "contents": reportText,
        "quest_number": quest_number,
      };

      try {
        await missionRepsitory.missionReport(requestBody).then((response) {
          // 성공 시 처리
          Get.snackbar('신고 완료', '신고 내용이 성공적으로 저장되었습니다.');
          reportTextController.clear(); // 텍스트 초기화
          Navigator.of(context).pop(false); // 취소
        });
      } catch (e) {
        // 에러 발생 시 처리
        Get.snackbar('오류', '신고를 처리하는 중 문제가 발생했습니다.');
        print('Error in saveReport: $e');
        throw e; // 에러를 다시 던져 호출자에서 처리
      }
    } else {
      Get.snackbar('신고 실패', '신고 내용을 입력하세요.');
    }
  }

  Future<void> saveHide(String quest_number, String quest_type) async {
    Get.dialog(
      _buildCustomDialog(
        title: "퀘스트 숨기기",
        message: "숨김 처리하시겠습니까?",
        onConfirm: () async {
          MissionRepsitory missionRepsitory = MissionRepsitory();

          Map<String, dynamic> requestBody = {
            "user_id": appService.userId,
            "quest_type": quest_type,
            "quest_complete": "N",
            "quest_number": quest_number,
          };

          try {
            await missionRepsitory.missionHide(requestBody).then((response) async {
              Get.snackbar('숨김 완료', '숨김 처리가 성공적으로 저장되었습니다.');
              Get.back(closeOverlays: true, result: true);
            });
          } catch (e) {
            // 에러 발생 시 처리
            //Get.snackbar('오류', '숨김 처리 중 문제가 발생했습니다. 다시 시도해주세요.');
            print('Error in saveHide: $e');
          }
        },
      ),
    );
  }

// 커스텀 다이얼로그 위젯
  Widget _buildCustomDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDialogButton(
                  label: "취소",
                  backgroundColor: Colors.grey[300]!,
                  textColor: Colors.black87,
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 10),
                _buildDialogButton(
                  label: "확인",
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: onConfirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 위젯
  Widget _buildDialogButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        //height: 50, // 버튼 높이 설정
        //width: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

   Future<void> showInquiryPopup(BuildContext context) async {
    String selectedCategory = "광고"; // 기본 선택 값
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 32.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "문의하기",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "해당 내용을 입력해주세요.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ["광고", "제휴", "문의"].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedCategory = value;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "문의 종류",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "제목",
                    border: OutlineInputBorder(),
                    hintText: "제목을 입력하세요",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "내용",
                    border: OutlineInputBorder(),
                    hintText: "내용을 입력하세요",
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "취소",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        onPressed: () {
                          final myPageController =  Get.find<MyPageController>();
                          final inquiry = {
                            "category": selectedCategory,
                            "title": titleController.text,
                            "content": contentController.text,
                          };
                          myPageController.submitInquiry(inquiry);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "제출",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
