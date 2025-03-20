import 'dart:io';
import 'dart:typed_data';

import 'package:cashmore_app/common/model/payment_model.dart';
import 'package:cashmore_app/repository/coupon_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class CouponController extends GetxController {
  CouponRepsitory couponRepsitory = CouponRepsitory();
  var coupons = <PaymentModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons(); // 화면 진입 시 쿠폰 리스트 로드
  }

  Future<void> fetchCoupons() async {
    isLoading.value = true;
    try {
      // Mocking repository call
      List<PaymentModel> list = await couponRepsitory.paymentList(
        AppService.to.userId!,
        (currentPage.value - 1) * pageSize,
        pageSize,
      );
      if (currentPage.value == 1) {
        coupons.assignAll(list);
      } else {
        coupons.addAll(list);
      }
    } catch (e) {
      print('error' + e.toString());
      Get.snackbar('Error', 'Failed to load coupons');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCoupons() async {
    currentPage.value = 1;
    await fetchCoupons();
  }

  void loadMoreCoupons() {
    if (!isLoading.value) {
      currentPage.value++;
      fetchCoupons();
    }
  }

  // 취소 확인 다이얼로그 표시
  void showPurchaseDialog(String trId) {
    Get.dialog(
      _buildCustomDialog(
        title: "취소하기",
        message: "해당 쿠폰을 정말 취소하시겠습니까?",
        onConfirm: () async {
          await cancelCoupon(trId);
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
                  label: "취소하기",
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

  // 쿠폰 취소 기능
  Future<void> cancelCoupon(String trId) async {
    var user = await AppService().getUser(); // 현재 사용자 정보 가져오기

    Map<String, dynamic> requestBody = {"user_id": user.user_id, "tr_id": trId};

    try {
      // 쿠폰 취소 API 호출
      await couponRepsitory.cancelCoupon(requestBody).then((response) async {
        // 성공 메시지 표시
        Get.snackbar(
          '성공',
          '쿠폰이 성공적으로 취소되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
        );

        await refreshCoupons(); // 쿠폰 목록 새로고침
      });
    } catch (e) {
      // 오류 처리
      Get.snackbar(
        '오류',
        '쿠폰 취소 중 오류가 발생했습니다. 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error during coupon cancellation: $e");
    } finally {
      //Get.back(); // 다이얼로그 닫기
      Navigator.of(Get.context!).pop(); // 다이얼로그 닫기
    }
  }

  // 팝업으로 이미지와 저장 버튼 표시
  void showImageDialog(String imageUrl, String trId) async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이미지 표시
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // 저장 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => saveImageToGallery(imageUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "이미지 저장",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    try {
      // 이미지 다운로드
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // 갤러리에 이미지 저장
      final assetEntity = await PhotoManager.editor.saveImage(
        Uint8List.fromList(response.data),
        title: "coupon_${DateTime.now().millisecondsSinceEpoch}.jpg",
        filename: "coupon_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      if (assetEntity != null) {
        Get.snackbar(
          "성공",
          "이미지가 갤러리에 저장되었습니다.",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
      } else {
        throw Exception("갤러리에 이미지를 저장하지 못했습니다.");
      }
    } catch (e) {
      Get.snackbar(
        "오류",
        "이미지 저장 중 문제가 발생했습니다: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error while saving image: $e");
    }
  }

  // 페이지 이동 함수
  Future<void> moveToUrl(String path) async {
    await Get.toNamed(path);
  }
}
