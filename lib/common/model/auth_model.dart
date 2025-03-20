class AuthModel {
  final String? token;
  final bool? status;
  final String? message;
  final int? code;

  AuthModel({required this.token, this.status, this.message, this.code});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      status: json['status'],
      message: json['message'],
       code: json['code'],
    );
  }
}
