import 'package:cashmore_app/common/constants.dart';
import 'package:dio/dio.dart';

class BaseApiService {
  final Dio _dio;
  String? _token;

  // 고정된 baseUrl 설정
  BaseApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: domain, // 고정된 기본 baseUrl
          connectTimeout: const Duration(seconds: 10), // 연결 타임아웃
          receiveTimeout: const Duration(seconds: 10), // 응답 타임아웃
          sendTimeout: const Duration(seconds: 10),
          headers: {
            'Accept': 'application/json',
            //'ApiKey': 'apikey123',
            "contentType": "application/json"
          },
        ))..interceptors.addAll([LogInterceptor()]);

  // 토큰 설정 메서드
  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = '$token';
  }

  // 기본 헤더에 인증 토큰을 추가한 GET 요청
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return _processResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // 기본 헤더에 인증 토큰을 추가한 POST 요청
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _processResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // 기본 헤더에 인증 토큰을 추가한 PUT 요청
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _processResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  // 기본 헤더에 인증 토큰을 추가한 DELETE 요청
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _processResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // 공통 응답 처리 메서드
  dynamic _processResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed with status code: ${response.statusCode}');
    }
  }

  // 토큰 초기화 메서드
  void clearToken() {
    _token = null;
    _dio.options.headers.remove('Authorization');
  }
}
