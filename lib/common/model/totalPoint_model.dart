class TotalPointModel {
  final String code;
  final bool? status;
  final String? message;
  final int? total_point;

  TotalPointModel({required this.code, this.status, this.message, this.total_point});

  factory TotalPointModel.fromJson(Map<String, dynamic> json) {
    return TotalPointModel(
      code: json['code'].toString(),
      status: json['status'],
      message: json['message'],
      total_point: json['total_point'],
    );
  }
}
