import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/board_model.dart';
import 'package:cashmore_app/repository/mypage_repsitory.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:get/get.dart';

class NoticeDetailController extends BaseController {
  final appService = Get.find<AppService>();
  MypageRepsitory mypageRepsitory = MypageRepsitory();

  var isLoading = true.obs;
  var noticeDetail = Rx<BoardModel?>(null); // 공지사항 상세 데이터

  @override
  void onInit() {
    super.onInit();
    final noticeId = Get.arguments as int?; // 전달된 noticeId를 가져옴
    if (noticeId != null) {
      fetchNoticeDetail(noticeId);
    } else {
      isLoading(false);
    }
  }

  // 공지사항 상세 정보 로드 함수
  Future<void> fetchNoticeDetail(int noticeId) async {
    isLoading(true);
    try {
      noticeDetail.value = await mypageRepsitory.getNoticeById(AppService.to.userId!, noticeId);
    } finally {
      isLoading(false);
    }
  }
}
