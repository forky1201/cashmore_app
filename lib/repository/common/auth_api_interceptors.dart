import 'dart:convert';
import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/result_error_model.dart';
import 'package:cashmore_app/common/toast_message.dart';
import 'package:cashmore_app/service/app_prefs.dart';
import 'package:cashmore_app/service/app_service.dart';
import 'package:dio/dio.dart';

class AuthApiInterceptors extends Interceptor {
  final Dio dio;
  AuthApiInterceptors(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    AppService appService = AppService.to;
    String? accessToken = AppPrefs.instance.getString(kAccessToken);

    if (accessToken?.isEmpty ?? true) {
      logger.e("엑세스토큰 없음. 로그아웃 처리!");
      appService.logout();
      return;
    }

    logger.i('엑세스토큰 = $accessToken');
    options.headers = {
      'Authorization': "$accessToken",  // Bearer 추가로 토큰을 전송
      ...options.headers,
    };

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.i([err.requestOptions, err.requestOptions.toString()]);

    // JSON 파싱 안전하게 처리
    ResultErrorModel? result;
    try {
      if (err.response?.data is String) {
        final json = jsonDecode(err.response?.data);
        //result = ResultErrorModel.fromJson(json);
        logger.e("[errorInfo] ${json}");
      }
    } catch (e) {
      logger.e("JSON 파싱 오류: $e");
    }

    switch (err.type) {
      case DioExceptionType.badResponse:
        _handleBadResponse(err, result);
        break;
      case DioExceptionType.connectionTimeout:
        //ToastMessage.show("연결 시간이 초과되었습니다.");
        logger.e("연결 시간이 초과되었습니다.");
        break;
      case DioExceptionType.sendTimeout:
        //ToastMessage.show("요청 시간이 초과되었습니다.");
         logger.e("요청 시간이 초과되었습니다.");
        break;
      case DioExceptionType.receiveTimeout:
        //ToastMessage.show("응답 시간이 초과되었습니다.");
         logger.e("응답 시간이 초과되었습니다.");
        break;
      case DioExceptionType.cancel:
        //ToastMessage.show("요청이 취소되었습니다.");
         logger.e("요청이 취소되었습니다.");
        break;
      case DioExceptionType.unknown:
        //ToastMessage.show("알 수 없는 오류가 발생했습니다.");
         logger.e("알 수 없는 오류가 발생했습니다.");
        break;
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        //ToastMessage.show("네트워크 연결 오류가 발생했습니다.");
        logger.e("네트워크 연결 오류가 발생했습니다.");
        break;
    }

    super.onError(err, handler);
  }

  void _handleBadResponse(DioException err, ResultErrorModel? result) async {
    int? statusCode = err.response?.statusCode;
    if (statusCode == 401) {
      var token = AppPrefs.instance.getString(kAccessToken);
      if (token != null) {
        // 토큰 만료 처리
        if (result?.status == 401) {
          logger.e("[토큰 만료] ${result!.toJson()}");
          await _handleTokenRefresh();
          return;
        }
      }
    } else if (statusCode == 409 && result?.status == 409) {
      // 중복 로그인 처리
      logger.e("[중복 로그인] ${result!.toJson()}");
      // 중복 로그인 로직 추가
    } else {
      // 기타 400 이상 에러 처리
      if (!(result?.message?.isEmpty ?? true)) {
        ToastMessage.show(result!.message!);
      }
    }
  }

  Future<void> _handleTokenRefresh() async {
    // 토큰 갱신 로직 추가
    logger.i("토큰 갱신 로직 호출");
    // 토큰 갱신 후 리트라이 로직
    // 여기에서 리프레시 토큰을 사용하여 새로운 엑세스 토큰을 받아와야 합니다.
  }

  Future<Response<dynamic>> requestApiRetry(RequestOptions requestOptions) async {
    var token = AppPrefs.instance.getString("token");

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': '$token',  // Bearer 토큰 전송
        'Retry': 'true',  // 리트라이 플래그
      },
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
