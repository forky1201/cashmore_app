import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/point/views/point_list_view.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointReturnView extends GetView<PointController> {
  final numberFormat = NumberFormat('#,###'); // 숫자 포맷 설정: 천 단위 쉼표 추가

  PointReturnView({super.key});

  @override
  Widget build(BuildContext context) {
    return PointListView(
      itemList: controller.returnList,
      onRefresh: controller.refreshReturnList,
      fetchMoreItems: controller.fetchReturnList,
      isLoading: controller.isLoadingReturn.value,
      scrollController: controller.returnScrollController,
      emptyMessage: '반려 내역이 없습니다.',
    );
  }
}
