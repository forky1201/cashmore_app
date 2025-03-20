import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/brand_model.dart';
import 'package:cashmore_app/common/model/coupon_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/coupon_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends BaseController {
  final CouponRepsitory couponRepsitory = CouponRepsitory();

  var brands = <BrandModel>[].obs; // 쿠폰 리스트
  var isLoading = false.obs; // 데이터 로딩 중 여부
  var totalPoints = 0.obs;
  var brandCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    userInfo();
    fetchCoupons();
  }

  // 쿠폰 데이터 로드 함수 (페이징)
  Future<void> fetchCoupons() async {
    if (isLoading.value) return;
    isLoading(true);

    try {
      List<BrandModel> list = await couponRepsitory.brandList(AppService.to.userId!);

      brands.addAll(list);
    } catch (e) {
      print("Error fetching coupons: $e");
    } finally {
      isLoading(false);
    }
  }

  // 쿠폰 상세 보기로 이동
  Future<void> moveToCouponDetail(String brandCode, String brandName) async {
    var result = await Get.toNamed(
      '/brandView',
      arguments: {
        'brandCode': brandCode,
        'brandName': brandName,
      },
    );


    if (result != null) {
      print("Returned result: $result");
      if (result == true) {
        //보유쿠폰으로
        moveToCouponList();
      }

      // 리턴 값 처리
    } else {
      print("No result received.");
    }
  }

  void moveToCouponList()  {
    Get.toNamed(
      '/coupon',
    );

  }

  Future<void> userInfo() async {
    await AppService.to.loginInfoRefresh();
    UserModel user = await AppService().getUser();
    totalPoints.value = user.total_point!;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
