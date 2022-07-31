import 'dart:convert';

class OrderDetailsModel {
  OrderDetailsData data;
  String message;
  bool success = false;

  OrderDetailsModel({this.data, this.message, this.success});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data')) {
      success = true;
      data = json['data'] != null
          ? new OrderDetailsData.fromJson(json['data'])
          : null;
    } else {
      success = false;
    }

    message = json.containsKey('message') ? json['message'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
      data['message'] = this.message;
    }
    return data;
  }
}

class OrderDetailsData {
  int id;
  int userId;
  String guestId;
  ShippingAddress shippingAddress;
  String paymentType;
  int paymentMerchentRef;
  int paymentRefrence;
  int manualPayment;
  String manualPaymentData;
  String paymentStatus;
  String paymentDetails;
  String grandTotal;
  int couponDiscount;
  String code;
  String date;
  int viewed;
  int deliveryViewed;
  String delivery_status;
  int paymentStatusViewed;
  int isCancled;
  int commissionCalculated;
  String createdAt;
  String updatedAt;
  List<OrderDetails> orderDetails;

  OrderDetailsData(
      {this.id,
      this.userId,
      this.guestId,
      this.shippingAddress,
      this.paymentType,
      this.paymentMerchentRef,
      this.paymentRefrence,
      this.manualPayment,
      this.manualPaymentData,
      this.paymentStatus,
      this.paymentDetails,
      this.grandTotal,
      this.couponDiscount,
      this.code,
      this.date,
      this.viewed,
      this.deliveryViewed,
      this.delivery_status,
      this.paymentStatusViewed,
      this.isCancled,
      this.commissionCalculated,
      this.createdAt,
      this.updatedAt,
      this.orderDetails});

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    guestId = json['guest_id'];
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    paymentType = json['payment_type'];
    paymentMerchentRef = json['payment_merchent_ref'];
    paymentRefrence = json['payment_refrence'];
    manualPayment = json['manual_payment'];
    manualPaymentData = json['manual_payment_data'];
    paymentStatus = json['payment_status'];
    paymentDetails = json['payment_details'];
    grandTotal = json['grand_total'].toString();
    couponDiscount = json['coupon_discount'];
    code = json['code'];
    date = json['date'].toString();
    viewed = json['viewed'];
    deliveryViewed = json['delivery_viewed'];
    delivery_status = json['order_details'][0]['delivery_status'];
    paymentStatusViewed = json['payment_status_viewed'];
    isCancled = json['cancel_order'];
    commissionCalculated = json['commission_calculated'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['guest_id'] = this.guestId;
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress.toJson();
    }
    data['payment_type'] = this.paymentType;
    data['payment_merchent_ref'] = this.paymentMerchentRef;
    data['payment_refrence'] = this.paymentRefrence;
    data['manual_payment'] = this.manualPayment;
    data['manual_payment_data'] = this.manualPaymentData;
    data['payment_status'] = this.paymentStatus;
    data['payment_details'] = this.paymentDetails;
    data['grand_total'] = this.grandTotal;
    data['coupon_discount'] = this.couponDiscount;
    data['code'] = this.code;
    data['date'] = this.date;
    data['viewed'] = this.viewed;
    data['delivery_viewed'] = this.deliveryViewed;
    data['delivery_status'] = this.delivery_status;
    data['payment_status_viewed'] = this.paymentStatusViewed;
    data['cancel_order'] = this.isCancled;
    data['commission_calculated'] = this.commissionCalculated;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingAddress {
  String name;
  String email;
  String address;
  String country;
  String city;
  String region;
  String postalCode;
  String phone;
  String checkoutType;
  String shippingCost;

  ShippingAddress(
      {this.name,
      this.email,
      this.address,
      this.country,
      this.city,
      this.region,
      this.postalCode,
      this.phone,
      this.checkoutType,
      this.shippingCost});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    address = json['address'];
    country = json['country'].toString();
    city = json['city'].toString();
    region = json['region'].toString();
    postalCode = json['postal_code'].toString();
    phone = json['phone'].toString();
    checkoutType = json['checkout_type'];
    shippingCost = json['shipping_cost'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['region'] = this.region;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['checkout_type'] = this.checkoutType;
    data['shipping_cost'] = this.shippingCost;
    return data;
  }
}

class OrderDetails {
  int id;
  int orderId;
  int sellerId;
  int productId;
  String variation;
  double price;
  int tax;
  int shippingCost;
  int quantity;
  String sellerStatus;
  String paymentStatus;
  String deliveryStatus;
  String shippingType;
  String productReferralCode;
  Product product;
  bool isReviewed;
  bool isRefunded;

  OrderDetails(
      {this.id,
      this.orderId,
      this.sellerId,
      this.productId,
      this.variation,
      this.price,
      this.tax,
      this.shippingCost,
      this.quantity,
      this.sellerStatus,
      this.paymentStatus,
      this.deliveryStatus,
      this.shippingType,
      this.productReferralCode,
      this.isReviewed,
      this.isRefunded,
      this.product});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    sellerId = json['seller_id'];
    productId = json['product_id'];
    variation = json['variation'];
    price = double.parse(json['price'].toString());
    tax = json['tax'];
    shippingCost = json['shipping_cost'];
    quantity = json['quantity'];
    sellerStatus = json['seller_status'];
    paymentStatus = json['payment_status'];
    deliveryStatus = json['delivery_status'];
    shippingType = json['shipping_type'];
    isReviewed = json['is_reviewed'];
    isRefunded = json['is_refunded'];
    productReferralCode = json['product_referral_code'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['seller_id'] = this.sellerId;
    data['product_id'] = this.productId;
    data['variation'] = this.variation;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['shipping_cost'] = this.shippingCost;
    data['quantity'] = this.quantity;
    data['seller_status'] = this.sellerStatus;
    data['payment_status'] = this.paymentStatus;
    data['delivery_status'] = this.deliveryStatus;
    data['shipping_type'] = this.shippingType;
    data['is_reviewed'] = this.isReviewed;
    data['is_refunded'] = this.isRefunded;
    data['product_referral_code'] = this.productReferralCode;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  int id;
  String name;
  String thumbnailImg;
  int unitPrice;
  String addedBy;
  int userId;
  OrderDetailsUser user;

  Product(
      {this.id,
      this.name,
      this.thumbnailImg,
      this.unitPrice,
      this.addedBy,
      this.userId,
      this.user});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailImg = json['thumbnail_img'];
    unitPrice = json['unit_price'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    user = json['user'] != null
        ? new OrderDetailsUser.fromJson(json['user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnail_img'] = this.thumbnailImg;
    data['unit_price'] = this.unitPrice;
    data['added_by'] = this.addedBy;
    data['user_id'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class OrderDetailsUser {
  int id;
  String name;
  String avatarOriginal;

  OrderDetailsUser({this.id, this.name, this.avatarOriginal});

  OrderDetailsUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatarOriginal = json['avatar_original'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar_original'] = this.avatarOriginal;
    return data;
  }
}
