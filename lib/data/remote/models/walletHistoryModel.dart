class WalletHistoryModel {
  bool success;
  List<WalletHistoryData> data;

  WalletHistoryModel({this.success, this.data});

  WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<WalletHistoryData>();
      json['data'].forEach((v) {
        data.add(new WalletHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletHistoryData {
  int id;
  int userId;
  double amount;
  String paymentMethod;
  String paymentDetails;
  int approval;
  int offlinePayment;
  String reciept;
  String fawryRefNum;
  String createdAt;
  String updatedAt;

  WalletHistoryData(
      {this.id,
        this.userId,
        this.amount,
        this.paymentMethod,
        this.paymentDetails,
        this.approval,
        this.offlinePayment,
        this.reciept,
        this.fawryRefNum,
        this.createdAt,
        this.updatedAt});

  WalletHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = double.parse(json['amount'].toString());
    paymentMethod = json['payment_method'];
    paymentDetails = json['payment_details'];
    approval = json['approval'];
    offlinePayment = json['offline_payment'];
    reciept = json['reciept'];
    fawryRefNum = json['fawry_ref_num'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['payment_method'] = this.paymentMethod;
    data['payment_details'] = this.paymentDetails;
    data['approval'] = this.approval;
    data['offline_payment'] = this.offlinePayment;
    data['reciept'] = this.reciept;
    data['fawry_ref_num'] = this.fawryRefNum;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}