class PointModel {
  String user_id;
  int? point;
  String? status;
  String? subject;
  String? quest_number;
  String? quest_type;
  DateTime? regdate;

  PointModel({
    required this.user_id,
    this.point,
    this.status,
    this.subject,
    this.quest_number,
    this.quest_type,
    this.regdate,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      user_id: json["user_id"],
      point: json["point"],
      status: json["status"],
      subject: json["subject"],
      quest_number: json["quest_number"].toString(),
      quest_type: json["quest_type"].toString(),
      regdate: json["regdate"] != null ? DateTime.parse(json["regdate"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "point": point,
        "status": status,
        "subject": subject,
        "quest_number": quest_number,
        "quest_type": quest_type,
        "regdate": regdate?.toIso8601String(),
      };
}

class PointModelTotal {
  final bool status;
  final String message;
  final List<PointModel> data;

  PointModelTotal({required this.status, required this.message, required this.data});

  factory PointModelTotal.fromJson(Map<String, dynamic> json) {
    // 'data' 필드가 null인지, 리스트인지, 단일 객체인지 확인
    if (json['data'] != null) {
      // 'data'가 리스트일 경우
      if (json['data'] is List) {
        var dataList = json['data'] as List<dynamic>;
        List<PointModel> point = dataList.map((item) => PointModel.fromJson(item as Map<String, dynamic>)).toList();

        return PointModelTotal(
          status: json['status'] ?? false, // 기본값을 설정할 수 있음
          message: json['message'] ?? '',
          data: point,
        );
      }
    }

    // 'data'가 null이거나 예상한 형태가 아닐 경우, 기본값으로 처리
    return PointModelTotal(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: [], // 빈 리스트 할당
    );
  }
  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((mission) => mission.toJson()).toList(), // 리스트를 맵으로 변환
      };

}
