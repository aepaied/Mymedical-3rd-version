import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/myOrdersModel.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_order_details.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_orders_presenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    implements MyOrdersCallBack {
  MyOrdersPresenter presenter;
  bool isLoading = false;
  List<MyOrdersData> myOrdersList = [];
  @override
  void initState() {
    if (presenter == null) {
      presenter = MyOrdersPresenter(context: context, callBack: this);
      presenter.getMyOrdersData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${translator.translate("my_orders")}",
        isHome: false,
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : myOrdersList.length == 0
              ? Center(
                  child: Text("${translator.translate("no_orders_found")}"),
                )
              : ListView(
                  children: myOrdersList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return MyOrderDetails(
                              orderID: e.id.toString(),
                            );
                          }));
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              "${translator.translate("order_number")}"),
                                          Text("${e.code}")
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              "${translator.translate("date")}"),
                                          Text("${e.date}")
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              "${translator.translate("payment_type")}"),
                                          Image.asset(
                                            e.paymentType == "fawry"
                                                ? "assets/images/fawry_logo.png"
                                                : e.paymentType ==
                                                        "cash_on_delivery"
                                                    ? "assets/images/cash_on_delivery.png"
                                                    : e.paymentType == "wallet"
                                                        ? "assets/icons/ic_mywallet.png"
                                                        : "assets/images/visa_master_logo.png",
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                              "${translator.translate(e.paymentType)}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${translator.translate("total")} : ${e.grandTotal}",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      e.isCanceled == 1
                                          ? Text(
                                              "${translator.translate("canceled")}",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onDataSuccess(List<MyOrdersData> data) {
    myOrdersList = data;
    setState(() {});
  }
}
