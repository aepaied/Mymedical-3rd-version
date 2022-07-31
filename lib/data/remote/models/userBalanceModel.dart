class UserBalanceModel {
  bool success;
  double balance;

  UserBalanceModel({this.success, this.balance});

  UserBalanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    balance = double.parse(json['balance'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['balance'] = this.balance;
    return data;
  }
}