import 'package:cashmore_app/app/module/store/controller/goods_detail_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/common/model/goods_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GoodsDetailView extends GetView<GoodsDetailController> {
  GoodsDetailView({super.key});

  final numberFormat = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map;
    final goodsCode = arguments['goodsCode'];
    final goodsName = arguments['goodsName'];

    controller.fetchGoodsDetail(goodsCode);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: goodsName,
        centerTitle: true,
        showReportButton: false,
        splitLayout: true,
        height: 85,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final goodsDetail = controller.goodsDetail.value;
        if (goodsDetail == null) {
          return const Center(child: Text("상품 정보를 불러올 수 없습니다."));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSection(goodsDetail),
              _buildUsageInfoSection(goodsDetail),
              _buildPurchaseButton(goodsDetail),
            ],
          ),
        );
      }),
    );
  }

  // 이미지 섹션
  Widget _buildImageSection(GoodsDetail goodsDetail) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                goodsDetail.goodsImgB ?? "",
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
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상품명 (좌측)
              Expanded(
                child: Text(
                  goodsDetail.goodsName ?? "상품명",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16.0),
              // 브랜드명 (우측)
              Text(
                goodsDetail.brandName ?? "브랜드명",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            "${numberFormat.format(goodsDetail.salePrice).toString() ?? "0"} P",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // 이용 안내 섹션
  Widget _buildUsageInfoSection(GoodsDetail goodsDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.info, size: 16, color: Colors.green),
                SizedBox(width: 8.0),
                Text(
                  "이용안내",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              goodsDetail.content ?? "이용 안내가 없습니다.",
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // 구매 버튼
  Widget _buildPurchaseButton(GoodsDetail goodsDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        final isButtonEnabled = controller.totalPoints.value >= (goodsDetail.salePrice ?? 0);

        return ElevatedButton(
          onPressed: isButtonEnabled
              ? () {
                  controller.showPurchaseDialog(goodsDetail.goodsCode!);
                }
              : null, // 버튼 비활성화
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled ? Colors.black : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            isButtonEnabled ? "구매하기" : "포인트 부족",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }

}
