class ProfitWithdrawModel {
  bool success;
  double balance;
  List<SellerWithdrawRequest> sellerWithdrawRequest;

  ProfitWithdrawModel({this.success, this.balance, this.sellerWithdrawRequest});

  ProfitWithdrawModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    balance = double.parse(json['balance'].toString());
    if (json['seller_withdraw_request'] != null) {
      sellerWithdrawRequest = new List<SellerWithdrawRequest>();
      json['seller_withdraw_request'].forEach((v) {
        sellerWithdrawRequest.add(new SellerWithdrawRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['balance'] = this.balance;
    if (this.sellerWithdrawRequest != null) {
      data['seller_withdraw_request'] =
          this.sellerWithdrawRequest.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SellerWithdrawRequest {
  int id;
  int userId;
  int amount;
  String message;
  int status;
  int viewed;
  String createdAt;
  String updatedAt;

  SellerWithdrawRequest(
      {this.id,
      this.userId,
      this.amount,
      this.message,
      this.status,
      this.viewed,
      this.createdAt,
      this.updatedAt});

  SellerWithdrawRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'] == null ? 0 : json['amount'];
    message = json['message'] == null ? "" : json['message'];
    status = json['status'];
    viewed = json['viewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['message'] = this.message;
    data['status'] = this.status;
    data['viewed'] = this.viewed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
