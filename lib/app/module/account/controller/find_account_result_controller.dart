import 'package:cashmore_app/common/base_controller.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/auth_repsitory.dart';
import 'package:get/get.dart';

class FindAccountResultController extends BaseController {
  final AuthRepository authRepository = AuthRepository();
  // 찾은 이메일을 저장할 변수
  var foundEmail = "".obs; // 초기 값 설정
  var userDi = "".obs;

  @override
  void onInit() {
    super.onInit();
    // arguments로 전달된 값을 foundEmail에 할당
    if (Get.arguments != null) {
      var di = Get.arguments; // 전달된 값으로 초기화
      init(di);
    }
  }

  Future<void> init(String di) async {
    String diUrlEncoding = Uri.encodeComponent(di);

    LoggedIn response = await authRepository.diInfo(di);
    foundEmail.value = response.data.user_id;
    userDi.value = di;
  }

  void moveToUrl(String path) {
    Get.toNamed(path, arguments: userDi.value);
  }
}
