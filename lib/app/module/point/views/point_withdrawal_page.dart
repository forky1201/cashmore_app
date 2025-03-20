import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashmore_app/app/module/point/controller/point_withdrawal_controller.dart';

class PointWithdrawalPage extends GetView<PointWithdrawalController> {
  const PointWithdrawalPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: "포인트 출금",
        centerTitle: true,
        splitLayout: true,
        height: 85,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            _buildAccountVerificationBox(), // 통장 인증 박스
            const SizedBox(height: 24.0),
            _buildWithdrawAmountDropdown(context), // 출금 금액 드롭다운
            const SizedBox(height: 16.0),
            _buildPointsInfo(), // 출금 관련 정보
            const Spacer(),
            _buildWithdrawButton(), // 출금하기 버튼
          ],
        ),
      ),
    );
  }

  // 1. 통장 인증 박스
  Widget _buildAccountVerificationBox() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.accountVerified.value ? '통장 인증이 완료되었습니다.' : '통장 인증이 필요합니다.',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: controller.accountVerified.value
                  ? null // 인증 완료 상태에서는 버튼 비활성화
                  : () async {
                      await controller.verifyAccount();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.accountVerified.value ? Colors.grey : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              ),
              child: Text(
                controller.accountVerified.value ? '통장 인증 완료' : '통장 인증',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }


  // 2. 출금 금액 드롭다운
  Widget _buildWithdrawAmountDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '출금 금액',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Obx(() {
          double fontSize = MediaQuery.of(context).size.width * 0.04; // 화면 너비의 4%를 텍스트 크기로 사용
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value: controller.withdrawAmount.value,
              isExpanded: true,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  value: '11000',
                  child: Text(
                    '10,000원(=11,000P)부터 가능합니다.',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
                // DropdownMenuItem(
                //   value: '55000',
                //   child: Text(
                //     '50,000원(=55,000P)',
                //     style: TextStyle(fontSize: fontSize),
                //   ),
                // ),
                // DropdownMenuItem(
                //   value: '110000',
                //   child: Text(
                //     '100,000원(=110,000P)',
                //     style: TextStyle(fontSize: fontSize),
                //   ),
                // ),
              ],
              onChanged: (value) {
                controller.selectWithdrawAmount(value!); // 선택한 출금 금액 변경
              },
            ),
          );
        }),
      ],
    );
  }

  // 3. 포인트 정보 및 안내 텍스트
  Widget _buildPointsInfo() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              '보유 포인트 ${controller.totalPoint} P',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '● 수수료는 출금 금액의 10%입니다.',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 4.0),
                Text(
                  '● 출금 신청 후 실제 출금까지 최대 48시간(영업일 기준)이 소요될 수 있습니다.',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  // 4. 출금하기 버튼
  Widget _buildWithdrawButton() {
    return Obx(() {
      return ElevatedButton(
        onPressed: controller.withdrawVerifed.value
            ? () async{
                 await controller.requestWithdrawal(); // 출금하기 요청
              }
            : null, // 통장 인증이 완료되지 않았으면 비활성화
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          '출금하기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });
  }
}
