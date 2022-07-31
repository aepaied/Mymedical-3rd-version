class VendorRefundModel {
  List<RefundData> data;
  RefundLinks links;
  Meta meta;
  bool success;

  VendorRefundModel({this.data, this.links, this.meta, this.success});

  VendorRefundModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<RefundData>();
      json['data'].forEach((v) {
        data.add(new RefundData.fromJson(v));
      });
    }
    links = json['links'] != null ? new RefundLinks.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class RefundData {
  int id;
  int sellerApproval;
  int adminApproval;
  int refundAmount;
  String reason;
  String adminReason;
  int adminSeen;
  int refundStatus;
  String createdAt;
  String orderCode;
  int price;
  String productName;

  RefundData(
      {this.id,
        this.sellerApproval,
        this.adminApproval,
        this.refundAmount,
        this.reason,
        this.adminReason,
        this.adminSeen,
        this.refundStatus,
        this.createdAt,
        this.orderCode,
        this.price,
        this.productName});

  RefundData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerApproval = json['seller_approval'];
    adminApproval = json['admin_approval'];
    refundAmount = json['refund_amount'];
    reason = json['reason'];
    adminReason = json['admin_reason'];
    adminSeen = json['admin_seen'];
    refundStatus = json['refund_status'];
    createdAt = json['created_at'];
    orderCode = json['order_code'];
    price = json['price'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seller_approval'] = this.sellerApproval;
    data['admin_approval'] = this.adminApproval;
    data['refund_amount'] = this.refundAmount;
    data['reason'] = this.reason;
    data['admin_reason'] = this.adminReason;
    data['admin_seen'] = this.adminSeen;
    data['refund_status'] = this.refundStatus;
    data['created_at'] = this.createdAt;
    data['order_code'] = this.orderCode;
    data['price'] = this.price;
    data['product_name'] = this.productName;
    return data;
  }
}

class RefundLinks {
  String first;
  String last;
  String prev;
  String next;

  RefundLinks({this.first, this.last, this.prev, this.next});

  RefundLinks.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}