import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBar extends GetView<MainController> implements PreferredSizeWidget {
  final String title; // 제목
  final List<Widget>? actions; // 추가 액션 버튼
  final bool centerTitle; // 제목 중앙 정렬 여부 설정
  final bool showReportButton; // 신고 버튼 표시 여부
  final String? questNumber;
  final double? height;
  final bool splitLayout; // 위아래로 나누는지 여부

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.showReportButton = false,
    this.questNumber,
    this.height,
    this.splitLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    return splitLayout
        ? _buildSplitLayout(context) // 위아래로 나누는 레이아웃
        : _buildSingleLayout(context); // 단일 레이아웃
  }

  /// 단일 레이아웃
  Widget _buildSingleLayout(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: sdPrimaryColor,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: centerTitle,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          if (showReportButton)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: () {
                  controller.openReportModal(Get.context!, questNumber!);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '신고',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ...?actions,
        ],
      ),
    );
  }

 Widget _buildSplitLayout(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(105), // 전체 높이 설정
      child: Column(
        children: [
          // 상단 영역: 배경색
          Container(
            color: sdPrimaryColor,
            height: 40,
          ),
          // 하단 영역
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // 뒤로가기 버튼
                    if (Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    else
                      const SizedBox(width: 48), // 자리 확보

                    // 제목 중앙 정렬
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // 오른쪽 버튼
                    if (showReportButton)
                      ElevatedButton(
                        onPressed: () {
                          controller.openReportModal(Get.context!, questNumber!);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '신고',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      )
                    else
                      const SizedBox(width: 48), // 자리 확보
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }





  @override
  Size get preferredSize => Size.fromHeight(height ?? 70.0);
}
