import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/common/model/point_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointListView extends StatelessWidget {
  final RxList<PointModel> itemList; // 트랜잭션 리스트
  final Future<void> Function() onRefresh; // 새로고침 함수
  final void Function() fetchMoreItems; // 추가 데이터 로드 함수
  final bool isLoading; // 로딩 상태
  final ScrollController scrollController; // 스크롤 컨트롤러
  final String emptyMessage; // 빈 상태 메시지

  const PointListView({
    super.key,
    required this.itemList,
    required this.onRefresh,
    required this.fetchMoreItems,
    required this.isLoading,
    required this.scrollController,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: Colors.white,
        child: Obx(() {
          // groupedTransactions를 Obx 내부에서 계산
          final groupedTransactions = _groupByDate(itemList);

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading) {
                  fetchMoreItems();
                }
                return false;
              },
              child: groupedTransactions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: groupedTransactions.length,
                      itemBuilder: (context, index) {
                        final dateGroup = groupedTransactions.keys.elementAt(index);
                        final transactions = groupedTransactions[dateGroup]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 날짜 헤더
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                dateGroup,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            // 트랜잭션 아이템
                            ...transactions.map((transaction) {
                              final isDeposit = transaction.point! > 0;

                              return Column(
                                children: [
                                  _buildTransactionItem(
                                    transaction.subject,
                                    isDeposit ? '+${transaction.point}P' : '${transaction.point}P',
                                    isDeposit ? '지급' : '차감',
                                    isDeposit ? Colors.green : Colors.red,
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
          );
        }),
      ),
    );
  }

  // 날짜별 그룹화
  Map<String, List<PointModel>> _groupByDate(List<PointModel> items) {
    final grouped = <String, List<PointModel>>{};
    for (var item in items) {
      final formattedDate = DateFormat('yyyy.MM.dd').format(DateTime.parse(item.regdate.toString()));
      grouped.putIfAbsent(formattedDate, () => []).add(item);
    }
    return grouped;
  }

  // 개별 트랜잭션 아이템
  Widget _buildTransactionItem(String? description, String points, String status, Color pointColor) {
    // 상태에 따라 다른 아이콘 설정 (예: 지급/차감)
    IconData iconData = status == '지급' ? Icons.arrow_circle_up : Icons.arrow_circle_down;
    Color iconColor = status == '지급' ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            iconData, // 지급/차감에 따라 다른 아이콘
            size: 24,
            color: iconColor, // 지급은 초록색, 차감은 빨간색
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description ?? '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: pointColor),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // 빈 상태 UI
  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 64.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
