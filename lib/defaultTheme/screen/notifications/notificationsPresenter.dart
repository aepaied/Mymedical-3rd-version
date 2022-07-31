import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/markNotificationModel.dart';
import 'package:my_medical_app/data/remote/models/notificationModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';

class NotificationsPresenter {
  final BuildContext context;
  NotificationsCallBack callBack;
  NotificationsCountCallBack notificationsCountCallBack;

  NotificationsPresenter({this.context, this.callBack, this.notificationsCountCallBack});

  loadNotificationsData() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'notificationList';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            print(response);
            NotificationModel data = NotificationModel.fromJson(response);
            if (data.success) {
              callBack.onDataSuccess(data.data);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeRequest();
    });
  }


  loadNotificationsCount() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'notificationList';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            print(response);
            NotificationModel data = NotificationModel.fromJson(response);
            if (data.success) {
              int count = 0;
              for(NotificationData n in data.data){
                if(n.isRead == 1){
                  count++;
                }
              }

              notificationsCountCallBack.onNotificationsCountSuccess(count);
            } else {
              notificationsCountCallBack.onAllDataError("Error");
            }
          },
          onFailure: (error) {
            notificationsCountCallBack.onAllDataError(error.toString());
          },
          onLoading: (show) {
            notificationsCountCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  markNotification(int id) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'markAsRead/' + id.toString();

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            MarkNotificationModel data =
                MarkNotificationModel.fromJson(response);
            print(data.toString());
            callBack.onMarkSuccess(data.success);
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class NotificationsCallBack {
  void onDataSuccess(List<NotificationData> data);

  void onMarkSuccess(bool show);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class NotificationsCountCallBack {
  void onNotificationsCountSuccess(int count);

  void onDataLoading(bool show);

  void onAllDataError(String message);
}
