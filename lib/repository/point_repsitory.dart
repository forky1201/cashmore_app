import 'package:cashmore_app/common/model/point_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';

class PointRepsitory {
  PointRepsitory._internal();

  static final _singleton = PointRepsitory._internal();

  factory PointRepsitory() => _singleton;


   /* 포인트 출금 요청 */
  Future<void> pointwitDrawal(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/quest_bank_add', data: body).then((res) => res.data);
  }

     /* 포인트 내역 리스트 */
  Future<List<PointModel>> pointList(String userId, String status, int offset, int pageSize) async {
    return await Api().authDio.get('/api/quest_point_status_lists', queryParameters: {
      "user_id": userId,
      "status": status,
      "offset": offset,
      "pageSize": pageSize,
    }).then((res) {
      PointModelTotal data = PointModelTotal.fromJson(res.data);
      return data.data;
    });
  }

}
