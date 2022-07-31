class CouponModel {
  bool success;
  String message;
  CouponData data;

  CouponModel({this.success, this.message, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json.containsKey('data')) {
      data =
          json['data'] != null ? new CouponData.fromJson(json['data']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CouponData {
  int couponId;
  double couponDiscount;

  CouponData({this.couponId, this.couponDiscount});

  CouponData.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    couponDiscount = json['coupon_discount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['coupon_discount'] = this.couponDiscount;
    return data;
  }
}
