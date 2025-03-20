class UserModel {
  String user_id;
  String? user_hp;
  String? user_name;
  int? approve;
  int? file_upload;
  int? total_point;
  String? bank_number;
  String? bank_user_name;
  int? marketing;
  int? service_alert;
  String? recommender;
  String? my_recommender;
  String? snstype;

  String? step500;
  int? point500;

  String? step1000;
  int? point1000;

  String? step2000;
  int? point2000;

  String? step3000;
  int? point3000;

  String? step5000;
  int? point5000;

  String? step10000;
  int? point10000;

  UserModel({
    required this.user_id,
    this.user_hp,
    this.user_name,
    this.approve,
    this.file_upload,
    this.total_point,
    this.bank_number,
    this.bank_user_name,
    this.marketing,
    this.service_alert,
    this.recommender,
    this.my_recommender,
    this.snstype,
    this.step500,
    this.point500,
    this.step1000,
    this.point1000,
    this.step2000,
    this.point2000,
    this.step3000,
    this.point3000,
    this.step5000,
    this.point5000,
    this.step10000,
    this.point10000,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json["user_id"],
      user_hp: json["user_hp"],
      user_name: json["user_name"],
      approve: json["approve"],
      file_upload: json["file_upload"],
      total_point: json["total_point"],
      bank_number: json["bank_number"].toString(),
      bank_user_name: json["bank_user_name"],
      marketing: json["marketing"],
      service_alert: json["service_alert"],
      recommender: json["recommender"].toString(),
      my_recommender: json["my_recommender"],
      snstype: json["snstype"].toString(),
      step500: json["step500"],
      point500: json["point500"],
      step1000: json["step1000"],
      point1000: json["point1000"],
      step2000: json["step2000"],
      point2000: json["point2000"],
      step3000: json["step3000"],
      point3000: json["point3000"],
      step5000: json["step5000"],
      point5000: json["point5000"],
      step10000: json["step10000"],
      point10000: json["point10000"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "user_hp": user_hp,
        "user_name": user_name,
        "approve": approve,
        "file_upload": file_upload,
        "total_point": total_point,
        "bank_number": bank_number,
        "bank_user_name": bank_user_name,
        "marketing": marketing,
        "service_alert": service_alert,
        "recommender": recommender,
        "my_recommender": my_recommender,
        "snstype": snstype,
        "step500": step500,
        "point500": point500,
        "step1000": step1000,
        "point1000": point1000,
        "step2000": step2000,
        "point2000": point2000,
        "step3000": step3000,
        "point3000": point3000,
        "step5000": step5000,
        "point5000": point5000,
        "step10000": step10000,
        "point10000": point10000,
      };
}

class LoggedIn {
  final bool status;
  final String message;
  final UserModel data;

  LoggedIn({required this.status, required this.message, required this.data});

  factory LoggedIn.fromJson(Map<String, dynamic> json) {
    return LoggedIn(
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {"data": data.toJson()};
}
