import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Variable
const kAccessToken = 'token';
const kRefreshToken = 'refreshToken';
const kAuthorization = 'Authorization';
const currentUserId = 'userId';
const currentUser = 'currentUser';
const currentTotalPoint = 'totalPoint';
const currentUserName = 'userName';
const currentSnstype = 'snstype';

//퀘스트 메뉴
bool answerYn = true;
bool shareYn = true;
bool normalYn = true;
bool spYn = true;

const domain = "https://getitmoney.co.kr";

const sdPrimaryColor = Color.fromRGBO(255, 218, 72, 1.0);
const sdPointColor = Color(0xFF27a588);
const sdStatusBarColor = Color(0xFF7AD88D);

const sdGray0 = Color(0xFFFFFFFF);
const sdGray1 = Color(0xFFF6F9FB);
const sdGray2 = Color(0xFFE2EBF1);
const sdGray3 = Color(0xFFD1DCE3);
const sdGray4 = Color(0xFFB8C3C9);
const sdGray5 = Color(0xFF9DABB4);
const sdGray6 = Color(0xFF88959D);
const sdGray7 = Color(0xFF727D85);
const sdGray8 = Color(0xFF6A727A);
const sdGray9 = Color(0xFF474E53);
const sdGray10 = Color(0xFF14181C);
const sdRed = Color(0xFFE94563);
const sdTransparent = Color(0x00000000);
const Color white = Colors.white;
const Color black = Colors.black;

const gestinyGray4 = Color(0xFFB4C4CC);
const gestinyGray6 = Color(0xFFD9D9D9);

const bgFacebook = Color(0xFF1877F2);
const bgPhoneNumber = Color(0xFF008A69);
const dark = Colors.black;

const light = Color(0xFFFAFAFA);

/// Grey background accent.
const grey = Color(0xFF262626);

/// Primary text color
const primaryText = Colors.white;

/// Secondary color.
const secondary = Color(0xFF0095F6);

/// Color to use for favorite icons (indicating a like).
const like = Colors.red;

/// Grey faded color.
const faded = Colors.grey;

/// Light grey color
const ligthGrey = Color(0xFFEEEEEE);

/// Top gradient color used in various UI components.
const topGradient = Color(0xFFE60064);

/// Bottom gradient color used in various UI components.
const bottomGradient = Color(0xFFFFB344);

// 디바이스의 전체 크기 정보를 가져오기 위해 MediaQuery 사용
var screenWidth = Get.width; // Get.width는 화면의 가로 크기를 반환
var screenHeight = Get.height; // Get.height는 화면의 세로 크기를 반환

//RegExp
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneValidatorRegExp = RegExp(r"^010([0-9]{4})([0-9]{4})$");
// final RegExp passwordValidatorRegExp = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
final RegExp passwordValidatorRegExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\w\W]{4,15}$"); // 문자+숫자 4~15자리

//SNS KEY
const String appleKey = "A";
const String googleKey = "G";
const String facebookKey = "F";

const double common_l_gap = 16.0;
const double common_gap = 14.0;
const double common_s_gap = 12.0;
const double common_xs_gap = 10.0;
const double common_xxs_gap = 8.0;

const double avatar_size = 30.0;

const double titleSize = 20.0;

const double hearderHeight = 72.0;

const int constPageSizeInformation = 20;

const int constPageSizeReview = 20;

const String NAVER_PALCE_ARAR = "cm000"; //플레이스 알림받기
const String NAVER_PALCE_SAVE = "cm001"; //플레이스 저장하기
const String NAVER_PALCE_KEEP = "cm002"; //플레이스 네이버 킵
const String NAVER_PALCE_BLOG = "cm003"; //플레이스 블로그 공유하기
const String KAKAO_GIFT_LIKE = "cm004"; //선물하기 상품 찜
const String KAKAO_GIFT_REVIEW = "cm005"; //선물하기 리뷰 공감
const String RANK_UP_QUEST = "cm006"; //랭크올리기 퀘스트
const String MUSINSA_PROD_LIKE = "cm008"; //무신사 상품 찜
const String MUSINSA_BRAND_LIKE = "cm009"; //무신사 브랜드 찜
const String NAVER_SMART_PROD_LIKE = "cm010"; //스마트스토어 상품 찜
const String NAVER_SMART_ARAR = "cm011"; //스마트스토어 소식받기
const String OLIVE_PROD_LIKE = "cm012"; //올리브영 상품 찜
const String OLIVE_BRAND_LIKE = "cm013"; //올리브영 브랜드 찜
const String NOW_PROD_LIKE = "cm014"; //오늘의집 상품 찜

abstract class AppTextStyle {
  /// A medium bold text style.
  static const textStyleBoldMedium = TextStyle(
    fontWeight: FontWeight.w600,
  );

  /// A bold text style.
  static const textStyleBold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const textStyleSmallBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  /// A faded text style. Uses [AppColors.faded].
  static const textStyleFaded = TextStyle(color: faded, fontWeight: FontWeight.w400);

  /// A faded text style. Uses [AppColors.faded].
  static const textStyleFadedSmall = TextStyle(color: faded, fontWeight: FontWeight.w400, fontSize: 11);

  /// A faded text style. Uses [AppColors.faded].
  static const textStyleFadedSmallBold = TextStyle(color: faded, fontWeight: FontWeight.w500, fontSize: 11);

  /// Light text style.
  static const textStyleLight = TextStyle(fontWeight: FontWeight.w300);

  /// Action text
  static const textStyleAction = TextStyle(
    fontWeight: FontWeight.w700,
    color: secondary,
  );

  //boarder
  static const textBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(
      color: sdGray5,
    ),
  );

  //test
  static const textStyleContent = TextStyle(
    //fontWeight: FontWeight.w700,
    //color: secondary,
    fontSize: 18,
    fontFamily: 'SUIT',
  );

  static const textStyleContentTitle = TextStyle(
    //fontWeight: FontWeight.w700,
    //color: secondary,
    fontSize: 18,
    fontFamily: 'SUIT',
  );

  static TextStyle textStyleContent1 = TextStyle(
    fontWeight: FontWeight.w600,
    //color: secondary,
    fontSize: 12.sp,
    fontFamily: 'SUIT',
  );
}
