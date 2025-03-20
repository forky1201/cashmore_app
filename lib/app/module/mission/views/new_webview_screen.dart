import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NewWebViewScreen extends StatelessWidget {
  final String initialUrl;

  NewWebViewScreen({required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새 WebView"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
      ),
    );
  }
}
