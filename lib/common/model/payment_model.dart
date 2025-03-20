import 'dart:convert';

class PaymentModel {
  int? idx;
  String? trId;
  String? orderNo;
  String? userId;
  String? goodsCode;
  String? goodsName;
  String? goodsComName;
  String? goodsImgS;
  String? goodsImgB;
  int? limitDay;
  int? validPrdDay;
  int? pinStatusCd;
  String? pinStatusNm;
  int? realPrice;
  String? message;
  String? orderNumber;
  String? pinNo;
  String? couponImgUrl;
  String? regdate;

  PaymentModel({
    this.idx,
    this.trId,
    this.orderNo,
    this.userId,
    this.goodsCode,
    this.goodsName,
    this.goodsComName,
    this.goodsImgS,
    this.goodsImgB,
    this.limitDay,
    this.validPrdDay,
    this.pinStatusCd,
    this.pinStatusNm,
    this.realPrice,
    this.message,
    this.orderNumber,
    this.pinNo,
    this.couponImgUrl,
    this.regdate,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      idx: json['idx'],
      trId: json['tr_id'],
      orderNo: json['order_no'],
      userId: json['user_id'],
      goodsCode: json['goodsCode'],
      goodsName: json['goodsName'],
      goodsComName: json['goodsComName'],
      goodsImgS: json['goodsImgS'],
      goodsImgB: json['goodsImgB'],
      limitDay: json['limit_day'],
      validPrdDay: json['validPrdDay'],
      pinStatusCd: json['pinStatusCd'],
      pinStatusNm: json['pinStatusNm'],
      realPrice: json['realPrice'],
      message: json['message'].toString(),
      orderNumber: json['orderNo'].toString(),
      pinNo: json['pinNo'].toString(),
      couponImgUrl: json['couponImgUrl'],
      regdate: json['regdate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'tr_id': trId,
      'order_no': orderNo,
      'user_id': userId,
      'goodsCode': goodsCode,
      'goodsName': goodsName,
      'goodsComName': goodsComName,
      'goodsImgS': goodsImgS,
      'goodsImgB': goodsImgB,
      'limit_day': limitDay,
      'validPrdDay': validPrdDay,
      'pinStatusCd': pinStatusCd,
      'pinStatusNm': pinStatusNm,
      'realPrice': realPrice,
      'message': message,
      'orderNo': orderNumber,
      'pinNo': pinNo,
      'couponImgUrl': couponImgUrl,
      'regdate': regdate,
    };
  }
}

class PaymentModelResponse {
  final bool status;
  final String message;
  final List<PaymentModel> data;

  PaymentModelResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentModelResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    List<PaymentModel> data = dataList.map((item) => PaymentModel.fromJson(item)).toList();

    return PaymentModelResponse(
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

