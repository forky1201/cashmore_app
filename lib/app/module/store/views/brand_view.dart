import 'package:cashmore_app/app/module/store/controller/brand_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BrandView extends GetView<BrandController> {
  BrandView({super.key});
  final numberFormat = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    // Get.arguments로 전달된 brandCode 설정
    final arguments = Get.arguments as Map;
    final brandCode = arguments['brandCode'];
    final brandName = arguments['brandName'];
    controller.brandCode.value = brandCode;

    // 브랜드 쿠폰 데이터를 불러오기
    controller.fetchCoupons();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: brandName,
        centerTitle: true,
        showReportButton: false,
        splitLayout: true,
        height: 85,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.coupons.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.coupons.isEmpty) {
                return _buildEmptyState();
              }

              return _buildCouponGrid();
            }),
          ),
          Obx(() {
            return controller.isLoading.value && controller.coupons.isNotEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // 쿠폰 그리드
  Widget _buildCouponGrid() {
    return GridView.builder(
      controller: controller.scrollController, // 스크롤 컨트롤러
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 한 줄에 2개씩
        crossAxisSpacing: 8.0, // 가로 간격
        mainAxisSpacing: 8.0, // 세로 간격
        childAspectRatio: 0.8, // 아이템의 가로 세로 비율
      ),
      itemCount: controller.coupons.length,
      itemBuilder: (context, index) {
        final coupon = controller.coupons[index];
        return GestureDetector(
          onTap: () {
            controller.moveToCouponDetail(coupon.goodsCode!, coupon.goodsName!); // 상세 페이지 이동
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    coupon.goodsImgB ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                coupon.goodsName ?? "상품명",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4.0),
              Text(
                "${numberFormat.format(coupon.salePrice) ?? 0}P",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 빈 상태 UI (중앙 정렬)
  Widget _buildEmptyState() {
    return Center(
      // Center로 중앙 정렬
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.info, size: 30, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            "상품이 없습니다.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
