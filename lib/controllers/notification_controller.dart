import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/notificationModel.dart';
import 'package:my_medical_app/defaultTheme/screen/notifications/notificationsPresenter.dart';
import 'package:my_medical_app/utils/helpers.dart';

class NotificationController extends GetxController
    implements NotificationsCallBack {
  List<NotificationData> notificationsList = List<NotificationData>().obs;
  NotificationsPresenter presenter;
  var isLoadingData = false.obs;
  var notificationCount = 0.obs;

  init() {
    Helpers.isLoggedIn().then((_result) {
      if (_result) {
        if (presenter == null) {
          presenter =
              NotificationsPresenter(context: Get.context, callBack: this);
        }
        getNotifications();
      }
    });
  }

  getNotifications() {
    presenter.loadNotificationsData();
  }

  markAsRead(int id) {
    presenter.markNotification(id);
  }

  @override
  void onDataError(String message) {
    Get.snackbar("${translator.translate("error")}", '$message');
  }

  @override
  void onDataLoading(bool show) {
    isLoadingData.value = show;
  }

  @override
  void onDataSuccess(List<NotificationData> data) {
    notificationsList.clear();
    notificationsList.addAll(data);

    int count = 0;
    for (NotificationData n in data) {
      if (n.isRead == 0) {
        count++;
      }
    }
    notificationCount.value = count;
  }

  @override
  void onMarkSuccess(
    bool show,
  ) {
    getNotifications();
  }
}
