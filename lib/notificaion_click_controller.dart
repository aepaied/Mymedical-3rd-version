import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/ticket_details.dart';

class NotificationClickController extends GetxController {
  dynamic notification;
  var tickedID = 0.obs;
  var type = "".obs;

  NotificationClickController(this.notification);

  void handleNotification() {
    var notificationData = notification.toString();
    notificationData = notificationData.replaceAll('{', '{"');
    notificationData = notificationData.replaceAll(': ', '": "');
    notificationData = notificationData.replaceAll(', ', '", "');
    notificationData = notificationData.replaceAll('}', '"}');
    final finalNotificationData = jsonDecode(notificationData);
    type.value = finalNotificationData['type'];
    if (type.value == "ticket_replay") {
      tickedID.value = int.parse(finalNotificationData['ticket_id']);
      Get.to(TicketDetails(ticketID: tickedID.value));
    }
  }
}
