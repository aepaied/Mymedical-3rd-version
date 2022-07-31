class LogoutModel {
  String message;
  bool status = false;

  LogoutModel({this.message,
    this.status});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    // message = json['message'];
    if (json.containsKey("message")) {
      status = true;
      message = json['message'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}