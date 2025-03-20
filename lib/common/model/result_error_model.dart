class ResultErrorModel {

  int? status;
  String? message;
  String? code;

  ResultErrorModel({
    this.status,
    this.message,
    this.code
  });

  factory ResultErrorModel.fromJson(Map<String, dynamic> json) => ResultErrorModel(
    status: json["status"],
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
  };
}