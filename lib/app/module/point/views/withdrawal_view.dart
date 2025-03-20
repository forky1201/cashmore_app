import 'package:cashmore_app/app/module/point/controller/withdrawal_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // 날짜 형식 포맷을 위해 추가

class WithdrawalPage extends GetView<WithdrawalController> {
  const WithdrawalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "출금 내역",
        centerTitle: true,
        splitLayout: true,
        height: 85,
      ),
      body: Column(
        children: [
          _buildTabButtons(), // 상단 탭 버튼 추가
          Expanded(
            child: Obx(
              () => RefreshIndicator(
                onRefresh: controller.refreshTransactions, // 새로고침 호출
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 전체 패딩 설정
                  child: ListView.builder(
                    controller: controller.scrollController, // 컨트롤러에서 스크롤 감지
                    physics: const AlwaysScrollableScrollPhysics(), // 리스트가 꽉 차지 않아도 스크롤 가능
                    itemCount: controller.groupedTransactions.length, // 날짜별 그룹화된 리스트 길이
                    itemBuilder: (context, index) {
                      final dateGroup = controller.groupedTransactions.keys.elementAt(index); // 그룹화된 날짜
                      final transactions = controller.groupedTransactions[dateGroup]!; // 해당 날짜의 트랜잭션들

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              dateGroup, // 날짜 표시
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ...transactions.map((transaction) {
                            final isRequest = transaction.status == "출금요청";

                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey[300], // 아이콘 배경색
                                    radius: 16.0,
                                  ),
                                  title: Text(
                                    transaction.subject.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: Text(
                                    isRequest ? "출금요청" : "출금완료", // 상태 표시
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isRequest ? Colors.orange : Colors.green, // 상태에 따라 색상 변경
                                    ),
                                  ),
                                  trailing: Text(
                                    '${transaction.point! > 0 ? '+' : ''}${transaction.point}P', // 포인트 표시
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: transaction.point! > 0 ? Colors.green : Colors.red, // 포인트 색상
                                    ),
                                  ),
                                ),
                                //const Divider(height: 1.0),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      color: Colors.white, // 배경색 추가
      padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
      child: Row(
        children: [
          // 출금 요청 버튼
          Obx(
            () => Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.changeStatus("출금요청"); // 출금 요청 탭 선택
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.status.value == "출금요청" ? Colors.black : Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  '출금 요청',
                  style: TextStyle(
                    fontSize: 16,
                    color: controller.status.value == "출금요청" ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          // 출금 완료 버튼
          Obx(
            () => Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.changeStatus("출금완료"); // 출금 완료 탭 선택
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.status.value == "출금완료" ? Colors.black : Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  '출금 완료',
                  style: TextStyle(
                    fontSize: 16,
                    color: controller.status.value == "출금완료" ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
