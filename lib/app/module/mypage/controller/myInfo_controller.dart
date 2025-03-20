import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/common/toast_message.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';  // AppService 임포트
import 'package:get/get.dart';

class MyInfoController extends BaseController {
  AppService appService = Get.find<AppService>();
  final AuthRepository authRepository = AuthRepository();
  final MypageRepsitory mypageRepsitory = MypageRepsitory();
  
  // 사용자 정보
  var userName = ''.obs;  // 사용자 이름
  var userId = ''.obs;  // 사용자 ID
  var phoneNumber = ''.obs;  // 사용자 연락처
  
  // 연락처 변경 여부
  var isPhoneNumberChanged = false.obs; // 연락처가 변경되었는지 여부

  // 체크박스 상태
  var marketingConsent = false.obs;  // 마케팅 정보 수신 동의 여부
  var serviceAlertConsent = false.obs;  // 서비스알림 수신 동의 여부

    // 기존 상태 저장
  bool? originalMarketingConsent;
  bool? originalServiceAlertConsent;

  // onInit: 컨트롤러가 생성될 때 실행되는 함수
  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();  // 사용자 정보 가져오기
  }

  // API 호출을 통해 사용자 정보를 가져오는 함수
  Future<void> fetchUserInfo() async {
    try {
      LoggedIn userInfo = await authRepository.loggedIn(AppService.to.userId!);

      UserModel user = userInfo.data;

      userName.value = user.user_name ?? '이름 없음';  // 사용자 이름 설정
      userId.value = user.user_id ?? 'ID 없음';  // 사용자 ID 설정
      phoneNumber.value = user.user_hp.toString() ?? '전화번호 없음';  // 연락처 설정

      marketingConsent.value = user.marketing == 0;  // 0이면 true, 1이면 false
      serviceAlertConsent.value = user.service_alert == 0;  // 0이면 true, 1이면 false

       // 초기 상태 저장
      originalMarketingConsent = marketingConsent.value;
      originalServiceAlertConsent = serviceAlertConsent.value;
    } catch (e) {
      // 에러 발생 시 처리
      print('사용자 정보를 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 연락처 변경 함수
  void changeContact() {
    Map<String, dynamic> requestBody = {
        "user_id": userName.value,
        "user_hp": phoneNumber.value,
      };

      try{
        final res = mypageRepsitory.updateUserInfo(requestBody);

        AppService.to.loginInfoRefresh();
        Get.back();

      }catch (e){
        print('오류가 발생했습니다: $e');
      }

  }

  // 비밀번호 수정 함수
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      Map<String, dynamic> requestBody = {
        "user_id": userId.value,
        "user_pw": newPassword,
      };

      final response = await mypageRepsitory.updateUserInfo(requestBody);

      AppService.to.loginInfoRefresh();
      Get.back();

    } catch (e) {
      print('비밀번호 변경 중 오류 발생: $e');
      Get.snackbar('오류', '비밀번호 변경에 실패했습니다.');
    }
  }

  // 수정하기 버튼 클릭 시 정보 업데이트 함수
  Future<void> updateInfo() async {
    
    // 기존 값과 현재 값을 비교하여 동일하면 알림만 표시하고 종료
    if (originalMarketingConsent == marketingConsent.value &&
        originalServiceAlertConsent == serviceAlertConsent.value) {
      Get.snackbar('알림', '수정할 내역이 없습니다.');
      return;
    }

    try {
      Map<String, dynamic> requestBody = {
        "user_id": userId.value,
        "marketing": marketingConsent.value ? 0 : 1,  // true -> 0, false -> 1
        "service_alert": serviceAlertConsent.value ? 0 : 1,  // true -> 0, false -> 1
      };

      final res = await mypageRepsitory.updateUserInfo(requestBody);
      AppService.to.loginInfoRefresh();
      // 수정 후 원래 값 업데이트
      originalMarketingConsent = marketingConsent.value;
      originalServiceAlertConsent = serviceAlertConsent.value;
      //Get.snackbar('알림', '수정이 완료 되었습니다.');
      ToastMessage.show("수정이 완료 되었습니다.");
      //Get.offNamed("/mypage");
       // 이전 화면으로 돌아가기
      Future.delayed(Duration(seconds: 1), () {
        Get.back();
      });

    } catch (e) {
      print('정보 업데이트 중 오류가 발생했습니다: $e');
      Get.snackbar('오류', '정보 업데이트 중 문제가 발생했습니다.');
    }
  }
}
