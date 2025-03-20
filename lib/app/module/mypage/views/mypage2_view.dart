import 'package:cashmore_app/app/module/mypage/controller/mypage_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cashmore_app/app/extensions/datetime_extension.dart';
import 'package:get/get.dart';

class MyPage2 extends GetView<MyPageController> {
  const MyPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "", height: 17,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 사용자 정보 표시
                        Obx(() => Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.version.value, // 왼쪽 끝에 버전 정보 표시
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    controller.userName.value,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Text(
                                    controller.userEmail.value,
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ],
                            )),

                        const SizedBox(height: 20),

                        // 메뉴 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMenuButton("assets/icons/person_icon.svg", '내 정보', '/myInfo'),
                            _buildMenuButton("assets/icons/faq_icon.svg", 'FAQ', '/faq'),
                            _buildMenuButton("assets/icons/people_icon.svg", '추천인', '/recommen'),
                            _buildMenuButton("assets/icons/settings_icon.svg", '앱 설정', '/settings'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 공지사항 섹션
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 16, ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '공지사항',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //const SizedBox(width: 30),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  controller.movePage("/notice");
                                },
                              ),
                            ],
                          ),
                        ),

                        // 공지사항 리스트
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: Container(
                            //width: Get.width * 0.9,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Obx(() => ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.notices.length,
                                  itemBuilder: (context, index) {
                                    final notice = controller.notices[index];
                                    return GestureDetector(
                                      onTap: () => controller.moveToNoticeDetail(notice.id),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notice.title ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  //fontSize: Get.width * 0.04,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            notice.elapsed_days == 0
                                                ? Text(
                                                    '오늘',
                                                    style: const TextStyle(color: Colors.grey),
                                                  )
                                                : Text(
                                                    '${notice.elapsed_days}일 전',
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // 배너 클릭 시 팝업창 표시
              GestureDetector(
                onTap: () => _showInquiryPopup(context),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32, // 공지사항 위젯과 동일한 너비로 설정
                  margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16), // 공지사항 패딩과 동일
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), // 공지사항과 동일한 둥근 모서리
                  ),
                  child: Image.asset(
                    'assets/images/mypageBanner2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            ],
          );
        }
      }),
    );
  }

  void _showInquiryPopup(BuildContext context) {
    String selectedCategory = "광고"; // 기본 선택 값
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showModalBottomSheet(
      backgroundColor:Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 32.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 제목
                const Text(
                  "문의하기",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "해당 내용을 입력해주세요.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // 문의 종류 Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ["광고", "제휴"].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedCategory = value;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "문의 종류",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 제목 입력 필드
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "제목",
                    border: OutlineInputBorder(),
                    hintText: "제목을 입력하세요",
                  ),
                ),
                const SizedBox(height: 16),

                // 내용 입력 필드
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "내용",
                    border: OutlineInputBorder(),
                    hintText: "내용을 입력하세요",
                  ),
                ),
                const SizedBox(height: 24),

                // 버튼 영역 (취소, 제출)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "취소",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        onPressed: () {
                          final inquiry = {
                            "category": selectedCategory,
                            "title": titleController.text,
                            "content": contentController.text,
                          };
                          // 컨트롤러 메서드 호출 (입력값 처리)
                          controller.submitInquiry(inquiry);
                          Navigator.of(context).pop(); // 팝업 닫기
                        },
                        child: const Text(
                          "제출",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // 메뉴 버튼 위젯
  Widget _buildMenuButton(String path, String label, String route) {
    return GestureDetector(
      onTap: () => controller.movePage(route),
      child: Container(
        width: Get.width * 0.2,
        height: Get.height * 0.13,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(path, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.width * 0.03,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
