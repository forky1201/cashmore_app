import 'package:cashmore_app/app/module/mypage/controller/faq_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQView extends GetView<FAQController> {
  const FAQView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "FAQ", centerTitle: true, height: 85, splitLayout: true,),
      body: Obx(() {
        if (controller.isLoading.value) {
          // 로딩 중일 때 로딩바 표시
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.faqList.isEmpty) {
          // FAQ 리스트가 비어 있을 경우 메시지 표시
          return const Center(
            child: Text("FAQ 데이터가 없습니다."),
          );
        } else {
          // 데이터가 로드되면 FAQ 리스트 표시
          return ListView.builder(
            padding: EdgeInsets.only(left: 16, right: 16),
            itemCount: controller.faqList.length, // 컨트롤러의 faqList 길이 사용
            itemBuilder: (context, index) {
              return _buildFAQItem(
                question: controller.faqList[index].title!,
                answer: controller.faqList[index].content!,
              );
            },
          );
        }
      }),
    );
  }

  // 자주하는 질문 항목 생성
  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      shadowColor: Colors.white,
      color: Colors.white,
      //surfaceTintColor:Colors.white,
      elevation: 0, // 그림자 제거
      child: ExpansionTile(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.help_outline), // 아이콘 설정
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15), // 굵은 글씨체 설정
        ),
        children: [
          Container(
            //color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
