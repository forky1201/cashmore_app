import 'dart:convert';

class BoardModel {
  int id;
  int? board_type;
  String? title;
  String? content;
  String? author;
  DateTime? regdate;
  String? update;
  int? checkyn;
  int? view_count;
  int? elapsed_days;

  BoardModel({
    required this.id,
    this.board_type,
    this.title,
    this.content,
    this.author,
    this.regdate,
    this.update,
    this.checkyn,
    this.view_count,
    this.elapsed_days,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json["id"],
      board_type: json["board_type"],
      title: json["title"],
      content: json["content"],
      author: json["author"],
      regdate: json["regdate"] != null ? DateTime.parse(json["regdate"]) : null,
      update: json["update"],
      checkyn: json["checkyn"],
      view_count: json["view_count"],
      elapsed_days: json["elapsed_days"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "board_type": board_type,
        "title": title,
        "content": content,
        "author": author,
        "regdate": regdate?.toIso8601String(),
        "update": update,
        "checkyn": checkyn,
        "view_count": view_count,
        "elapsed_days": elapsed_days,
      };
}

class BoardModelTotal {
  final bool status;
  final String message;
  final List<BoardModel> data; // 리스트 또는 단일 객체로 변경 가능

  BoardModelTotal({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BoardModelTotal.fromJson(Map<String, dynamic> json) {
     // 'data' 필드가 null인지, 리스트인지, 단일 객체인지 확인
    if (json['data'] != null) {
      // 'data'가 리스트일 경우
      if (json['data'] is List) {
        var dataList = json['data'] as List<dynamic>;
        List<BoardModel> list = dataList.map((item) => BoardModel.fromJson(item as Map<String, dynamic>)).toList();

        return BoardModelTotal(
          status: json['status'] ?? false, // 기본값을 설정할 수 있음
          message: json['message'] ?? '',
          data: list,
        );
      }
    }

    return BoardModelTotal(
      status: json['status'] ?? false, // 기본값을 설정할 수 있음
      message: json['message'] ?? '',
      data: [], // 빈 리스트 할당
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((list) => list.toJson()).toList(), // 리스트를 맵으로 변환
      };
}

class BoardModelDetailTotal {
  final bool status;
  final String message;
  final BoardModel data; // 리스트 또는 단일 객체로 변경 가능

  BoardModelDetailTotal({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BoardModelDetailTotal.fromJson(Map<String, dynamic> json) {
    var data = BoardModel.fromJson(json['data']);

    return BoardModelDetailTotal(
      status: json['status'] ?? false, // 기본값을 설정할 수 있음
      message: json['message'] ?? '',
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "message": message, "data": data};
}
