import 'dart:convert';
import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/result_error_model.dart';
import 'package:cashmore_app/common/toast_message.dart';
import 'package:dio/dio.dart';

class BaseApiInterceptors extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.i([err.requestOptions, err.requestOptions.toString()]);
    
    String errorMessage = "An unknown error occurred.";
    if (err.response != null) {
      try {
        // JSON 형식인지 확인한 후 파싱
        Map<String, dynamic> json = jsonDecode(err.response!.data);
        ResultErrorModel result = ResultErrorModel.fromJson(json);
        logger.e("[errorInfo] ${result.toJson()}");

        if (!(result.message?.isEmpty ?? true)) {
          errorMessage = result.message!;
        }
      } catch (e) {
        // JSON 파싱 중 오류가 발생한 경우
        logger.e("Error parsing response: $e");
      }
    }

    // 상태 코드 기반 처리
    if (err.response != null) {
      int statusCode = err.response?.statusCode ?? 0;
      if (statusCode >= 400 && statusCode < 600) {
        // 401 상태 코드 처리
        if (statusCode == 401) {
          logger.e("Unauthorized request");
        } else {
          ToastMessage.show(errorMessage);
          err.response?.extra['notified'] = true;
        }
      }
    }

    // DioException의 타입에 따라 에러 메시지를 처리
    switch (err.type) {
      case DioExceptionType.badResponse:
        break; // 이미 상태 코드를 통해 처리함
      case DioExceptionType.connectionTimeout:
        ToastMessage.show("Connection timed out.");
        break;
      case DioExceptionType.sendTimeout:
        ToastMessage.show("Send request timed out.");
        break;
      case DioExceptionType.receiveTimeout:
        ToastMessage.show("Receive timed out.");
        break;
      case DioExceptionType.cancel:
        ToastMessage.show("Request canceled.");
        break;
      case DioExceptionType.unknown:
        ToastMessage.show("An unknown error occurred.");
        break;
      case DioExceptionType.badCertificate:
        ToastMessage.show("Invalid certificate error.");
        break;
      case DioExceptionType.connectionError:
        ToastMessage.show("Connection error occurred.");
        break;
    }

    super.onError(err, handler);
  }
}
