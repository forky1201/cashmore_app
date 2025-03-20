import 'package:cashmore_app/app/module/point/controller/coupon_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponView extends GetView<CouponController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "보유 쿠폰",
        centerTitle: true,
        showReportButton: false,
        splitLayout: true,
        height: 85, // 상단 높이를 약간 높게 설정
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.coupons.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.coupons.isEmpty) {
                // 리스트가 비어 있는 경우 "보유중인 쿠폰이 없습니다." 표시
                return _buildEmptyState();
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification && scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !controller.isLoading.value) {
                    controller.loadMoreCoupons();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: controller.refreshCoupons,
                  child: ListView.builder(
                    itemCount: controller.coupons.length + (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < controller.coupons.length) {
                        final coupon = controller.coupons[index];
                        final isActive = coupon.pinStatusCd == 1;

                        return ListTile(
                          onTap: isActive
                              ? () {
                                  if (coupon.couponImgUrl != null && coupon.couponImgUrl!.isNotEmpty) {
                                    controller.showImageDialog(coupon.couponImgUrl!, coupon.trId!);
                                  }
                                }
                              : null,
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: coupon.couponImgUrl != null && coupon.couponImgUrl!.isNotEmpty
                                ? Image.network(
                                    coupon.couponImgUrl!,
                                    color: isActive ? null : Colors.grey,
                                    colorBlendMode: isActive ? null : BlendMode.saturation,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                          ),
                          title: Text(
                            coupon.goodsName ?? '',
                            style: TextStyle(
                              color: isActive ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${coupon.limitDay}일 남음',
                            style: TextStyle(color: isActive ? Colors.black : Colors.grey),
                          ),
                          enabled: isActive,
                          trailing: TextButton(
                            onPressed: isActive ? () => controller.showPurchaseDialog(coupon.trId!) : null,
                            style: TextButton.styleFrom(
                              backgroundColor: isActive ? Colors.red : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 빈 상태 메시지 위젯
  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: controller.refreshCoupons,
      child: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                '보유중인 쿠폰이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
