import 'package:cashmore_app/common/model/common_model.dart';
import 'package:cashmore_app/common/model/totalPoint_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';

class HomeRepsitory {
  HomeRepsitory._internal();

  static final _singleton = HomeRepsitory._internal();

  factory HomeRepsitory() => _singleton;


   /* total Point */
  Future<TotalPointModel> totalPoint(String userId) async {
       return await Api().authDio.get('/api/total_point_cnt', queryParameters: {"user_id": userId,}).then((res) {
      TotalPointModel data = TotalPointModel.fromJson(res.data);
      return data!;
    });
  }

  Future<CommonModel> stepPointAdd(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/step_counter_point_add', data: body).then((res) => CommonModel.fromJson(res.data));
  }

}
