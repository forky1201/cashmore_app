class AppInfoModel {
  String? quest_type_1_yn;
  String? quest_type_2_yn;
  String? quest_type_3_yn;
  String? quest_type_4_yn;
  String? os_update_yn;
  String? description;

  AppInfoModel({this.quest_type_1_yn, this.quest_type_2_yn, this.quest_type_3_yn, this.quest_type_4_yn, this.os_update_yn});

  factory AppInfoModel.fromJson(Map<String, dynamic> json) => AppInfoModel(
        quest_type_1_yn: json["quest_type_1_yn"],
        quest_type_2_yn: json["quest_type_2_yn"],
        quest_type_3_yn: json["quest_type_3_yn"],
        quest_type_4_yn: json["quest_type_4_yn"],
        os_update_yn: json["os_update_yn"],
      );

  Map<String, dynamic> toJson() =>
      {"quest_type_1_yn": quest_type_1_yn, "quest_type_2_yn": quest_type_2_yn, "quest_type_3_yn": quest_type_3_yn, "quest_type_4_yn": quest_type_4_yn, "os_update_yn": os_update_yn};
}

class AppInfoResponse {
  final bool status;
  final String message;
  final AppInfoModel? data;

  AppInfoResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AppInfoResponse.fromJson(Map<String, dynamic> json) {
    return AppInfoResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AppInfoModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data,
      };
}
