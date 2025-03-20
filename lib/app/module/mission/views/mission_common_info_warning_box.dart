import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';

class CommonInfoWarningBox extends StatelessWidget {
  const CommonInfoWarningBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 간격을 추가
      padding: const EdgeInsets.all(5.0), // 내부 패딩 설정
      decoration: BoxDecoration(
        color: sdPrimaryColor,
        borderRadius: BorderRadius.circular(8), // 테두리 둥글게 설정
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.black), // 정보 아이콘
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "저장 취소나 부정평가시, 포인트 몰수 및 서비스 이용 제한", // 전달받은 메시지를 표시
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
