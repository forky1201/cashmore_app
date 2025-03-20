import 'package:cashmore_app/app/module/home/controller/home_controller.dart';
import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/model/misson_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/mission_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MissionController extends BaseController with GetSingleTickerProviderStateMixin {
  final appService = Get.find<AppService>();
  MissionRepsitory missionRepsitory = MissionRepsitory();
  int pageSize = 8;

  // 미션 리스트들
  var missions = <MissionModel>[].obs; // 기존 미션 리스트
  var shareMissions = <MissionModel>[].obs; // 공유 미션 리스트
  var normalMissions = <MissionModel>[].obs; // Normal 미션 리스트
  var specialMissions = <MissionModel>[].obs; // Special 미션 리스트
  var captureMissions = <MissionModel>[].obs; // Capture 미션 리스트 (MissionCaptureView 전용)

  // 로딩 상태
  var isLoadingMissions = false.obs;
  var isLoadingMoreMissions = false.obs; // 기존 미션에서 추가 데이터를 로드할 때 사용되는 로딩 상태
  var isLoadingMoreShare = false.obs; // 기존 미션에서 추가 데이터를 로드할 때 사용되는 로딩 상태
  var isLoadingMoreNormal = false.obs; // Normal 미션에서 추가 데이터를 로드할 때 사용되는 로딩 상태
  var isLoadingMoreSpecial = false.obs; // Special 미션에서 추가 데이터를 로드할 때 사용되는 로딩 상태
  var isLoadingMoreCapture = false.obs; // Capture 미션에서 추가 데이터를 로드할 때 사용되는 로딩 상태
  var isLoadingNormal = false.obs;
  var isLoadingSpecial = false.obs;
  var isLoadingCapture = false.obs;
  var isLoadingShare = false.obs;

  // 페이지 변수
  var currentPageMissions = 1.obs;
  var currentPageNormal = 1.obs;
  var currentPageSpecial = 1.obs;
  var currentPageCapture = 1.obs;
  var currentPageShare = 1.obs;

  // 스크롤 컨트롤러
  late ScrollController scrollController;
  late ScrollController normalScrollController;
  late ScrollController specialScrollController;
  late ScrollController captureScrollController;
  late ScrollController shareScrollController;

  var isLoadingDetails = false.obs; // 상세 페이지 로딩 상태

  late TabController tabController;

  int get tabLength {
    int count = 0;
    if (answerYn) count++;
    if (shareYn) count++;
    if (normalYn) count++;
    if (spYn) count++;
    return count;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabLength, vsync: this);
    // 데이터 로드
    //initFetchMissions();
    initScrollListeners();
  }

  // 초기 미션 데이터 로드
  void initFetchMissions() {
    fetchMissions();
    fetchShareMissions();
    fetchNormalMissions();
    fetchSpecialMissions();
    fetchCaptureMissions();
  }

  // 스크롤 끝 감지 리스너
  void initScrollListeners() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (_isEndOfList(scrollController) && !isLoadingMissions.value && !isLoadingMoreMissions.value) {
        fetchMissions();
      }
    });

    normalScrollController = ScrollController();
    normalScrollController.addListener(() {
      if (_isEndOfList(normalScrollController) && !isLoadingNormal.value && !isLoadingMoreNormal.value) {
        fetchNormalMissions();
      }
    });

    specialScrollController = ScrollController();
    specialScrollController.addListener(() {
      if (_isEndOfList(specialScrollController) && !isLoadingSpecial.value && !isLoadingMoreSpecial.value) {
        fetchSpecialMissions();
      }
    });

    captureScrollController = ScrollController();
    captureScrollController.addListener(() {
      if (_isEndOfList(captureScrollController) && !isLoadingCapture.value && !isLoadingMoreCapture.value) {
        fetchCaptureMissions();
      }
    });

    shareScrollController = ScrollController();
    shareScrollController.addListener(() {
      if (_isEndOfList(shareScrollController) && !isLoadingShare.value && !isLoadingMoreShare.value) {
        fetchMissions();
      }
    });
  }

  bool _isEndOfList(ScrollController controller) {
    return controller.position.pixels == controller.position.maxScrollExtent;
  }

  // 데이터 로드 로직을 공통 함수로 처리
  Future<void> _loadMissions({
    required RxBool isLoading,
    required RxBool isLoadingMore, // 추가 로드 상태 관리 변수
    required RxList<MissionModel> missionList,
    required int currentPage,
    required String missionType,
    bool isMoreLoad = false, // 추가 로드를 위한 플래그
  }) async {
    if (isLoading.value || (isMoreLoad && isLoadingMore.value)) return;

    if (isMoreLoad) {
      isLoadingMore(true);
    } else {
      isLoading(true);
    }

    List<MissionModel> fetchedMissions = await missionRepsitory.missionList(
        AppService.to.userId!,
        missionType,
        missionList.length, // offset
        pageSize);

    if (fetchedMissions.isNotEmpty) {
      missionList.addAll(fetchedMissions);
      currentPage++;
    }

    isLoading(false);
    isLoadingMore(false);
  }

  // 대답 미션 데이터 로드 (페이징 포함)
  Future<void> fetchMissions() async {
    await _loadMissions(
      isLoading: isLoadingMissions,
      isLoadingMore: isLoadingMoreMissions, // 기존 미션에 대한 추가 로드 상태 관리
      missionList: missions,
      currentPage: currentPageMissions.value,
      missionType: "2",
      isMoreLoad: missions.isNotEmpty, // 페이징 시 추가 로드로 구분
    );
  }

  // 공유 미션 데이터 로드 (페이징 포함)
  Future<void> fetchShareMissions() async {
    await _loadMissions(
      isLoading: isLoadingShare,
      isLoadingMore: isLoadingMoreShare, // 기존 미션에 대한 추가 로드 상태 관리
      missionList: shareMissions,
      currentPage: currentPageShare.value,
      missionType: "3",
      isMoreLoad: shareMissions.isNotEmpty, // 페이징 시 추가 로드로 구분
    );
  }

  // Normal 미션 데이터 로드 (페이징 포함)
  Future<void> fetchNormalMissions() async {
    await _loadMissions(
      isLoading: isLoadingNormal,
      isLoadingMore: isLoadingMoreNormal, // Normal 미션에 대한 추가 로드 상태 관리
      missionList: normalMissions,
      currentPage: currentPageNormal.value,
      missionType: "1",
      isMoreLoad: normalMissions.isNotEmpty, // 페이징 시 추가 로드로 구분
    );
  }

  // Special 미션 데이터 로드 (페이징 포함)
  Future<void> fetchSpecialMissions() async {
    await _loadMissions(
      isLoading: isLoadingSpecial,
      isLoadingMore: isLoadingMoreSpecial, // Special 미션에 대한 추가 로드 상태 관리
      missionList: specialMissions,
      currentPage: currentPageSpecial.value,
      missionType: "4",
      isMoreLoad: specialMissions.isNotEmpty, // 페이징 시 추가 로드로 구분
    );
  }

  // Capture 미션 데이터 로드 (페이징 포함)
  Future<void> fetchCaptureMissions() async {
    await _loadMissions(
      isLoading: isLoadingCapture,
      isLoadingMore: isLoadingMoreCapture, // Capture 미션에 대한 추가 로드 상태 관리
      missionList: captureMissions,
      currentPage: currentPageCapture.value,
      missionType: "5",
      isMoreLoad: captureMissions.isNotEmpty, // 페이징 시 추가 로드로 구분
    );
  }

  // 새로고침 로직
  Future<void> _refreshMissions({
    required RxList<MissionModel> missionList,
    required RxInt currentPage,
    required String missionType,
  }) async {
    currentPage.value = 1;
    missionList.clear();
    await _loadMissions(
      isLoading: false.obs, // 새로고침 시 로딩 상태 초기화
      isLoadingMore: false.obs, // 새로고침 시 추가 로드 상태 초기화
      missionList: missionList,
      currentPage: currentPage.value,
      missionType: missionType,
    );
  }

  Future<void> refreshMissions() async {
    await _refreshMissions(missionList: missions, currentPage: currentPageMissions, missionType: "2");
  }

  Future<void> refreshShareMissions() async {
    await _refreshMissions(missionList: shareMissions, currentPage: currentPageShare, missionType: "3");
  }

  Future<void> refreshNormalMissions() async {
    await _refreshMissions(missionList: normalMissions, currentPage: currentPageNormal, missionType: "1");
  }

  Future<void> refreshSpecialMissions() async {
    await _refreshMissions(missionList: specialMissions, currentPage: currentPageSpecial, missionType: "4");
  }

  Future<void> refreshCaptureMissions() async {
    await _refreshMissions(missionList: captureMissions, currentPage: currentPageCapture, missionType: "5");
  }

  Future<void> moveToUrlNormal(String path, String param) async {
    var result = await Get.toNamed(path, arguments: param);
    if (result == true) {
      // MissionDetailNormalView에서 true를 반환했을 때 새로고침
      await refreshNormalMissions();
    }
  }

  Future<void> moveToUrlAnswer(String path, String param) async {
    var result = await Get.toNamed(path, arguments: param);
    if (result == true) {
      // MissionDetailNormalView에서 true를 반환했을 때 새로고침
      await refreshMissions();
    }
  }

  Future<void> moveToUrlShare(String path, String param) async {
    var result = await Get.toNamed(path, arguments: param);
    if (result == true) {
      // MissionDetailNormalView에서 true를 반환했을 때 새로고침
      await refreshShareMissions();
    }
  }

  Future<void> moveToUrlSpecial(String path, String param) async {
    var result = await Get.toNamed(path, arguments: param);
    if (result == true) {
      // MissionDetailNormalView에서 true를 반환했을 때 새로고침
      await refreshSpecialMissions();
    }
  }

  // 상태 텍스트 결정 로직을 컨트롤러에서 공통으로 관리
  String getButtonText(String questTotalCount, int questIngCount) {
    // 숫자만 추출하여 quest_count에 할당
    String numericString = questTotalCount.replaceAll(RegExp(r'[^0-9]'), '');
    int questCount = int.tryParse(numericString) ?? 0;
    if (questCount == 0) {
      // 모집할 인원이 0일 경우 '진행중' 반환 (나누기 에러 방지)
      return '진행중';
    }

    double participationRate = (questIngCount / questCount) * 100;
    return participationRate >= 90 ? '곧 마감되요!' : '진행중';
  }

  void onTabSelected(int index) {
    // 탭 변경 시 처리 로직
    switch (index) {
      case 0:
        //print("정답/공유 탭 선택됨");
        refreshMissions();
        break;
      case 1:
        //print("공유 탭 선택됨");
        refreshShareMissions();
        break;
      case 2:
        //print("일반 탭 선택됨");
        refreshNormalMissions();
        break;
      case 3:
        //print("프리미엄 탭 선택됨");
        refreshSpecialMissions();
        break;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    normalScrollController.dispose();
    specialScrollController.dispose();
    captureScrollController.dispose();
    shareScrollController.dispose();
    super.onClose();
  }
}
