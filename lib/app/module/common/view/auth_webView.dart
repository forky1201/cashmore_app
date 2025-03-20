import 'dart:convert';

import 'package:cashmore_app/common/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class AuthWebView extends StatefulWidget {
  final String url;

  AuthWebView({required this.url});

  @override
  _AuthWebViewState createState() => _AuthWebViewState();
}

class _AuthWebViewState extends State<AuthWebView> {
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
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url?.toString() ?? "";

          if (url.startsWith("intent://")) {
            await _handleIntentUrl(url);
            return NavigationActionPolicy.CANCEL;
          } else if (url.startsWith("https://play.google.com/store/apps/details?id=") || url.startsWith("market://details?id=")) {
            await _launchPlayStoreUrl(Uri.parse(url));
            return NavigationActionPolicy.CANCEL;
          }

          if(url.startsWith("https://itunes.apple.com/kr/app/id1147394645")){
            await _launchPlayStoreUrl(Uri.parse(url));
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
        onLoadStop: (controller, url) async {
          debugPrint("페이지 로드 완료: $url");
          if (url != null && url.toString().contains("api/getitmoney_auth")) {
            _handleAuthCallback(url.toString());
          }

          if (url.toString().contains("api/input_a")) {
            // meta viewport 태그를 동적으로 추가
            await controller.evaluateJavascript(source: """
              var meta = document.createElement('meta');
              meta.name = "viewport";
              meta.content = "width=device-width, initial-scale=1.0, maximum-scale=3.0, minimum-scale=0.5";
              document.getElementsByTagName('head')[0].appendChild(meta);
            """);
          }

          if (url.toString().contains("api/getitmoney_request")) {
            _handleAuthAccountCallback(url.toString());
          }

        },
        onLoadError: (controller, url, code, message) {
          debugPrint("페이지 로드 오류: $url, 에러 코드: $code, 메시지: $message");
          Get.snackbar(
            '오류',
            '페이지 로드 실패: $message',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
    );
  }

  Future<void> _handleIntentUrl(String url) async {
    try {
      final intentUrl = Uri.parse(url.replaceAll("intent://", "https://"));

      if (await canLaunchUrl(intentUrl)) {
        await launchUrl(intentUrl, mode: LaunchMode.externalApplication);
      } else {
        // Play Store URL로 변환
        final packageName = Uri.parse(url).queryParameters['package'];
        if (packageName != null && packageName.isNotEmpty) {
          final playStoreUrl = Uri.parse("https://play.google.com/store/apps/details?id=$packageName");
          await _launchPlayStoreUrl(playStoreUrl);
        } else {
          Get.snackbar("오류", "앱 실행에 실패했습니다.");
        }
      }
    } catch (e) {
      Get.snackbar("오류", "Intent URL 처리 실패: $e");
    }
  }

  Future<void> _launchPlayStoreUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("오류", "Play Store를 열 수 없습니다.");
      }
    } catch (e) {
      Get.snackbar("오류", "Play Store URL 처리 실패: $e");
    }
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

   // 계좌 인증 콜백 처리
  Future<void> _handleAuthAccountCallback(String url) async {
    try {
      // 페이지 내용 가져오기
      String? pageContent = await _webViewController.evaluateJavascript(source: "document.querySelector('pre').innerText");

      if (pageContent != null && pageContent.isNotEmpty) {

        // UTF-8로 디코딩
        final decodedContent = utf8.decode(pageContent.codeUnits, allowMalformed: true);

        
        final jsonString = decodedContent.trim();


        logger.i("jsonString====>> " + jsonString.toString());

          // JSON 데이터 파싱
        final jsonData = jsonDecode(jsonString);

        // JSON 데이터 추출
        //final jsonData = jsonDecode(jsonString);

        // status 값 가져오기
        //final status = jsonData['status'];
        //final message = jsonData['message'];

        // 인증 상태 처리
        /*if (status == 'success') {
              Get.back(result:data);
            } else {
              Get.back(result: {
                'status': status ?? 'failure',
                'message': message ?? '인증 실패',
              });
            }*/
        Get.back(result: jsonData);
      }
    } catch (e) {
      Get.snackbar('오류', '페이지에서 데이터를 처리하는 중 오류가 발생했습니다: $e');
      logger.e("오류", e);
    }
  }
}
