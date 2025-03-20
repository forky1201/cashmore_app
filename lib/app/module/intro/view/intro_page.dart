import 'dart:io';

import 'package:cashmore_app/app/module/intro/controller/session_controller.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends GetView<SessionController> {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sdPrimaryColor, // 배경색 설정
      body: Stack(
        children: [
          // 1. 상단의 로고 이미지
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,  // 화면 높이의 30% 위치에 로고 배치
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',  // 로고 이미지 경로
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
          // 2. 하단의 로그인 버튼들
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,  // 최소 크기의 Column으로 설정
                children: [
                  // 2.1 기본 로그인 버튼
                  _buildLoginButton(
                    'D',
                    Colors.black,
                    Colors.white,
                    null,  // 이미지가 없는 경우 null 전달
                  ),
                  const SizedBox(height: 12),

                 

                  // 2.2 네이버 로그인 버튼 (이미지 추가)
                  /*_buildLoginButton(
                    'N',
                    Colors.green,
                    Colors.white,
                    'assets/images/naver_icon.png',  // 네이버 아이콘 경로
                  ),
                  const SizedBox(height: 12),
                  */

                  // 2.3 카카오 로그인 버튼 (이미지 추가)
                  _buildLoginButton(
                    'K',
                    Colors.yellow[600]!,
                    Colors.black,
                    'assets/images/ic_kakao.png',  // 카카오톡 아이콘 경로
                  ),
                  if (Platform.isIOS) 
                  const SizedBox(height: 12),

                  if (Platform.isIOS) 
                   _buildLoginButton(
                    'I',
                    Colors.black,
                    Colors.white,
                    'assets/images/ic_apple.png', // 아이콘 경로
                  ),
                  

                  // 2.4 구글 로그인 버튼 (이미지 추가)
                  /*_buildLoginButton(
                    'G',
                    Colors.white,
                    Colors.black,
                    'assets/images/google_icon.png',  // 구글 아이콘 경로
                  ),
                  const SizedBox(height: 32),  // 버튼과 화면 하단의 간격
                  */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 로그인 버튼 위젯
  Widget _buildLoginButton(String type, Color backgroundColor, Color textColor, String? imagePath) {
    String text = "";
    if (type == "D") {
      text = "로그인";
    } else if (type == "N") {
      text = "네이버 로그인";
    } else if (type == "K") {
      text = "카카오톡으로 로그인";
    } else if (type == "G") {
      text = "구글 로그인";
    } else if (type == "I") {
      text = "Apple로 로그인";
    }

    return ElevatedButton(
      onPressed: () {
        //로그인 페이지 이동
        controller.movePage(type);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // 버튼 배경색
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),  // 둥근 모서리
          side: const BorderSide(
            color: Colors.black, // 검은색 테두리 색상
            width: 2.0,          // 테두리 두께
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬
        children: [
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),  // 이미지와 텍스트 사이 간격을 맞추기 위해 조정
              child: Image.asset(
                imagePath,
                width: 24,  // 아이콘 너비
                height: 24,  // 아이콘 높이
              ),
            ),
          // 버튼 텍스트
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,  // 텍스트 색상 설정
            ),
          ),
        ],
      ),
    );
  }
}
