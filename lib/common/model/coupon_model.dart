import 'dart:convert';

class CouponModel {
  int? idx;
  String? goodsCode;
  int? goodsNo;
  String? goodsName;
  String? brandCode;
  String? brandName;
  String? content;
  String? contentAddDesc;
  String? goodsTypeCd;
  String? goodstypeNm;
  String? goodsImgS;
  String? goodsImgB;
  String? goodsDescImgWeb;
  String? brandIconImg;
  String? mmsGoodsImg;
  int? discountPrice;
  int? realPrice;
  int? salePrice;
  int? validPrdTypeCd;
  int? limitDay;
  int? validPrdDay;
  String? endDate;
  String? goodsComId;
  String? goodsComName;
  String? affiliateId;
  String? affiliate;
  String? exhGenderCd;
  String? exhAgeCd;
  String? mmsReserveFlag;
  String? goodsStateCd;
  String? mmsBarcdCreateYn;
  String? rmCntFlag;
  String? saleDateFlagCd;
  String? goodsTypeDtlNm;
  int? category1Seq;
  String? saleDateFlag;
  String? rmIdBuyCntFlagCd;
  DateTime? regdate;

  CouponModel({
    this.idx,
    this.goodsCode,
    this.goodsNo,
    this.goodsName,
    this.brandCode,
    this.brandName,
    this.content,
    this.contentAddDesc,
    this.goodsTypeCd,
    this.goodstypeNm,
    this.goodsImgS,
    this.goodsImgB,
    this.goodsDescImgWeb,
    this.brandIconImg,
    this.mmsGoodsImg,
    this.discountPrice,
    this.realPrice,
    this.salePrice,
    this.validPrdTypeCd,
    this.limitDay,
    this.validPrdDay,
    this.endDate,
    this.goodsComId,
    this.goodsComName,
    this.affiliateId,
    this.affiliate,
    this.exhGenderCd,
    this.exhAgeCd,
    this.mmsReserveFlag,
    this.goodsStateCd,
    this.mmsBarcdCreateYn,
    this.rmCntFlag,
    this.saleDateFlagCd,
    this.goodsTypeDtlNm,
    this.category1Seq,
    this.saleDateFlag,
    this.rmIdBuyCntFlagCd,
    this.regdate,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      idx: json['idx'],
      goodsCode: json['goodsCode'],
      goodsNo: json['goodsNo'],
      goodsName: json['goodsName'],
      brandCode: json['brandCode'],
      brandName: json['brandName'],
      content: json['content'],
      contentAddDesc: json['contentAddDesc'],
      goodsTypeCd: json['goodsTypeCd'],
      goodstypeNm: json['goodstypeNm'],
      goodsImgS: json['goodsImgS'],
      goodsImgB: json['goodsImgB'],
      goodsDescImgWeb: json['goodsDescImgWeb'],
      brandIconImg: json['brandIconImg'],
      mmsGoodsImg: json['mmsGoodsImg'],
      discountPrice: json['discount_price'],
      realPrice: json['realPrice'],
      salePrice: json['salePrice'],
      validPrdTypeCd: json['valid_prd_type_cd'],
      limitDay: json['limit_day'],
      validPrdDay: json['validPrdDay'],
      endDate: json['endDate'],
      goodsComId: json['goodsComId'],
      goodsComName: json['goodsComName'],
      affiliateId: json['affiliateId'],
      affiliate: json['affiliate'],
      exhGenderCd: json['exhGenderCd'],
      exhAgeCd: json['exhAgeCd'].toString(),
      mmsReserveFlag: json['mmsReserveFlag'],
      goodsStateCd: json['goodsStateCd'],
      mmsBarcdCreateYn: json['mmsBarcdCreateYn'],
      rmCntFlag: json['rmCntFlag'],
      saleDateFlagCd: json['saleDateFlagCd'],
      goodsTypeDtlNm: json['goodsTypeDtlNm'],
      category1Seq: json['category1Seq'],
      saleDateFlag: json['saleDateFlag'],
      rmIdBuyCntFlagCd: json['rmIdBuyCntFlagCd'],
      regdate: json['regdate'] != null ? DateTime.parse(json['regdate']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'idx': idx,
        'goodsCode': goodsCode,
        'goodsNo': goodsNo,
        'goodsName': goodsName,
        'brandCode': brandCode,
        'brandName': brandName,
        'content': content,
        'contentAddDesc': contentAddDesc,
        'goodsTypeCd': goodsTypeCd,
        'goodstypeNm': goodstypeNm,
        'goodsImgS': goodsImgS,
        'goodsImgB': goodsImgB,
        'goodsDescImgWeb': goodsDescImgWeb,
        'brandIconImg': brandIconImg,
        'mmsGoodsImg': mmsGoodsImg,
        'discount_price': discountPrice,
        'realPrice': realPrice,
        'salePrice': salePrice,
        'valid_prd_type_cd': validPrdTypeCd,
        'limit_day': limitDay,
        'validPrdDay': validPrdDay,
        'endDate': endDate,
        'goodsComId': goodsComId,
        'goodsComName': goodsComName,
        'affiliateId': affiliateId,
        'affiliate': affiliate,
        'exhGenderCd': exhGenderCd,
        'exhAgeCd': exhAgeCd,
        'mmsReserveFlag': mmsReserveFlag,
        'goodsStateCd': goodsStateCd,
        'mmsBarcdCreateYn': mmsBarcdCreateYn,
        'rmCntFlag': rmCntFlag,
        'saleDateFlagCd': saleDateFlagCd,
        'goodsTypeDtlNm': goodsTypeDtlNm,
        'category1Seq': category1Seq,
        'saleDateFlag': saleDateFlag,
        'rmIdBuyCntFlagCd': rmIdBuyCntFlagCd,
        'regdate': regdate?.toIso8601String(),
      };
}

class CouponResponse {
  final bool status;
  final String message;
  final List<CouponModel> data;

  CouponResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    List<CouponModel> data = dataList.map((item) => CouponModel.fromJson(item)).toList();

    return CouponResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((coupon) => coupon.toJson()).toList(),
      };
}
