class MissionModel {
  final int idx;
  final String quest_type;
  final String quest_number;
  final String? userid;
  final String? quest_header_html;
  final String? quest_subject;
  final String? quest_place_name;
  final String? quest_company;
  final String? quest_inflow;
  final String? quest_url;
  final String? quest_sdate;
  final String? quest_edate;
  final Object? quest_stime;
  final Object? quest_etime;
  final int? quest_count;
  final int? quest_use_price;
  final String? quest_total_count;
  final int? quest_day_division;
  final String? quest_rank_keyword;
  final String? quest_slot;
  final String? quest_keyword_copy;
  final String? quest_browser_type;
  final String? quest_start_url;
  final String? quest_end_url;
  final String? quest_description;

  final String? question_hint1;
  final String? answer1;
  final String? keyword1;
  final String? file_upload1;

  final String? question_hint2;
  final String? answer2;
  final String? keyword2;
  final String? file_upload2;

  final String? question_hint3;
  final String? answer3;
  final String? keyword3;
  final String? file_upload3;

  final String? question_hint4;
  final String? answer4;
  final String? keyword4;
  final String? file_upload4;

  final String? question_hint5;
  final String? answer5;
  final String? keyword5;
  final String? file_upload5;

  final int? refund_cost;
  final int? total_vat;
  final int? total_use_cost;
  final int? total_rem_cost;
  final int? total_sum_cost;
  final int? sort;
  final int? super_sort;
  final int? quest_ing_count;
  final String? regdate;
  final int? status;
  final String? decode;
  final int? boost_price;

  MissionModel({
    required this.idx,
    required this.quest_type,
    required this.quest_number,
    this.userid,
    this.quest_header_html,
    this.quest_subject,
    this.quest_place_name,
    this.quest_company,
    this.quest_inflow,
    this.quest_url,
    this.quest_sdate,
    this.quest_edate,
    this.quest_stime,
    this.quest_etime,
    this.quest_count,
    this.quest_use_price,
    this.quest_total_count,
    this.quest_day_division,
    this.quest_rank_keyword,
    this.quest_slot,
    this.quest_keyword_copy,
    this.quest_browser_type,
    this.quest_start_url,
    this.quest_end_url,
    this.quest_description,
    this.question_hint1,
    this.answer1,
    this.keyword1,
    this.file_upload1,
    this.question_hint2,
    this.answer2,
    this.keyword2,
    this.file_upload2,
    this.question_hint3,
    this.answer3,
    this.keyword3,
    this.file_upload3,
    this.question_hint4,
    this.answer4,
    this.keyword4,
    this.file_upload4,
    this.question_hint5,
    this.answer5,
    this.keyword5,
    this.file_upload5,
    this.refund_cost,
    this.total_vat,
    this.total_use_cost,
    this.total_rem_cost,
    this.total_sum_cost,
    this.sort,
    this.super_sort,
    this.quest_ing_count,
    this.regdate,
    this.status,
    this.decode,
    this.boost_price,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      idx: json['idx'],
      quest_type: json['quest_type'].toString(),
      quest_number: json['quest_number'].toString(),
      userid: json['userid'].toString(),
      quest_header_html: json['quest_header_html'],
      quest_subject: json['quest_subject'].toString(),
      quest_place_name: json['quest_place_name'].toString(),
      quest_company: json['quest_company'].toString(),
      quest_inflow: json['quest_inflow'].toString(),
      quest_url: json['quest_url'].toString(),
      quest_sdate: json['quest_sdate'],
      quest_edate: json['quest_edate'],
      quest_stime: json['quest_stime'],
      quest_etime: json['quest_etime'],
      quest_count: json['quest_count'],
      quest_use_price: json['quest_use_price'],
      quest_total_count: json['quest_total_count'],
      quest_day_division: json['quest_day_division'],
      quest_rank_keyword: json['quest_rank_keyword'].toString(),
      quest_slot: json['quest_slot'].toString(),
      quest_keyword_copy: json['quest_keyword_copy'].toString(),
      quest_browser_type: json['quest_browser_type'].toString(),
      quest_start_url: json['quest_start_url'].toString(),
      quest_end_url: json['quest_end_url'].toString(),
      quest_description: json['quest_description'].toString(),
      question_hint1: json['question_hint1'].toString(),
      answer1: json['answer1'].toString(),
      keyword1: json['keyword1'].toString(),
      file_upload1: json['file_upload1'].toString(),
      question_hint2: json['question_hint2'].toString(),
      answer2: json['answer2'].toString(),
      keyword2: json['keyword2'].toString(),
      file_upload2: json['file_upload2'].toString(),
      question_hint3: json['question_hint3'].toString(),
      answer3: json['answer3'].toString(),
      keyword3: json['keyword3'].toString(),
      file_upload3: json['file_upload3'].toString(),
      question_hint4: json['question_hint4'].toString(),
      answer4: json['answer4'].toString(),
      keyword4: json['keyword4'].toString(),
      file_upload4: json['file_upload4'].toString(),
      question_hint5: json['question_hint5'].toString(),
      answer5: json['answer5'].toString(),
      keyword5: json['keyword5'].toString(),
      file_upload5: json['file_upload5'].toString(),
      refund_cost: json['refund_cost'],
      total_vat: json['total_vat'],
      total_use_cost: json['total_use_cost'],
      total_rem_cost: json['total_rem_cost'],
      total_sum_cost: json['total_sum_cost'],
      sort: json['sort'],
      super_sort: json['super_sort'],
      quest_ing_count: json['quest_ing_count'],
      regdate: json['regdate'],
      status: json['status'],
      decode: json['decode'].toString(),
      boost_price: json['boost_price'],
    );
  }

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "quest_type": quest_type,
        "quest_number": quest_number,
        "userid": userid,
        "quest_header_html": quest_header_html,
        "quest_subject": quest_subject,
        "quest_place_name": quest_place_name,
        "quest_company": quest_company,
        "quest_inflow": quest_inflow,
        "quest_url": quest_url,
        "quest_sdate": quest_sdate,
        "quest_edate": quest_edate,
        "quest_stime": quest_stime,
        "quest_etime": quest_etime,
        "quest_count": quest_count,
        "quest_use_price": quest_use_price,
        "quest_total_count": quest_total_count,
        "quest_day_division": quest_day_division,
        "quest_rank_keyword": quest_rank_keyword,
        "quest_slot": quest_slot,
        "quest_keyword_copy": quest_keyword_copy,
        "quest_browser_type": quest_browser_type,
        "quest_start_url": quest_start_url,
        "quest_end_url": quest_end_url,
        "quest_description": quest_description,
        "question_hint1": question_hint1,
        "answer1": answer1,
        "keyword1": keyword1,
        "file_upload1": file_upload1,
        "question_hint2": question_hint2,
        "answer2": answer2,
        "keyword2": keyword2,
        "file_upload2": file_upload2,
        "question_hint3": question_hint3,
        "answer3": answer3,
        "keyword3": keyword3,
        "file_upload3": file_upload3,
        "question_hint4": question_hint4,
        "answer4": answer4,
        "keyword4": keyword4,
        "file_upload4": file_upload4,
        "question_hint5": question_hint5,
        "answer5": answer5,
        "keyword5": keyword5,
        "file_upload5": file_upload5,
        "refund_cost": refund_cost,
        "total_vat": total_vat,
        "total_use_cost": total_use_cost,
        "total_rem_cost": total_rem_cost,
        "total_sum_cost": total_sum_cost,
        "sort": sort,
        "super_sort": super_sort,
        "quest_ing_count": quest_ing_count,
        "regdate": regdate,
        "status": status,
        "decode": decode,
        "boost_price": boost_price,
      };
}

class MissionModelTotal {
  final bool status;
  final String message;
  final List<MissionModel> data; // 리스트 또는 단일 객체로 변경 가능

  MissionModelTotal({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MissionModelTotal.fromJson(Map<String, dynamic> json) {
    // 'data' 필드가 null인지, 리스트인지, 단일 객체인지 확인
    if (json['data'] != null) {
      // 'data'가 리스트일 경우
      if (json['data'] is List) {
        var dataList = json['data'] as List<dynamic>;
        List<MissionModel> missions = dataList.map((item) => MissionModel.fromJson(item as Map<String, dynamic>)).toList();

        return MissionModelTotal(
          status: json['status'] ?? false, // 기본값을 설정할 수 있음
          message: json['message'] ?? '',
          data: missions,
        );
      }
    }

    // 'data'가 null이거나 예상한 형태가 아닐 경우, 기본값으로 처리
    return MissionModelTotal(
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

class MissionModelDetailTotal {
  final bool status;
  final String message;
  final MissionModel data; // 리스트 또는 단일 객체로 변경 가능

  MissionModelDetailTotal({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MissionModelDetailTotal.fromJson(Map<String, dynamic> json) {
    var mission = MissionModel.fromJson(json['data']);
    return MissionModelDetailTotal(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: mission, // 단일 객체를 리스트로 감싸서 처리
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data, // 리스트를 맵으로 변환
      };
}
