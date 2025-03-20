import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/board_model.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeController extends BaseController {
  final appService = Get.find<AppService>();
  MypageRepsitory mypageRepsitory = MypageRepsitory();

  var notices = <BoardModel>[].obs; // 공지사항 리스트
  var isLoading = false.obs; // 데이터 로딩 중 여부
  var currentPage = 1.obs; // 현재 페이지
  int pageSize = 6;

  late ScrollController scrollController; // 스크롤 컨트롤러


  @override
  void onInit() {
    super.onInit();
    fetchNotices();

    // 스크롤 컨트롤러 초기화 및 끝 감지
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading.value) {
        fetchNotices();
      }
    });
  }

  // 공지사항 데이터 로드 함수 (페이징)
  Future<void> fetchNotices() async {
    if (isLoading.value) return;
    isLoading(true);

    List<BoardModel> list = await mypageRepsitory.boardList(
      AppService.to.userId!,
      "1",
      notices.length,
      pageSize,
    );
    if (list.isNotEmpty) {
      notices.addAll(list);
      currentPage.value++;
    }
    isLoading(false);
  }

  // 새로고침 기능
  Future<void> refreshNotices() async {
    currentPage.value = 1;
    notices.clear();
    await fetchNotices();
  }

  // 공지사항 상세 보기로 이동
  void moveToNoticeDetail(int id) {
    Get.toNamed('/notice_detail', arguments: id);
  }


  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
