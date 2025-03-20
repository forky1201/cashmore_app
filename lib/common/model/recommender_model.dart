import 'dart:convert';

class RecommenderModel {
  String? user_id;
  String? user_hp;
  String? user_name;
  DateTime? regdate;
  String? my_recommender;

  RecommenderModel({
    this.user_id,
    this.user_hp,
    this.user_name,
    this.my_recommender,
    this.regdate,
  });

  factory RecommenderModel.fromJson(Map<String, dynamic> json) {
    return RecommenderModel(
      user_id: json["user_id"],
      user_hp: json["user_hp"].toString(),
      user_name: json["user_name"],
      regdate: json["regdate"]  != null ? DateTime.parse(json["regdate"]) : null,
      my_recommender: json["my_recommender"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "user_hp": user_hp,
        "user_name": user_name,
        "regdate": regdate?.toIso8601String(),
        "my_recommender": my_recommender,
      };
}


class RecommenderModelTotal {
  final bool status;
  final String message;
  final List<RecommenderModel> data; // 리스트 또는 단일 객체로 변경 가능

  RecommenderModelTotal({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RecommenderModelTotal.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
        List<RecommenderModel> data = dataList.map((item) => RecommenderModel.fromJson(item as Map<String, dynamic>)).toList();

        return RecommenderModelTotal(
          status: json['status'] ?? false,  // 기본값을 설정할 수 있음
          message: json['message'] ?? '',
          data: data,
        );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((mission) => mission.toJson()).toList(), // 리스트를 맵으로 변환
      };
}
