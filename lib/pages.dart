import 'package:cashmore_app/app/module/account/controller/account_password_controller.dart';
import 'package:cashmore_app/app/module/account/controller/signup_controller.dart';
import 'package:cashmore_app/app/module/account/view/account_password_page.dart';
import 'package:cashmore_app/app/module/account/view/signup_view.dart';
import 'package:cashmore_app/app/module/home/controller/home_controller.dart';
import 'package:cashmore_app/app/module/home/views/home_view.dart';
import 'package:cashmore_app/app/module/intro/controller/session_controller.dart';
import 'package:cashmore_app/app/module/intro/view/intro_page.dart';
import 'package:cashmore_app/app/module/account/controller/find_account_controller.dart';
import 'package:cashmore_app/app/module/account/controller/find_account_result_controller.dart';
import 'package:cashmore_app/app/module/login/controller/login_controller.dart';
import 'package:cashmore_app/app/module/account/view/find_account_result_view.dart';
import 'package:cashmore_app/app/module/account/view/find_account_view.dart';
import 'package:cashmore_app/app/module/login/view/login_view.dart';
import 'package:cashmore_app/app/module/mission/controller/mission_controller.dart';
import 'package:cashmore_app/app/module/mission/controller/mission_detail_controller.dart';
import 'package:cashmore_app/app/module/mission/views/mission_detail_answer_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_detail_capture_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_detail_normal_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_detail_share_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_detail_special_view.dart';
import 'package:cashmore_app/app/module/mission/views/mission_view.dart';
import 'package:cashmore_app/app/module/mypage/controller/account_management_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/faq_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/myInfo_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/mypage_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/notice_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/notice_detail_controller.dart';
import 'package:cashmore_app/app/module/mypage/controller/recommendation_controller.dart';
import 'package:cashmore_app/app/module/mypage/views/account_management_view.dart';
import 'package:cashmore_app/app/module/mypage/views/faq_view.dart';
import 'package:cashmore_app/app/module/mypage/views/myInfo_view.dart';
import 'package:cashmore_app/app/module/mypage/views/mypage_view.dart';
import 'package:cashmore_app/app/module/mypage/views/notice_detail_view.dart';
import 'package:cashmore_app/app/module/mypage/views/notice_view.dart';
import 'package:cashmore_app/app/module/mypage/views/recommendation_view.dart';
import 'package:cashmore_app/app/module/point/controller/coupon_controller.dart';
import 'package:cashmore_app/app/module/point/controller/point_controller.dart';
import 'package:cashmore_app/app/module/point/controller/point_withdrawal_controller.dart';
import 'package:cashmore_app/app/module/point/controller/withdrawal_controller.dart';
import 'package:cashmore_app/app/module/point/views/coupon_view.dart';
import 'package:cashmore_app/app/module/point/views/point_view.dart';
import 'package:cashmore_app/app/module/point/views/point_withdrawal_page.dart';
import 'package:cashmore_app/app/module/point/views/withdrawal_view.dart';
import 'package:cashmore_app/app/module/splash/controller/splash_controller.dart';
import 'package:cashmore_app/app/module/splash/view/splash_page.dart';
import 'package:cashmore_app/app/module/store/controller/brand_controller.dart';
import 'package:cashmore_app/app/module/store/controller/goods_detail_controller.dart';
import 'package:cashmore_app/app/module/store/views/brand_view.dart';
import 'package:cashmore_app/app/module/store/views/goods_detail_view.dart';

import 'package:get/get.dart';


class Pages {
  Pages._();
  static const initial = "/splash";

  static final routes = [
    GetPage(
      name: "/splash",
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => SplashController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/intro",
      page: () => const IntroPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => SessionController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/login",   //로그인
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => LoginController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/find_account",  //아이디 찾기
      page: () => const FindAccountPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => FindAccountController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/find_account_result", //아이디 찾기 확인
      page: () => const FindAccountResultPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => FindAccountResultController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/reset_password", //비밀번호 재설정
      page: () => const AccountPasswordPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => AccountPasswordController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/signup", //회원가입
      page: () => const SignupPage(),
      binding: BindingsBuilder(() {Get.lazyPut(() => SignupController());}),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: "/home",
      page: () => HomePage(),  // 홈 페이지(),
      binding: BindingsBuilder(() {Get.lazyPut(() => HomeController());}),
      transition: Transition.cupertino,
    ),
     GetPage(
      name: "/point",
      page: () => PointPage(),  //포인트관리
      binding: BindingsBuilder(() {Get.lazyPut(() => PointController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/coupon",
      page: () => CouponView(), //쿠폰내역
      binding: BindingsBuilder(() {Get.lazyPut(() => CouponController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/withdrawal",
      page: () => const WithdrawalPage(), //출금내역
      binding: BindingsBuilder(() {Get.lazyPut(() => WithdrawalController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/pointWithdrawal",
      page: () => const PointWithdrawalPage(), //포인트출금
      binding: BindingsBuilder(() {Get.lazyPut(() => PointWithdrawalController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mission",    
      page: () => const MissionPage(), //미션
      binding: BindingsBuilder(() {Get.lazyPut(() => MissionController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mission_answer",    
      page: () => const MissionDetailAnswerView(),
      binding: BindingsBuilder(() {Get.lazyPut(() => MissionDetailController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mission_share",    
      page: () => const MissionDetailShareView(),
      binding: BindingsBuilder(() {Get.lazyPut(() => MissionDetailController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mission_normal",    
      page: () => const MissionDetailNormalView(),
      binding: BindingsBuilder(() {Get.lazyPut(() => MissionDetailController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mission_special",    
      page: () => const MissionDetailSpecialView(),
      binding: BindingsBuilder(() {Get.lazyPut(() => MissionDetailController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mission_capture",    
      page: () => const MissionDetailCaptureView(),
      binding: BindingsBuilder(() {Get.lazyPut(() => MissionDetailController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/mypage",    
      page: () => const MyPage(), //마이페이지
      binding: BindingsBuilder(() {Get.lazyPut(() => MyPageController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/notice",    
      page: () => const NoticePage(), //공지사항
      binding: BindingsBuilder(() {Get.lazyPut(() => NoticeController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/notice_detail",    
      page: () => const NoticeDetailView(), //공지사항 상세
      binding: BindingsBuilder(() {Get.lazyPut(() => NoticeDetailController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/myInfo",    
      page: () => const MyInfoView(), //내정보
      binding: BindingsBuilder(() {Get.lazyPut(() => MyInfoController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/faq",    
      page: () => const FAQView(), //faq
      binding: BindingsBuilder(() {Get.lazyPut(() => FAQController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/recommen",    
      page: () => const RecommendationView(), //추천인
      binding: BindingsBuilder(() {Get.lazyPut(() => RecommendationController());}),
      transition: Transition.cupertino,
    ),
   GetPage(
      name: "/settings",    
      page: () => const AccountManagementView(), //셋팅
      binding: BindingsBuilder(() {Get.lazyPut(() => AccountManagementController());}),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/brandView",
      page: () => BrandView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BrandController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: "/goodsDetail",
      page: () => GoodsDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GoodsDetailController());
      }),
      transition: Transition.cupertino,
    ),
  ];
}
