import 'dart:convert';

class BrandModel {
  String? brandName;
  int? brandSeq;
  String? category1Name;
  int? sort;
  String? content;
  String? brandBannerImg;
  String? mmsThumImg;
  int? category2Seq;
  String? brandIConImg;
  String? category2Name;
  String? newFlag;
  int? category1Seq;
  String? brandCode;

  BrandModel({
    this.brandName,
    this.brandSeq,
    this.category1Name,
    this.sort,
    this.content,
    this.brandBannerImg,
    this.mmsThumImg,
    this.category2Seq,
    this.brandIConImg,
    this.category2Name,
    this.newFlag,
    this.category1Seq,
    this.brandCode,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandName: json['brandName'],
      brandSeq: json['brandSeq'],
      category1Name: json['category1Name'],
      sort: json['sort'],
      content: json['content'],
      brandBannerImg: json['brandBannerImg'],
      mmsThumImg: json['mmsThumImg'],
      category2Seq: json['category2Seq'],
      brandIConImg: json['brandIConImg'],
      category2Name: json['category2Name'],
      newFlag: json['newFlag'],
      category1Seq: json['category1Seq'],
      brandCode: json['brandCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'brandName': brandName,
        'brandSeq': brandSeq,
        'category1Name': category1Name,
        'sort': sort,
        'content': content,
        'brandBannerImg': brandBannerImg,
        'mmsThumImg': mmsThumImg,
        'category2Seq': category2Seq,
        'brandIConImg': brandIConImg,
        'category2Name': category2Name,
        'newFlag': newFlag,
        'category1Seq': category1Seq,
        'brandCode': brandCode,
      };
}

class BrandResult {
  final int? listNum;
  final List<BrandModel>? brandList;

  BrandResult({
    this.listNum,
    this.brandList,
  });

  factory BrandResult.fromJson(Map<String, dynamic> json) {
    return BrandResult(
      listNum: json['listNum'],
      brandList: (json['brandList'] as List<dynamic>).map((item) => BrandModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'listNum': listNum,
        'brandList': brandList?.map((brand) => brand.toJson()).toList(),
      };
}

class BrandData {
  int? code;
  String? message;
  BrandResult? result;

  BrandData({
    this.code,
    this.message,
    this.result,
  });

  factory BrandData.fromJson(Map<String, dynamic> json) {
    return BrandData(
      code: json['code'],
      message: json['message'],
      result: json['result'] != null ? BrandResult.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'result': result?.toJson(),
      };
}

class BrandResponse {
  bool? status;
  String? message;
  BrandData? data;
  int? code;

  BrandResponse({
    this.status,
    this.message,
    this.data,
    this.code,
  });

  factory BrandResponse.fromJson(Map<String, dynamic> json) {
    return BrandResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? BrandData.fromJson(json['data']) : null,
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'code': code,
      };
}
