class ProductReviewsModel {
  List<ProductReviewsData> data;
  bool success;
  int status;

  ProductReviewsModel({this.data, this.success, this.status});

  ProductReviewsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductReviewsData>();
      json['data'].forEach((v) {
        data.add(new ProductReviewsData.fromJson(v));
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

class ProductReviewsData {
  User user;
  String rating;
  String comment;
  String time;

  ProductReviewsData({this.user, this.rating, this.comment, this.time});

  ProductReviewsData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    rating = json['rating'].toString();
    comment = json['comment'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['time'] = this.time;
    return data;
  }
}

class User {
  String name;

  User({this.name});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}