import 'dart:io';

import 'package:cashmore_app/app/module/main/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonMissionHeader extends StatelessWidget {
  final String missionTitle;
  final String missionPoints;
  final double avatarRadius;
  final String missionNumber;
  final String missionType;
  final String path;

  const CommonMissionHeader({
    super.key,
    required this.missionTitle,
    required this.missionPoints,
    required this.avatarRadius,
    required this.missionNumber,
    required this.missionType,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
           // 아이콘
          Image.asset(
            path, // PNG 파일 경로
            width: 48, // 적절한 크기 설정
            height: 48,
            fit: BoxFit.cover, // 이미지 크기 조정
          ),
          const SizedBox(width: 16),
          // 제목 및 포인트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  missionPoints,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          // "퀘스트 숨기기" 버튼
          ElevatedButton(
            onPressed: () {
              // 퀘스트 숨기기 로직 처리
              final mainController = Get.find<MainController>();
              mainController.saveHide(missionNumber, missionType);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.grey[300], // 배경 색상 설정
              elevation: 0, // 그림자 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 둥근 모서리
              ),
            ),
            child: const Text(
              '퀘스트 숨기기',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black, // 텍스트 색상
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
