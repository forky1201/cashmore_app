import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/point_model.dart';
import 'package:cashmore_app/repository/point_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // 날짜 포맷 사용

class WithdrawalController extends BaseController {
  final appService = Get.find<AppService>();
  PointRepsitory pointRepository = PointRepsitory();

  var transactions = <PointModel>[].obs; // 출금 내역 리스트
  var isLoading = false.obs; // 데이터 로딩 중 여부
  var currentPage = 1.obs; // 현재 페이지
  int pageSize = 10;

  var status = "출금요청".obs; // 현재 선택된 탭 상태

  Map<String, List<PointModel>> get groupedTransactions {
    // 날짜별 그룹화된 데이터 반환
    Map<String, List<PointModel>> grouped = {};
    for (var transaction in transactions) {
      final formattedDate = DateFormat('yyyy.MM.dd').format(DateTime.parse(transaction.regdate.toString()));
      grouped.putIfAbsent(formattedDate, () => []).add(transaction);
    }
    return grouped;
  }

  late ScrollController scrollController; // 스크롤 컨트롤러

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();

    // 스크롤 컨트롤러 초기화 및 끝 감지
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading.value) {
        fetchTransactions();
      }
    });
  }

  // 출금 내역 데이터 로드 함수 (페이징)
  Future<void> fetchTransactions() async {
    if (isLoading.value) return;
    isLoading(true);

    List<PointModel> list = await pointRepository.pointList(
      AppService.to.userId!,
      status.value,
      (currentPage.value - 1) * pageSize,
      pageSize,
    );
    if (list.isNotEmpty) {
      transactions.addAll(list);
      currentPage.value++;
    }
    isLoading(false);
  }

  // 탭 상태 변경
  void changeStatus(String newStatus) {
    if (status.value != newStatus) {
      status.value = newStatus;
      refreshTransactions();
    }
  }

  // 새로고침 기능
  Future<void> refreshTransactions() async {
    currentPage.value = 1;
    transactions.clear();
    await fetchTransactions();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
