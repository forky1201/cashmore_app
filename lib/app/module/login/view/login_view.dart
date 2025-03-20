import 'dart:io';

import 'package:cashmore_app/app/module/login/controller/login_controller.dart';
import 'package:cashmore_app/app/widgets/common_app_bar.dart';
import 'package:cashmore_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "로그인",  // AppBar에서 타이틀을 비워 둠
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  // SingleChildScrollView로 전체 화면 감싸기
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // 이메일 입력 필드
              const Text(
                "이메일 *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  hintText: '이메일을 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              const SizedBox(height: 24),
              // 비밀번호 입력 필드
              const Text(
                "비밀번호 *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호를 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              const SizedBox(height: 32),
              // 로그인 버튼
              ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),  // 버튼의 높이 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              /*if (Platform.isIOS) 
              const SizedBox(height: 16),
              
              if (Platform.isIOS) 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50), // 버튼의 높이 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      controller.appleLogin();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Align(
                            child: Image.asset("assets/images/ic_apple.png"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 15.0),
                            child: const Text(
                              "Apple로 로그인",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //카카오
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[600],
                      minimumSize: const Size(double.infinity, 50), // 버튼의 높이 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      controller.kakaoLogin();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Align(
                            child: Image.asset("assets/images/ic_kakao.png"),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 15.0),
                            child: const Text(
                              "카카오톡으로 로그인",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),*/
              const SizedBox(height: 16),
              // 회원가입 버튼
              OutlinedButton(
                onPressed: () {
                  controller.moveToUrl("/signup");  // 회원가입 페이지로 이동
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),  // 버튼의 높이 설정
                  side: const BorderSide(color: Colors.black),  // 테두리 색상 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              // 아이디/비밀번호 찾기 텍스트 버튼
              Center(
                child: TextButton(
                  onPressed: () {
                    controller.moveToUrl("/find_account");
                  },
                  child: const Text(
                    '아이디 / 비밀번호 찾기',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
