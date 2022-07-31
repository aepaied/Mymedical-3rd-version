class RefundReason {
  String id;
  String reason;

  RefundReason({this.id, this.reason});

  RefundReason.fromJson(Map<String, dynamic> json) {
    this.id = json['id'].toString();
    this.reason = json['resone'];
  }
}
