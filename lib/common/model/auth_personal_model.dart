class AuthPersonalModel {
  final String authUrl;

  AuthPersonalModel({required this.authUrl});

  factory AuthPersonalModel.fromJson(Map<String, dynamic> json) {
    return AuthPersonalModel(
      authUrl: json['authUrl'],
    );
  }
}