class CartModel {
  List<CartData> data;
  bool success;
  int status;

  CartModel({this.data, this.success, this.status});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CartData>();
      json['data'].forEach((v) {
        data.add(new CartData.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class CartData {
  int id;
  CartProduct product;
  String variation;
  double price;
  double tax;
  double shippingCost;
  double quantity;
  String date;

  CartData(
      {this.id,
      this.product,
      this.variation,
      this.price,
      this.tax,
      this.shippingCost,
      this.quantity,
      this.date});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? new CartProduct.fromJson(json['product'])
        : null;
    variation = json['variation'];
    price = json['price'] != null ? double.parse(json['price'].toString()):double.parse(json['grand_total'].toString());
    tax = json['tax'] != null ? double.parse(json['tax'].toString()):00;
    shippingCost = json['shipping_cost'] != null ? double.parse(json['shipping_cost'].toString()):00;
    quantity = json['quantity'] != null ? double.parse(json['quantity'].toString()):00;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    data['variation'] = this.variation;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['shipping_cost'] = this.shippingCost;
    data['quantity'] = this.quantity;
    data['date'] = this.date;
    return data;
  }
}

class CartProduct {
  String name;
  String image;
  int id;

  CartProduct({this.name, this.image, this.id});

  CartProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}
