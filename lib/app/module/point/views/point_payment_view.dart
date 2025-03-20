import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/point/views/point_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointPaymentView extends GetView<PointController> {
  const PointPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return PointListView(
      itemList: controller.paymentList,
      onRefresh: controller.refreshPayments,
      fetchMoreItems: controller.fetchPayments,
      isLoading: controller.isLoadingPayments.value,
      scrollController: controller.paymentScrollController,
      emptyMessage: '지급 내역이 없습니다.',
    );
  }
}
