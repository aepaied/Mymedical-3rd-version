class MyOrdersModel {
  List<MyOrdersData> data;
  bool success = false;

  MyOrdersModel({this.data, this.success});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      success = true;
      data = new List<MyOrdersData>();
      print(json['data']);
      for (var item in json['data']) {
        data.add(new MyOrdersData.fromJson(item));
      }
      json['data'].forEach((value) {
        data.add(new MyOrdersData.fromJson(value));
      });
    } else {
      success = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyOrdersData {
  int id;
  String code;
  String paymentType;
  double grandTotal;
  int isCanceled;
  int viewed;
  int deliveryViewed;
  int paymentStatusViewed;
  String date;

  MyOrdersData(
      {this.id,
      this.code,
      this.paymentType,
      this.grandTotal,
      this.isCanceled,
      this.viewed,
      this.deliveryViewed,
      this.paymentStatusViewed,
      this.date});

  MyOrdersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    paymentType = json['payment_type'];
    grandTotal = double.parse(json['grand_total'].toString());
    viewed = json['viewed'];
    isCanceled = json['cancel_order'];
    deliveryViewed = json['delivery_viewed'];
    paymentStatusViewed = json['payment_status_viewed'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['payment_type'] = this.paymentType;
    data['grand_total'] = this.grandTotal;
    data['cancel_order'] = this.isCanceled;
    data['viewed'] = this.viewed;
    data['delivery_viewed'] = this.deliveryViewed;
    data['payment_status_viewed'] = this.paymentStatusViewed;
    data['date'] = this.date;
    return data;
  }
}
