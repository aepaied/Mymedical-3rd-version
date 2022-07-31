class TicketsModel {
  List<TicketData> data;
  bool success;
  int status;

  TicketsModel({this.data, this.success, this.status});

  TicketsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TicketData>();
      json['data'].forEach((v) {
        data.add(new TicketData.fromJson(v));
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

class TicketData {
  int id;
  String ticketId;
  String subject;
  String details;
  String status;
  List<String> files;
  String sendingDate;
  List<Replies> replies;

  TicketData(
      {this.id,
        this.ticketId,
        this.subject,
        this.details,
        this.status,
        this.files,
        this.sendingDate,
        this.replies});

  TicketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'].toString();
    subject = json['subject'];
    details = json['details'];
    status = json['status'];
    // files = json['files'].cast<String>();
    sendingDate = json['sending_date'];
    if (json['replies'] != null) {
      replies = new List<Replies>();
      json['replies'].forEach((v) {
        replies.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_id'] = this.ticketId;
    data['subject'] = this.subject;
    data['details'] = this.details;
    data['status'] = this.status;
    // data['files'] = this.files;
    data['sending_date'] = this.sendingDate;
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replies {
  int id;
  int ticketId;
  String reply;
  List<String> files;
  String createdAt;

  Replies({this.id, this.ticketId, this.reply, this.files, this.createdAt});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    reply = json['reply'];
    // files = json['files'].cast<String>();
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_id'] = this.ticketId;
    data['reply'] = this.reply;
    // data['files'] = this.files;
    data['created_at'] = this.createdAt;
    return data;
  }
}