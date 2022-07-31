import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/RefundModel.dart';
import 'package:my_medical_app/data/remote/models/myOrdersModel.dart';
import 'package:my_medical_app/data/remote/models/orderDetailsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_orders_screen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/shopHop/screens/ShHomeFragment.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helper.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/utils/long_string_print.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:developer';

class MyOrdersPresenter {
  final BuildContext context;
  MyOrdersCallBack callBack;
  OrderDetailsCallBack orderDetailsCallBack;

  MyOrdersPresenter({this.context, this.callBack, this.orderDetailsCallBack});

  getMyOrdersData() {
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'getUserOrders?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'getUserOrders';
      LongStringPrint().printWrapped(user.accessToken);
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
            LongStringPrint().printWrapped(response.toString());
            MyOrdersModel data = MyOrdersModel.fromJson(response);
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

  getOrderDetailsData(String id) {
    print(id);
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'trackYourOrder/' + id;

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
            OrderDetailsModel data = OrderDetailsModel.fromJson(response);
            if (data.success) {
              orderDetailsCallBack.onDataSuccess(data.data);
            } else {
              orderDetailsCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            orderDetailsCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            orderDetailsCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  makeCancel(String orderID) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'cancelOrder/$orderID';

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
            if (response['success']) {
              Get.defaultDialog(
                  confirm: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    onPressed: () {
                      Get.offAll(() => ShHomeScreen());
                    },
                    child: Text("${translator.translate("ok")}"),
                  ),
                  title: "${translator.translate("success")}",
                  middleText: "${response['message']}");
            } else {
              orderDetailsCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            orderDetailsCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            orderDetailsCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  makeRefund(String orderID, String reason, String reasonID) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'refundRequest';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      Map<String, dynamic> body = {
        'order_details_id': orderID,
        'reason': reason,
        'resone_id': reasonID
      };
      print(body);
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), body: body, headers: headers),
          onResponse: (response) {
            RefundModel data = RefundModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              String message =
                  Constants.LANG == "en" ? "Request sent" : "تم ارسال الطلب";
              orderDetailsCallBack.onRefundSuccess(data.success, message);
            } else {
              orderDetailsCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            orderDetailsCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            orderDetailsCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  makeReview(String itemId, String rating, String comment) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL +
          'reviews/insertProductReview?product_id=' +
          itemId +
          '&rating=' +
          rating +
          '&comment=' +
          comment;

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.post(Uri.parse(url), headers: headers),
          onResponse: (response) {
            RefundModel data = RefundModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              String message =
                  Constants.LANG == "en" ? "Review sent" : "تم ارسال المراجعة";
              orderDetailsCallBack.onReviewSuccess(data.success, message);
            } else {
              orderDetailsCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            orderDetailsCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            orderDetailsCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class MyOrdersCallBack {
  void onDataSuccess(List<MyOrdersData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class OrderDetailsCallBack {
  void onRefundSuccess(bool result, String message);

  void onReviewSuccess(bool result, String message);

  void onDataSuccess(OrderDetailsData data);

  void onDataLoading(bool show);

  void onDataError(String message);
}
