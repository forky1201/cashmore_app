import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class AuthNewWebView extends StatefulWidget {
  final String url;

  const AuthNewWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<AuthNewWebView> createState() => _AuthNewWebViewState();
}

class _AuthNewWebViewState extends State<AuthNewWebView> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("본인인증"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: false);
          },
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true,
          useShouldOverrideUrlLoading: true,
          clearCache: false,
          //hardwareAcceleration: true, // 하드웨어 가속 사용
          //useHybridComposition: true, // Hybrid Composition 활성화
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final uri = navigationAction.request.url;

          // 필요한 URL만 허용
          if (uri != null && !uri.toString().contains("nice.checkplus.co.kr")) {
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop: (controller, url) async{
          if (url != null && url.toString().contains("nice.checkplus.co.kr")) {
          await controller.evaluateJavascript(source: """
            document.querySelectorAll('input').forEach(input => {
              input.addEventListener('focus', (event) => {
                event.stopPropagation();
              });
            });
          """);
        }

          if (url != null && url.toString().contains("api/getitmoney_auth")) {
            _handleAuthCallback(url.toString());
          }
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint("Console Message: ${consoleMessage.message}");
        },
      ),
    );
  }

  Future<void> _handleAuthCallback(String url) async {
    try {
      // 페이지 내용 가져오기
      String? pageContent = await _webViewController.evaluateJavascript(source: "document.querySelector('pre').innerText");

      if (pageContent != null && pageContent.isNotEmpty) {
        // UTF-8로 디코딩
        final decodedContent = utf8.decode(pageContent.codeUnits, allowMalformed: true);

        // JSON 문자열만 추출
        final jsonStartIndex = decodedContent.indexOf("</br>") + 5; // "</br>" 이후 데이터 추출
        final jsonString = decodedContent.substring(jsonStartIndex).trim();

        // JSON 데이터 파싱
        final jsonData = jsonDecode(jsonString);

        // status와 message를 확인
        final status = jsonData['status'];
        final message = jsonData['message'];

        if (status == 'success') {
          Get.back(result: jsonData);
        } else {
          Get.snackbar('오류', message ?? '인증 실패');
          Get.back(result: {'status': 'failure', 'message': message});
        }
      }
    } catch (e) {
      Get.snackbar('오류', '페이지에서 데이터를 처리하는 중 오류가 발생했습니다: $e');
      debugPrint("오류: $e");
    }
  }
}
