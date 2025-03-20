import 'package:cashmore_app/common/model/goods_detail_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/coupon_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class GoodsDetailController extends GetxController {
  final CouponRepsitory couponRepsitory = CouponRepsitory();

  var goodsDetail = Rxn<GoodsDetail>();
  var isLoading = false.obs;
  var totalPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userInfo();
  }

  Future<void> fetchGoodsDetail(String goodsCode) async {
    isLoading(true);
    try {
      final detail = await couponRepsitory.fetchGoodsDetail(AppService.to.userId!, goodsCode);
      goodsDetail.value = detail;
    } catch (e) {
      print("Error fetching goods detail: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> couponPay(String goods_code) async {
    var user = await AppService().getUser();

    Map<String, dynamic> requestBody = {
      "user_id": user.user_id,
      "phone_no": user.user_hp,
      "goods_code": goods_code,
    };

    try {
      final response = await couponRepsitory.couponPay(requestBody);
       // 진동 발생
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500); // 500ms 동안 진동
      }
      
       Get.snackbar(
        '성공',
        '쿠폰이 성공적으로 발행되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back(closeOverlays: true, result: true);
    } catch (e) {
      // 실패 시, 오류 알림
      Get.snackbar(
        '오류',
        '쿠폰 발행 오류.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // 쿠폰 상세 보기로 이동
  void moveToUrl() {
    Get.toNamed(
      '/goodsDetail',
    );
  }

  void showPurchaseDialog(String goodsCode) {
    Get.dialog(
      _buildCustomDialog(
        title: "구매하기",
        message: "해당 쿠폰을 정말 구매하시겠습니까?",
        onConfirm: () async {
          await couponPay(goodsCode); // 쿠폰 결제 요청
          //Get.snackbar("구매하기", "쿠폰이 성공적으로 발행되었습니다.");
          //Get.back(closeOverlays: true, result: true);
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
                  label: "구매하기",
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

  Future<void> userInfo() async {
    await AppService.to.loginInfoRefresh();
    UserModel user = await AppService().getUser();
    totalPoints.value = user.total_point!;
  }
}
