import 'package:cashmore_app/app/module/mypage/controller/notice_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/notice_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissionBanner extends StatelessWidget {
  const MissionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 맞춘 텍스트 크기 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.04; // 화면 너비의 4%
    final subtitleFontSize = screenWidth * 0.035; // 화면 너비의 3.5%
    final buttonFontSize = screenWidth * 0.035;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.black38, // 테두리 색상 설정
          width: 1.0, // 테두리 두께 설정
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[오류발생] 꼭 확인해주세요!',
                  style: TextStyle(
                    fontSize: titleFontSize, // 동적으로 계산된 폰트 크기
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '어뷰징 및 부정행위 절대금지!!',
                  style: TextStyle(
                    fontSize: subtitleFontSize, // 동적으로 계산된 폰트 크기
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
               final noticeController = Get.find<NoticeController>();
              noticeController.moveToNoticeDetail(9);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // 버튼 배경 색상
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              '상세보기',
              style: TextStyle(
                fontSize: buttonFontSize, // 동적으로 계산된 버튼 텍스트 크기
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
