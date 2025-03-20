import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/point/views/point_list_view.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointWaitView extends GetView<PointController> {
  PointWaitView({super.key});

  @override
  Widget build(BuildContext context) {
    return PointListView(
      itemList: controller.waitList,
      onRefresh: controller.refreshWaitList,
      fetchMoreItems: controller.fetchWaitList,
      isLoading: controller.isLoadingWait.value,
      scrollController: controller.waitScrollController,
      emptyMessage: '지급 내역이 없습니다.',
    );
  }
}
