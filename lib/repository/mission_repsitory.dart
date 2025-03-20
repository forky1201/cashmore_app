import 'package:cashmore_app/common/model/misson_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';

class MissionRepsitory {
  MissionRepsitory._internal();

  static final _singleton = MissionRepsitory._internal();

  factory MissionRepsitory() => _singleton;


    /* 미션 탭별 리스트 */
  Future<List<MissionModel>> missionList(String userId, String quest_type, int offset, int pageSize ) async {
    return await Api()
        .authDio
        .get('/api/quest_lists', queryParameters: {"user_id": userId, "quest_type": quest_type, "offset": offset, "pageSize": pageSize,})
        .then((res){
            MissionModelTotal data = MissionModelTotal.fromJson(res.data);
            return data.data;
        });
  }

  /* 미션 상세 */
  Future<MissionModel> missionDetail(String userId,String questNumber) async {
    return await Api()
        .authDio
        .get('/api/quest_list', queryParameters: {"user_id": userId, "quest_number": questNumber })
        .then((res){
            MissionModelDetailTotal data = MissionModelDetailTotal.fromJson(res.data);
            return data.data;
        });
  }

    /* 미션 시작 */
  Future<void> missionStart(Map<String, dynamic> body) async{
    return await Api()
        .authDio
        .post('/api/quest_start', data: body)
        .then((res) => res.data);
  }

      /* 미션 완료 */
  Future<void> missionEnd(Map<String, dynamic> body) async{
    return await Api()
        .authDio
        .post('/api/quest_count_post_add', data: body)
        .then((res) => res.data);
  }

        /* 미션 신고 */
  Future<void> missionReport(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/quest_police', data: body).then((res) => res.data);
  }

          /* 미션 숨기기 */
  Future<void> missionHide(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/quest_user_hide', data: body).then((res) => res.data);
  }


}