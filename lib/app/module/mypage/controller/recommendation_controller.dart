import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/recommender_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendationController extends BaseController {
  final appService = Get.find<AppService>();
  MypageRepsitory mypageRepsitory = MypageRepsitory();
  // 추천인 리스트 관리
  var recommenders = <RecommenderModel>[].obs; // 추천인 리스트 (예: 추천인 이름)
  var isEmpty = true.obs; // 추천인 리스트가 비었는지 여부
  var isLoading = false.obs; // 로딩 상태 관리
  var currentPage = 1.obs; // 현재 페이지
  int pageSize = 6;
  var my_recommender = "".obs;
  var boardMessage = "추천인 포인트 지급 안내";

  late ScrollController scrollController; // 스크롤 컨트롤러

  @override
  void onInit() {
    super.onInit();
    myRe();

    fetchRecommenders(); // 초기 추천인 데이터 로드

    // 스크롤 컨트롤러 초기화 및 끝 감지
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading.value) {
        fetchRecommenders();
      }
    });
  }

  Future<void> myRe() async {
    UserModel user = await AppService().getUser();
    my_recommender.value = user.my_recommender.toString();
  }

  // 추천인 목록 가져오기 (페이징 처리)
  Future<void> fetchRecommenders() async {
    if (isLoading.value) return; // 로딩 중일 때 중복 호출 방지

    isLoading(true);

    try {
      UserModel user = await AppService().getUser();

      // 서버에서 데이터 가져오기
      List<RecommenderModel> list = await mypageRepsitory.recommendersList(
        user.user_id,
        user.my_recommender.toString(),
        (currentPage.value - 1) * pageSize,
        pageSize,
      );

      // 데이터 추가 및 상태 업데이트
      if (list.isNotEmpty) {
        recommenders.addAll(list);
        currentPage.value++; // 페이지 증가
        isEmpty.value = false; // 리스트에 데이터가 있음을 표시
      } else {
        isEmpty.value = true; // 리스트가 비어있음을 표시
      }
    } catch (e) {
      print('오류 발생: $e');
      Get.snackbar('오류', '추천인 데이터를 불러오는 중 오류가 발생했습니다.');
      isEmpty.value = true; // 리스트가 비어있음을 표시
    } finally {
      isLoading(false);
    }
  }

  // 추천인 초대 버튼을 눌렀을 때 처리하는 함수
  void inviteRecommender() {
    print("추천인 초대 버튼 클릭");
  }

  // 새로고침 함수
  Future<void> refreshRecommenders() async {
    // 페이지 초기화 및 데이터 초기화
    currentPage.value = 1;
    recommenders.clear(); // 리스트 비우기
    isEmpty.value = true; // 리스트 상태 초기화
    await fetchRecommenders(); // 데이터 다시 불러오기
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
