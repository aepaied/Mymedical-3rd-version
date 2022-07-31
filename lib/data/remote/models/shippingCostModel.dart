class ShippingCostModel {
  bool success;
  String shippingDate;
  double shippingCost;

  ShippingCostModel({this.success, this.shippingDate, this.shippingCost});

  ShippingCostModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    json.containsKey('shipping_date')
        ? shippingDate = json['shipping_date']
        : shippingDate = null;
    json.containsKey('shipping_cost')
        ?
    shippingCost = double.parse(json['shipping_cost'].toString()) : shippingCost
    =
    null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['shipping_date'] = this.shippingDate;
    data['shipping_cost'] = this.shippingCost;
    return data;
  }
}
