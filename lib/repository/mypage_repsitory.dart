import 'package:cashmore_app/common/logger.dart';
import 'package:cashmore_app/common/model/auth_model.dart';
import 'package:cashmore_app/common/model/board_model.dart';
import 'package:cashmore_app/common/model/common_model.dart';
import 'package:cashmore_app/common/model/recommender_model.dart';
import 'package:cashmore_app/common/model/user_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';

class MypageRepsitory {
  MypageRepsitory._internal();

  static final _singleton = MypageRepsitory._internal();

  factory MypageRepsitory() => _singleton;

  /* 사용자 정보 수정 (비밀번호) */
  Future<void> updateUserInfo(Map<String, dynamic> body) async {
    return await Api().authDio.put('/user', data: body).then((res) => res.data);
  }

  /* 보드 리스트 */
  Future<List<BoardModel>> boardList(String userId, String boardType, int offset, int pageSize) async {
    return await Api().authDio.get('/api/board_lists', queryParameters: {
      "user_id": userId,
      "board_type": boardType,
      "offset": offset,
      "pageSize": pageSize,
    }).then((res) {
      BoardModelTotal data = BoardModelTotal.fromJson(res.data);
      return data.data;
    });
  }

  /* 보드 상세 */
  Future<BoardModel> getNoticeById(String userId, int id) async {
    return await Api().authDio.get('/api/board_list', queryParameters: {"user_id": userId, "id": id}).then((res) {
      BoardModelDetailTotal data = BoardModelDetailTotal.fromJson(res.data);
      return data.data;
    });
  }

  /* 제휴문의 */
  Future<void> submitInquiry(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/quest_partner_add', data: body).then((res) => res.data);
  }

  /* 추천인 리스트 */
  Future<List<RecommenderModel>> recommendersList(String userId, String my_recommender, int offset, int pageSize) async {
    return await Api().authDio.get('/api/recommender_lists', queryParameters: {
      "user_id": userId,
      "my_recommender": my_recommender,
      "offset": offset,
      "pageSize": pageSize,
    }).then((res) {
      if (res.data["code"] == 500) {
        //CommonModel data = CommonModel.fromJson(res.data);
        List<RecommenderModel> list = List.empty();
        return list;
      } else {
        RecommenderModelTotal data = RecommenderModelTotal.fromJson(res.data);
        return data.data;
      }
    });
  }

  /*탈퇴하기 */
  Future<void> userDelete(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/user_delete', data: body).then((res) => res.data);
  }
}
