import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/coupon_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/coupon_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandController extends BaseController {
  final CouponRepsitory couponRepsitory = CouponRepsitory();

  var coupons = <CouponModel>[].obs; // 쿠폰 리스트
  var isLoading = false.obs; // 데이터 로딩 중 여부
  var currentPage = 1.obs; // 현재 페이지
  int pageSize = 20; // 한 페이지에 불러올 데이터 개수
  var brandCode = "".obs; // 전달받은 brandCode

  late ScrollController scrollController; // 스크롤 컨트롤러

  @override
  void onInit() {
    super.onInit();

    // 스크롤 컨트롤러 초기화 및 끝 감지
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading.value) {
        fetchCoupons();
      }
    });
  }

  // 쿠폰 데이터 로드 함수 (페이징)
  Future<void> fetchCoupons() async {
    if (isLoading.value) return;
    isLoading(true);

    try {
      List<CouponModel> list = await couponRepsitory.brandByList(
        AppService.to.userId!,
        brandCode.value,
        (currentPage.value - 1) * pageSize,
        pageSize,
      );

      if (list.isNotEmpty) {
        coupons.addAll(list);
        currentPage.value++;
      }
    } catch (e) {
      print("Error fetching coupons: $e");
    } finally {
      isLoading(false);
    }
  }

  // 새로고침 기능
  Future<void> refreshCoupons() async {
    currentPage.value = 1;
    coupons.clear();
    await fetchCoupons();
  }

  // 쿠폰 상세 보기로 이동
  Future<void> moveToCouponDetail(String goodsCode, String goodsName) async {
    var result = await Get.toNamed(
      '/goodsDetail',
      arguments: {
        'goodsCode': goodsCode,
        'goodsName': goodsName,
      },
    );

    if (result != null) {
      print("Returned result: $result");
      if(result == true){
        Get.back(result: true);
      }
      
      // 리턴 값 처리
    } else {
      print("No result received.");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
