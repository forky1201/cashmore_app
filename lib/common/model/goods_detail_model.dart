class GoodsDetail {
  String? rmIdBuyCntFlagCd;
  int? discountRate;
  int? goldPrice;
  String? mdCode;
  int? vipDiscountRate;
  int? discountPrice;
  String? mmsGoodsImg;
  int? limitDay;
  String? content;
  String? goodsImgB;
  String? goodsTypeNm;
  String? categoryName1;
  int? vipPrice;
  String? goodsName;
  String? mmsReserveFlag;
  String? goodsStateCd;
  String? brandCode;
  int? goldDiscountRate;
  int? goodsNo;
  int? platinumPrice;
  String? brandName;
  int? salePrice;
  String? brandIconImg;
  String? rmCntFlag;
  String? goodsTypeCd;
  int? platinumDiscountRate;
  int? categorySeq1;
  String? goodsCode;
  String? goodsTypeDtlNm;
  String? goodsImgS;
  String? affiliate;
  String? saleDateFlag;
  int? realPrice;

  GoodsDetail({
    this.rmIdBuyCntFlagCd,
    this.discountRate,
    this.goldPrice,
    this.mdCode,
    this.vipDiscountRate,
    this.discountPrice,
    this.mmsGoodsImg,
    this.limitDay,
    this.content,
    this.goodsImgB,
    this.goodsTypeNm,
    this.categoryName1,
    this.vipPrice,
    this.goodsName,
    this.mmsReserveFlag,
    this.goodsStateCd,
    this.brandCode,
    this.goldDiscountRate,
    this.goodsNo,
    this.platinumPrice,
    this.brandName,
    this.salePrice,
    this.brandIconImg,
    this.rmCntFlag,
    this.goodsTypeCd,
    this.platinumDiscountRate,
    this.categorySeq1,
    this.goodsCode,
    this.goodsTypeDtlNm,
    this.goodsImgS,
    this.affiliate,
    this.saleDateFlag,
    this.realPrice,
  });

  factory GoodsDetail.fromJson(Map<String, dynamic> json) {
    return GoodsDetail(
      rmIdBuyCntFlagCd: json['rmIdBuyCntFlagCd'],
      discountRate: json['discountRate'],
      goldPrice: json['goldPrice'],
      mdCode: json['mdCode'],
      vipDiscountRate: json['vipDiscountRate'],
      discountPrice: json['discountPrice'],
      mmsGoodsImg: json['mmsGoodsImg'],
      limitDay: json['limitDay'],
      content: json['content'],
      goodsImgB: json['goodsImgB'],
      goodsTypeNm: json['goodsTypeNm'],
      categoryName1: json['categoryName1'],
      vipPrice: json['vipPrice'],
      goodsName: json['goodsName'],
      mmsReserveFlag: json['mmsReserveFlag'],
      goodsStateCd: json['goodsStateCd'],
      brandCode: json['brandCode'],
      goldDiscountRate: json['goldDiscountRate'],
      goodsNo: json['goodsNo'],
      platinumPrice: json['platinumPrice'],
      brandName: json['brandName'],
      salePrice: json['salePrice'],
      brandIconImg: json['brandIconImg'],
      rmCntFlag: json['rmCntFlag'],
      goodsTypeCd: json['goodsTypeCd'],
      platinumDiscountRate: json['platinumDiscountRate'],
      categorySeq1: json['categorySeq1'],
      goodsCode: json['goodsCode'],
      goodsTypeDtlNm: json['goodsTypeDtlNm'],
      goodsImgS: json['goodsImgS'],
      affiliate: json['affiliate'],
      saleDateFlag: json['saleDateFlag'],
      realPrice: json['realPrice'],
    );
  }

  Map<String, dynamic> toJson() => {
        'rmIdBuyCntFlagCd': rmIdBuyCntFlagCd,
        'discountRate': discountRate,
        'goldPrice': goldPrice,
        'mdCode': mdCode,
        'vipDiscountRate': vipDiscountRate,
        'discountPrice': discountPrice,
        'mmsGoodsImg': mmsGoodsImg,
        'limitDay': limitDay,
        'content': content,
        'goodsImgB': goodsImgB,
        'goodsTypeNm': goodsTypeNm,
        'categoryName1': categoryName1,
        'vipPrice': vipPrice,
        'goodsName': goodsName,
        'mmsReserveFlag': mmsReserveFlag,
        'goodsStateCd': goodsStateCd,
        'brandCode': brandCode,
        'goldDiscountRate': goldDiscountRate,
        'goodsNo': goodsNo,
        'platinumPrice': platinumPrice,
        'brandName': brandName,
        'salePrice': salePrice,
        'brandIconImg': brandIconImg,
        'rmCntFlag': rmCntFlag,
        'goodsTypeCd': goodsTypeCd,
        'platinumDiscountRate': platinumDiscountRate,
        'categorySeq1': categorySeq1,
        'goodsCode': goodsCode,
        'goodsTypeDtlNm': goodsTypeDtlNm,
        'goodsImgS': goodsImgS,
        'affiliate': affiliate,
        'saleDateFlag': saleDateFlag,
        'realPrice': realPrice,
      };
}

class GoodsDetailResult {
  final GoodsDetail? goodsDetail;

  GoodsDetailResult({this.goodsDetail});

  factory GoodsDetailResult.fromJson(Map<String, dynamic> json) {
    return GoodsDetailResult(
      goodsDetail: json['goodsDetail'] != null ? GoodsDetail.fromJson(json['goodsDetail']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'goodsDetail': goodsDetail?.toJson(),
      };
}

class GoodsDetailData {
  final int? code;
  final String? message;
  final GoodsDetailResult? result;

  GoodsDetailData({
    this.code,
    this.message,
    this.result,
  });

  factory GoodsDetailData.fromJson(Map<String, dynamic> json) {
    return GoodsDetailData(
      code: json['code'],
      message: json['message'],
      result: json['result'] != null ? GoodsDetailResult.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'result': result?.toJson(),
      };
}

class GoodsDetailResponse {
  final bool? status;
  final String? message;
  final GoodsDetailData? data;
  final int? code;

  GoodsDetailResponse({
    this.status,
    this.message,
    this.data,
    this.code,
  });

  factory GoodsDetailResponse.fromJson(Map<String, dynamic> json) {
    return GoodsDetailResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? GoodsDetailData.fromJson(json['data']) : null,
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
