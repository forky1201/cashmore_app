import 'package:cashmore_app/common/constants.dart';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/repository/common/auth_api_interceptors.dart';
import 'package:cashmore_app/repository/common/base_api_interceptors.dart';
import 'package:dio/dio.dart';


class Api {
  late Dio baseDio;
  late Dio authDio;
  late Dio authImageDio;

  Api._internal() {
    logger.i('Api initialized!');
    // logger.i('API_HOST: ${Environment.apiHost} / API_KEY: ${Environment.apiKey}');
    BaseOptions baseOptions = BaseOptions(
      baseUrl: domain,
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json', //'ApiKey': "1234",
      "contentType": "application/json"
      },
    );
    BaseOptions baseOptionsImage = BaseOptions(
      baseUrl: domain,
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: 'multipart/form-data',
      headers: {
        'Accept': 'application/json',
        //'ApiKey': "1234",
        "contentType": "application/json"
      },
    );
    baseDio = createBaseDio(baseOptions);
    authDio = createAuthDio(baseOptions);
  }

  static final _singleton = Api._internal();

  static Dio createBaseDio(BaseOptions baseOptions) {
    
    logger.i("createBaseDio initialized!");
    return Dio(baseOptions)
      ..interceptors.addAll([BaseApiInterceptors(), LogInterceptor(
         request: true, // 요청 URI와 메서드 로깅
          requestBody: true, // 요청 본문 로깅
          responseBody: true, // 응답 본문 로깅
          requestHeader: true, // 요청 헤더 비활성화
          responseHeader: true, // 응답 헤더 비활성화
          error: true, // 에러 로그 활성화
      )]);
  }

  static Dio createAuthDio(BaseOptions baseOptions) {
    logger.i("createAuthDio initialized!");
    var dio = Dio(baseOptions);
    dio.interceptors.addAll([AuthApiInterceptors(dio), LogInterceptor()]);
    return dio;
  }

  factory Api() => _singleton;
}
