import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/auth_model.dart';
import 'package:cashmore_app/common/model/auth_personal_model.dart';
import 'package:cashmore_app/common/model/common_model.dart';
import 'package:cashmore_app/common/model/join_error_model.dart';
import 'package:cashmore_app/common/model/result_error_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';

class AuthRepository {
  AuthRepository._internal();

  static final _singleton = AuthRepository._internal();

  factory AuthRepository() => _singleton;

  Future<AuthModel> login(Map<String, dynamic> body) async {
    return await Api()
        .baseDio
        .post('/api/login', data: body)
        .then((res) => AuthModel.fromJson(res.data));
  }


  /* SNS 로그인 */
  Future<AuthModel> snsLogin(Map<String, dynamic> body) async {
    return await Api().baseDio.post('/api/snslogin', data: body).then((res) => AuthModel.fromJson(res.data));
  }

    /* 로그인시 - 사용자 정보 조회 */
  Future<LoggedIn> loggedIn(String userId) async {
    return await Api()
        .authDio
        .get('/user', queryParameters: {"user_id": userId})
        .then((res) => LoggedIn.fromJson(res.data));
  }

  /* 회원가입 */
  Future<JoinErrorModel> join(Map<String, dynamic> body) async{
    return await Api()
        .baseDio
        .post('/user', data: body)
        .then((res) => JoinErrorModel.fromJson(res.data));
  }

  Future<AuthPersonalModel> personalAuthentication() async {
    return await Api()
        .baseDio
        .get('/api/getitmoney_auth_create', queryParameters: {"deviceType": "mobile"})
        .then((res) {

          // set-cookie 헤더 가져오기
          //var cookies = res.headers['set-cookie'];
           //print('1231231Set-Cookie: ${cookies}');

        return AuthPersonalModel.fromJson(res.data);          
        } );
  }

      /* 사용자 정보 수정 (비밀번호) */
  Future<void> updateUserInfo(Map<String, dynamic> body) async {
    return await Api().baseDio.put('/api/user_di_pw_post', data: body).then((res) => res.data);
  }

        /* di 값으로 아이디 구하기 */
  Future<LoggedIn> diInfo(String di) async {
    return await Api().baseDio.get('/api/user_di_get', queryParameters: {"user_di": di}).then((res) => LoggedIn.fromJson(res.data));
  }

        /* 사용자 정보 수정 (비밀번호) */
  Future<CommonModel> pointAdd(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/user_login_point_add', data: body).then((res) => CommonModel.fromJson(res.data));
  }


}