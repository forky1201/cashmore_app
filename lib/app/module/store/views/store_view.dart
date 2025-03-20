import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/app/module/store/controller/store_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StoreView extends GetView<StoreController> {
  StoreView({super.key});

  final numberFormat = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        splitLayout: false,
        height: 17,
        title: "",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderSection(), // 스토어, 보유 쿠폰
          const SizedBox(height: 16.0),
          _buildPointSection(), // 보유 포인트 섹션
          const SizedBox(height: 16.0),
          Expanded(child: _buildBrandGrid()), // 브랜드 그리드
        ],
      ),
    );
  }

  // 스토어와 보유 쿠폰 헤더 섹션
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "스토어",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              //Get.snackbar('알림', '보유 쿠폰은 준비 중입니다.');
              controller.moveToCouponList();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text(
              "보유 쿠폰",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 보유 포인트 섹션 (테두리 추가)
  Widget _buildPointSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 양쪽 여백
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.0), // 테두리
        borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "보유 포인트",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Obx(() => Text(
                      "${numberFormat.format(controller.totalPoints.value)} P",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    )),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final mainController = Get.find<MainController>();
                mainController.updateIndex(3);
                await mainController.navigateTo(3); // 미션 탭으로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                "사용내역",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 브랜드 그리드 (4개씩 한 줄에 표시)
  Widget _buildBrandGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.brands.isEmpty) {
        return const Center(child: Text("브랜드가 없습니다."));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 한 줄에 4개씩
          crossAxisSpacing: 8.0, // 가로 간격
          mainAxisSpacing: 8.0, // 세로 간격
          childAspectRatio: 0.8, // 위젯의 가로 세로 비율
        ),
        itemCount: controller.brands.length,
        itemBuilder: (context, index) {
          final brand = controller.brands[index];

          return GestureDetector(
            onTap: () {
              // 클릭 이벤트 처리
              controller.moveToCouponDetail(brand.brandCode!, brand.brandName!);
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      brand.brandIConImg ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  brand.brandName ?? "브랜드 제목",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
