
import 'dart:convert';
class NotificationModel {
  bool success;
  List<NotificationData> data;

  NotificationModel({this.success, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<NotificationData>();
      json['data'].forEach((v) {
        data.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int id;
  int recieverId;
  // String notificationBody;
  NotificationBody notificationBody;
  int isRead;
  String createdAt;
  String updatedAt;

  NotificationData(
      {this.id,
        this.recieverId,
        this.notificationBody,
        this.isRead,
        this.createdAt,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recieverId = json['reciever_id'];
    // notificationBody = json['notification_body'];
    notificationBody = json['notification_body'] != null
        ? new NotificationBody.fromJson(jsonDecode(json['notification_body']))
        : null;
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reciever_id'] = this.recieverId;
    // data['notification_body'] = this.notificationBody;
    if (this.notificationBody != null) {
      data['notification_body'] = this.notificationBody.toJson();
    }
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class NotificationBody {
  int recieverId;
  String type;
  int orderId;
  int ticketId;
  String title;
  String text;
  String clickAction;
  bool sound;
  String icon;
  String androidChannelId;
  String highPriority;
  bool showInForeground;

  NotificationBody(
      {this.recieverId,
        this.type,
        this.orderId,
        this.ticketId,
        this.title,
        this.text,
        this.clickAction,
        this.sound,
        this.icon,
        this.androidChannelId,
        this.highPriority,
        this.showInForeground});

  NotificationBody.fromJson(Map<String, dynamic> json) {
    recieverId = json['reciever_id'];
    type = json['type'];
    orderId = json['order_id'];
    ticketId = json['ticket_id'];
    title = json['title'];
    text = json['text'];
    clickAction = json['click_action'];
    sound = json['sound'];
    icon = json['icon'];
    androidChannelId = json['android_channel_id'];
    highPriority = json['high_priority'];
    showInForeground = json['show_in_foreground'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reciever_id'] = this.recieverId;
    data['type'] = this.type;
    data['order_id'] = this.orderId;
    data['ticket_id'] = this.ticketId;
    data['title'] = this.title;
    data['text'] = this.text;
    data['click_action'] = this.clickAction;
    data['sound'] = this.sound;
    data['icon'] = this.icon;
    data['android_channel_id'] = this.androidChannelId;
    data['high_priority'] = this.highPriority;
    data['show_in_foreground'] = this.showInForeground;
    return data;
  }
}