import 'dart:convert';

import 'package:cashmore_app/common/model/app_info_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';
import 'package:dio/dio.dart';

class AppInfoRepository {
  AppInfoRepository._internal();

  static final _singleton = AppInfoRepository._internal();

  factory AppInfoRepository() => _singleton;

  /* 앱정보 조회 */
  Future<AppInfoModel> appInfo(String platform, String version) async {
    return await Api().baseDio.get(
      '/api/quest_version',
      queryParameters: {
        "os_gubun": platform,
        "os_version": version, // 상품 코드
      },
    ).then((res) {
      AppInfoResponse data = AppInfoResponse.fromJson(res.data);
       if (data.data!.os_update_yn == "N") {
        data.data!.description = "최신 버전 업데이트를 위해 스토어로 이동합니다. 항상 겟잇머니를 이용해 주셔서 감사합니다. \u{1F44D}";
      }
      return data.data!;
    });
  }
}
