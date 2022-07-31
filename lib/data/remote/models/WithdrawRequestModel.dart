class WithdrawRequestModel {
  bool success;
  SellerWithdrawRequest sellerWithdrawRequest;

  WithdrawRequestModel({this.success, this.sellerWithdrawRequest});

  WithdrawRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sellerWithdrawRequest = json['seller_withdraw_request'] != null
        ? new SellerWithdrawRequest.fromJson(json['seller_withdraw_request'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.sellerWithdrawRequest != null) {
      data['seller_withdraw_request'] = this.sellerWithdrawRequest.toJson();
    }
    return data;
  }
}

class SellerWithdrawRequest {
  int userId;
  int amount;
  String message;
  String status;
  String viewed;
  String updatedAt;
  String createdAt;
  int id;

  SellerWithdrawRequest(
      {this.userId,
        this.amount,
        this.message,
        this.status,
        this.viewed,
        this.updatedAt,
        this.createdAt,
        this.id});

  SellerWithdrawRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    amount = int.parse(json['amount'].toString());
    message = json['message'];
    status = json['status'];
    viewed = json['viewed'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['message'] = this.message;
    data['status'] = this.status;
    data['viewed'] = this.viewed;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}