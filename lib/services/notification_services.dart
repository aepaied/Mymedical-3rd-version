import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void arToEn() {
    firebaseMessaging.subscribeToTopic('fire_notification_en');
    firebaseMessaging.unsubscribeFromTopic('fire_notification_ar');

  }

  void enToAr() {
    firebaseMessaging.subscribeToTopic('fire_notification_ar');
    firebaseMessaging.unsubscribeFromTopic('fire_notification_en');
  }

}