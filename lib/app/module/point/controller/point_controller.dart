import 'package:cashmore_app/app/module/point/controller/point_withdrawal_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/point_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/common/toast_message.dart';
import 'package:cashmore_app/repository/point_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 import

class PointController extends BaseController with GetSingleTickerProviderStateMixin {
  final appService = Get.find<AppService>();
  PointRepsitory pointRepository = PointRepsitory();

  var status = "지급".obs; // 현재 선택된 탭 상태 지급/대기/반려

  // 포인트와 날짜 변수들
  var totalPoints = 0.obs; // 보유 포인트
  var paymentCurrentDate = ''.obs; // 지급 날짜
  var waitCurrentDate = ''.obs; // 대기 날짜
  var returnCurrentDate = ''.obs; // 반려 날짜

  // 포인트 리스트들
  var paymentList = <PointModel>[].obs; // 지급 내역 리스트
  var waitList = <PointModel>[].obs; // 대기 내역 리스트
  var returnList = <PointModel>[].obs; // 반려 내역 리스트

  int pageSize = 10;

  // 각 포인트 리스트별 로딩 상태 및 페이지 변수
  var isLoadingPayments = false.obs; // 지급 내역 로딩 상태
  var isLoadingWait = false.obs; // 대기 내역 로딩 상태
  var isLoadingReturn = false.obs; // 반려 내역 로딩 상태

  var currentPagePayments = 1.obs; // 지급 내역 페이지
  var currentPageWait = 1.obs; // 대기 내역 페이지
  var currentPageReturn = 1.obs; // 반려 내역 페이지

  // 스크롤 컨트롤러들
  late ScrollController paymentScrollController; // 지급 내역 스크롤 컨트롤러
  late ScrollController waitScrollController; // 대기 내역 스크롤 컨트롤러
  late ScrollController returnScrollController; // 반려 내역 스크롤 컨트롤러

  late TabController tabController;

  Map<String, List<PointModel>> get groupedTransactions {
    // 날짜별 그룹화된 데이터 반환
    Map<String, List<PointModel>> grouped = {};
    for (var transaction in paymentList) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.regdate.toString()));
      grouped.putIfAbsent(formattedDate, () => []).add(transaction);
    }
    return grouped;
  }

  Map<String, List<PointModel>> get groupedTransactions2 {
    // 날짜별 그룹화된 데이터 반환
    Map<String, List<PointModel>> grouped = {};
    for (var transaction in waitList) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.regdate.toString()));
      grouped.putIfAbsent(formattedDate, () => []).add(transaction);
    }
    return grouped;
  }

  Map<String, List<PointModel>> get groupedTransactions3 {
    // 날짜별 그룹화된 데이터 반환
    Map<String, List<PointModel>> grouped = {};
    for (var transaction in returnList) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.regdate.toString()));
      grouped.putIfAbsent(formattedDate, () => []).add(transaction);
    }
    return grouped;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    userInfo();
    fetchPayments(); // 지급 내역 데이터 로드
    fetchWaitList(); // 대기 내역 데이터 로드
    fetchReturnList(); // 반려 내역 데이터 로드

    // 지급 내역 스크롤 컨트롤러 초기화 및 끝 감지
    paymentScrollController = ScrollController();
    paymentScrollController.addListener(() {
      if (paymentScrollController.position.pixels == paymentScrollController.position.maxScrollExtent && !isLoadingPayments.value) {
        fetchPayments(); // 스크롤 끝에 도달하면 지급 내역 데이터를 가져옴
      }
    });

    // 대기 내역 스크롤 컨트롤러 초기화 및 끝 감지
    waitScrollController = ScrollController();
    waitScrollController.addListener(() {
      if (waitScrollController.position.pixels == waitScrollController.position.maxScrollExtent && !isLoadingWait.value) {
        fetchWaitList(); // 스크롤 끝에 도달하면 대기 내역 데이터를 가져옴
      }
    });

    // 반려 내역 스크롤 컨트롤러 초기화 및 끝 감지
    returnScrollController = ScrollController();
    returnScrollController.addListener(() {
      if (returnScrollController.position.pixels == returnScrollController.position.maxScrollExtent && !isLoadingReturn.value) {
        fetchReturnList(); // 스크롤 끝에 도달하면 반려 내역 데이터를 가져옴
      }
    });
  }

  // 지급 내역 데이터 로드 함수
  Future<void> fetchPayments() async {
    if (isLoadingPayments.value) return;
    isLoadingPayments(true);

    List<PointModel> list = await pointRepository.pointList(
      AppService.to.userId!,
      "지급",
      (currentPagePayments.value - 1) * pageSize,
      pageSize,
    );
    paymentList.addAll(list);
    currentPagePayments.value++;
    isLoadingPayments(false);
  }

  // 대기 내역 데이터 로드 함수
  Future<void> fetchWaitList() async {
    if (isLoadingWait.value) return;
    isLoadingWait(true);

    List<PointModel> list = await pointRepository.pointList(
      AppService.to.userId!,
      "대기",
      (currentPageWait.value - 1) * pageSize,
      pageSize,
    );

    waitList.addAll(list);
    currentPageWait.value++;
    isLoadingWait(false);
  }

  // 반려 내역 데이터 로드 함수
  Future<void> fetchReturnList() async {
    if (isLoadingReturn.value) return;
    isLoadingReturn(true);

    List<PointModel> list = await pointRepository.pointList(
      AppService.to.userId!,
      "반려",
      (currentPageReturn.value - 1) * pageSize,
      pageSize,
    );

    returnList.addAll(list);
    currentPageReturn.value++;
    isLoadingReturn(false);
  }

  // 새로고침 함수 (지급 내역)
  Future<void> refreshPayments() async {
    currentPagePayments.value = 1;
    paymentList.clear();
    fetchPayments();
  }

  // 새로고침 함수 (대기 내역)
  Future<void> refreshWaitList() async {
    currentPageWait.value = 1;
    waitList.clear();
    fetchWaitList();
  }

  // 새로고침 함수 (반려 내역)
  Future<void> refreshReturnList() async {
    currentPageReturn.value = 1;
    returnList.clear();
    fetchReturnList();
  }

  void onTabSelected(int index) {
    // 탭 변경 시 처리 로직
    switch (index) {
      case 0:
        refreshPayments();
        break;
      case 1:
        refreshWaitList();
        break;
      case 2:
        refreshReturnList();
        break;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    paymentScrollController.dispose();
    waitScrollController.dispose();
    returnScrollController.dispose();
    super.onClose();
  }

  // 페이지 이동 함수
  Future<void> movePage(String path) async {
    var result = await Get.toNamed(path);

    if (result == true) {
      userInfo();
      //리스트 새로고침
    }
  }

  Future<void> userInfo() async {
    await AppService.to.loginInfoRefresh();
    UserModel user = await AppService().getUser();
    totalPoints.value = user.total_point!;
  }
}
