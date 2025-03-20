class JoinErrorModel {

  bool? status;
  String? message;
  String? code;

  JoinErrorModel({
    this.status,
    this.message,
    this.code
  });

  factory JoinErrorModel.fromJson(Map<String, dynamic> json) => JoinErrorModel(
    status: json["status"],
    message: json["message"],
    code: json["code"].toString()
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
  };
}