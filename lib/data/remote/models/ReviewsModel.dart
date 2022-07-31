class ReviewsModel {
  String userName;
  int rating;
  String comment;
  String time;

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    this.userName = json['user']['name'];
    this.rating = json['rating'];
    this.comment = json['comment'];
    this.time = json['time'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['user']['name'] = this.userName;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['time'] = this.time;
    return data;
  }
}

/*
class ReviewsModel {
  bool success;
  Reviews reviews;

  ReviewsModel({this.success, this.reviews});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    reviews =
    json['reviews'] != null ? new Reviews.fromJson(json['reviews']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.reviews != null) {
      data['reviews'] = this.reviews.toJson();
    }
    return data;
  }
}

class Reviews {
  int currentPage;
  List<ReviewsData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  Reviews(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Reviews.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<ReviewsData>();
      json['data'].forEach((v) {
        data.add(new ReviewsData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ReviewsData {
  int id;
  String comment;
  int status;
  int rating;
  int productId;
  String productName;
  String userName;
  String userEmail;

  ReviewsData(
      {this.id,
        this.comment,
        this.status,
        this.rating,
        this.productId,
        this.productName,
        this.userName,
        this.userEmail});

  ReviewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    status = json['status'];
    rating = json['rating'];
    productId = json['product_id'];
    productName = json['product_name'];
    userName = json['user_name'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['rating'] = this.rating;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    return data;
  }
}*/
