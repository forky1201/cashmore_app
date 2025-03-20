import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DialogUtils {
  /// WebView로 약관을 보여주는 팝업 창
  static Future<void> showWebViewDialog({
    required String title,
    required String url,
  }) async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        final WebViewController controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url));

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 팝업 상단 타이틀
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: sdPrimaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              // WebView로 약관 내용 표시
              SizedBox(
                height: 500,  // 팝업 높이 설정
                child: WebViewWidget(controller: controller),  // WebViewController 전달
              ),
              // 하단 닫기 버튼
              TextButton(
                onPressed: () {
                  Navigator.pop(context);  // 팝업 닫기
                },
                child: const Text(
                  '닫기',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 사업자 정보 다이얼로그 표시
  static Future<void> showInfoDialog() async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 팝업 상단 타이틀
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                 color: sdPrimaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Text(
                  '사업자 정보',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              // 사업자 정보 내용
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상호: 주식회사 겟잇머니'),
                    Text('대표이사: 이향의'),
                    Text('사업자등록번호: 166-81-03247'),
                    Text('통신판매업신고번호: 제2025-서울송파-0126호'),
                    Text('주소: 서울특별시 송파구 법원로 128, 씨동 지114-에스72호(문정동, 문정역SKV1)'),
                    Text('이메일: info@getitmoney.co.kr'),
                  ],
                ),
              ),
              // 하단 닫기 버튼
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '닫기',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
