import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/board_model.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:get/get.dart';

class FAQController extends BaseController {
  // FAQ 리스트를 관리하는 변수
  final appService = Get.find<AppService>();
  MypageRepsitory mypageRepsitory = MypageRepsitory();
  int pageSize = 20;
  
  var faqList = <BoardModel>[].obs;  // FAQ 리스트
  var isLoading = true.obs;          // 로딩 상태 변수

  @override
  void onInit() {
    super.onInit();
    fetchFAQData(); // 초기 데이터 로드
  }

  // API를 이용해 데이터 로드 함수
  Future<void> fetchFAQData() async {
    try {
      isLoading.value = true; // 데이터 로딩 시작
      List<BoardModel> list = await mypageRepsitory.boardList(AppService.to.userId!, "2", 0, pageSize);
      faqList.addAll(list);
    } finally {
      isLoading.value = false; // 데이터 로딩 완료
    }
  }
}
