import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/orderDetailsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_orders_presenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/models/refund_reason_model.dart';
import 'package:my_medical_app/size_config.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/long_string_print.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:http/http.dart' as http;

class MyOrderController extends GetxController implements OrderDetailsCallBack {
  final totalShippingCost = 0.0.obs;
  final orderTotal = 0.0.obs;
  final currentOrder = OrderDetailsData().obs;
  MyOrdersPresenter presenter;
  final isLoading = false.obs;
  final currentUser = User().obs;
  var refundReasonList = <RefundReason>[].obs;
  var chossenRefundReason = RefundReason().obs;
  List orderStepsList = ["pending", "on_review", "on_delivery", "delivered"];
  TextEditingController refuntReasonController = TextEditingController();
  TextEditingController refundDetailsController = TextEditingController();
  init(String orderID) {
    presenter =
        MyOrdersPresenter(context: Get.context, orderDetailsCallBack: this);
    presenter.getOrderDetailsData(orderID);
    Helpers.getUserData().then((value) {
      currentUser.value = value;
    });
    totalShippingCost.value = 0.0;
    orderTotal.value = 0.0;
    getRefundReasons();
  }

  fetchTotals() {
    for (var singleItem in currentOrder.value.orderDetails) {
      orderTotal.value += (singleItem.price * singleItem.quantity);
      totalShippingCost.value += singleItem.shippingCost;
    }
  }

  cancelOrder() {
    Get.defaultDialog(
        title: "${translator.translate("alert")}",
        content: Text("${translator.translate("cancel_order")}"),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Get.back();
              },
              child: Text(
                "${translator.translate("back")}",
                style: TextStyle(color: Colors.black),
              )),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor)),
              onPressed: () {
                presenter.makeCancel(currentOrder.value.id.toString());
                Get.back();
              },
              child: Text("${translator.translate("confirm")}")),
        ]);
  }

  getRefundReasons() {
    Helpers.getUserData().then((user) {
      // var url = Constants.BASE_URL + 'getUserOrders?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'getRefundResons';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
              context: Get.context,
              call: http.get(Uri.parse(url), headers: headers),
              onResponse: (response) {
                refundReasonList.clear();
                for (var item in response['data']) {
                  RefundReason _reason = RefundReason.fromJson(item);
                  refundReasonList.add(_reason);
                }
                // if (data.success) {
                // } else {
                // }
              },
              onFailure: (error) {},
              onLoading: (show) {})
          .makeRequest();
    });
  }

  refundOrder(String refundedItemID) {
    Get.defaultDialog(
        title: "${translator.translate("alert")}",
        content: Column(
          children: [
            Text("${translator.translate("refund_order")}"),
            TextField(
              controller: refundDetailsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "${translator.translate("refund_reason_details")}",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: refuntReasonController,
              decoration: InputDecoration(
                hintText: "${translator.translate("pick_refund_reason")}",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              readOnly: true,
              onTap: () {
                Get.bottomSheet(
                    Container(
                      child: Wrap(
                          children: refundReasonList.map((element) {
                        return ListTile(
                            title: Text('${element.reason}'),
                            onTap: () {
                              chossenRefundReason.value = element;
                              refuntReasonController.text = element.reason;
                              Get.back();
                            });
                      }).toList()),
                    ),
                    backgroundColor: Colors.white);
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Get.back();
              },
              child: Text(
                "${translator.translate("back")}",
                style: TextStyle(color: Colors.black),
              )),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor)),
              onPressed: () {
                presenter.makeRefund(refundedItemID,
                    refundDetailsController.text, chossenRefundReason.value.id);
                Get.back();
              },
              child: Text("${translator.translate("confirm")}")),
        ]);
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: Get.context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading.value = show;
  }

  @override
  void onDataSuccess(OrderDetailsData data) {
    currentOrder.value = data;
    print(currentOrder.value.shippingAddress);
    fetchTotals();
  }

  @override
  void onRefundSuccess(bool result, String message) {
    Get.snackbar('${translator.translate("success")}', '${message}',
        colorText: Colors.white,
        backgroundColor: primaryColor,
        duration: Duration(seconds: 3));
  }

  @override
  void onReviewSuccess(bool result, String message) {
    // TODO: implement onReviewSuccess
  }
}
