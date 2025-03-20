import 'package:cashmore_app/common/model/brand_model.dart';
import 'package:cashmore_app/common/model/coupon_model.dart';
import 'package:cashmore_app/common/model/goods_detail_model.dart';
import 'package:cashmore_app/common/model/payment_model.dart';
import 'package:cashmore_app/repository/common/apiService.dart';

class CouponRepsitory {
  CouponRepsitory._internal();

  static final _singleton = CouponRepsitory._internal();

  factory CouponRepsitory() => _singleton;

  /* 상품 브랜드별 조회*/
  Future<List<BrandModel>> brandList(String userId) async {
    return await Api().authDio.get('/api/bizapi_brands', queryParameters: {"user_id": userId}).then((res) {
      // 전체 응답 파싱
      BrandResponse response = BrandResponse.fromJson(res.data);

      // 응답 데이터의 브랜드 목록 반환
      if (response.data?.result?.brandList != null) {
        return response.data!.result!.brandList!;
      } else {
        return []; // brandList가 없을 경우 빈 리스트 반환
      }
    });
  }

  /* 상품 브랜드 조회*/
  Future<List<CouponModel>> brandByList(String userId, String brandCode, int offset, int pageSize) async {
    return await Api().authDio.get('/api/bizapi_brands_lists', queryParameters: {"user_id": userId, "brandcode": brandCode, "offset": offset, "pageSize": pageSize}).then((res) {
      CouponResponse data = CouponResponse.fromJson(res.data);
      return data.data;
    });
  }

// 상품 상세
  Future<GoodsDetail?> fetchGoodsDetail(String userId, String goodsCode) async {
    return await Api().authDio.get(
      '/api/bizapi_goods_detail',
      queryParameters: {
        "user_id": userId,
        "goods_code": goodsCode, // 상품 코드
      },
    ).then((res) {
      GoodsDetailResponse data = GoodsDetailResponse.fromJson(res.data);
      return data.data?.result?.goodsDetail;
    });
  }

  // 쿠폰발행(구매)
  Future<void> couponPay(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/bizapi_coupon_send', data: body).then((res) => res.data);
  }

  /* 쿠폰 구매내역 조회*/
  Future<List<PaymentModel>> paymentList(String userId, int offset, int pageSize) async {
    return await Api().authDio.get('/api/member_coupon_lists', queryParameters: {"user_id": userId, "offset": offset, "pageSize": pageSize}).then((res) {
      PaymentModelResponse data = PaymentModelResponse.fromJson(res.data);
      return data.data;
    });
  }

  // 쿠폰상태 업데이트
  //쿠폰리스트에서 쿠폰목록이미지 볼 때 호출 ( couponImagUrl 이거 호출할때 ) - 그럼 상태 업데이트~
  Future<void> couponUpdate(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/cooupon_status_update', data: body).then((res) => res.data);
  }

  //쿠폰 취소
  //
  Future<void> cancelCoupon(Map<String, dynamic> body) async {
    return await Api().authDio.post('/api/bizapi_coupon_delete', data: body).then((res) => res.data);
  }
}
