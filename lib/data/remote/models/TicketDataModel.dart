class TicketDataModel {
  bool success;
  SingleTicketData data;

  TicketDataModel({this.success, this.data});

  TicketDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new SingleTicketData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class SingleTicketData {
  int id;
  int code;
  int userId;
  String subject;
  String details;
  List<String> files;
  String status;
  int viewed;
  int clientViewed;
  String createdAt;
  String updatedAt;
  List<Ticketreplies> ticketreplies;

  SingleTicketData(
      {this.id,
        this.code,
        this.userId,
        this.subject,
        this.details,
        this.files,
        this.status,
        this.viewed,
        this.clientViewed,
        this.createdAt,
        this.updatedAt,
        this.ticketreplies});

  SingleTicketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    subject = json['subject'];
    details = json['details'];
    // files = json['files'];
    status = json['status'];
    viewed = json['viewed'];
    clientViewed = json['client_viewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['ticketreplies'] != null) {
      ticketreplies = new List<Ticketreplies>();
      json['ticketreplies'].forEach((v) {
        ticketreplies.add(new Ticketreplies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['subject'] = this.subject;
    data['details'] = this.details;
    // data['files'] = this.files;
    data['status'] = this.status;
    data['viewed'] = this.viewed;
    data['client_viewed'] = this.clientViewed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.ticketreplies != null) {
      data['ticketreplies'] =
          this.ticketreplies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ticketreplies {
  int id;
  int ticketId;
  int user_id;
  String reply;
  String files;
  String createdAt;

  Ticketreplies(
      {this.id,
      this.ticketId,
      this.user_id,
      this.reply,
      this.files,
      this.createdAt});

  Ticketreplies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    user_id = json['user_id'];
    reply = json['reply'];
    // files = json['files'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_id'] = this.ticketId;
    data['user_id'] = this.user_id;
    data['reply'] = this.reply;
    data['files'] = this.files;
    data['created_at'] = this.createdAt;
    return data;
  }
}