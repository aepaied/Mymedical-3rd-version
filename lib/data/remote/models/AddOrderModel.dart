class AddOrderModel {
  bool success;
  int orderId;
  String message;

  AddOrderModel({this.success, this.orderId, this.message});

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    orderId = json['order_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['order_id'] = this.orderId;
    data['message'] = this.message;
    return data;
  }
}