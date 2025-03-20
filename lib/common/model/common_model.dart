class CommonModel {
  final bool? status;
  final String? message;
  final int? code;

  CommonModel({this.status, this.message, this.code});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      status: json['status'],
      message: json['message'],
       code: json['code'],
    );
  }
}
