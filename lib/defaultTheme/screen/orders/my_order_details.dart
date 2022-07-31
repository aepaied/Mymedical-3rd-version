import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/my_order_contraoller.dart';
import 'package:my_medical_app/data/remote/models/orderDetailsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/checkout/fawryScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_orders_presenter.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/tarck_order.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/DTWidgets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

class MyOrderDetails extends StatefulWidget {
  final String orderID;

  MyOrderDetails({Key key, @required this.orderID}) : super(key: key);

  @override
  _MyOrderDetailsState createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  MyOrderController _myOrderController = Get.put(MyOrderController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _myOrderController.init(widget.orderID);
    return Scaffold(
        appBar: CustomAppBar(
            title: "${translator.translate("order_details")}", isHome: false),
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${translator.translate("order_details")}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.supervised_user_circle,
                          color: primaryColor,
                          size: 50,
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${translator.translate("order_number")}: ${_myOrderController.currentOrder.value.code}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "${translator.translate("client")}: ${_myOrderController.currentUser.value.name}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "${translator.translate("email")}: ${_myOrderController.currentUser.value.email}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("shipping_details")}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.home,
                          color: primaryColor,
                          size: 50,
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${translator.translate("shipping_address")}: ${_myOrderController.currentOrder.value.shippingAddress.address}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "${translator.translate("city")}: ${_myOrderController.currentOrder.value.shippingAddress.city}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "${translator.translate("region")}: ${_myOrderController.currentOrder.value.shippingAddress.region}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => TrackOrder());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${translator.translate("track_order")}",
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () {
                        SearchFilter sortBy = SearchFilter(
                            key: "new_arrival",
                            value: translator.translate('new_arrival'));

                        Get.to(() => ProductsScreen(
                              search: false,
                              widgetSortByFilter: sortBy,
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${translator.translate("buy_again")}",
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("payment_details")}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          color: primaryColor,
                          size: 50,
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${translator.translate("date")}: ${_myOrderController.currentOrder.value.date}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "${translator.translate("total")}: ${_myOrderController.orderTotal}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  _myOrderController
                                              .currentOrder.value.isCancled ==
                                          1
                                      ? Text(
                                          "${translator.translate("canceled")}",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "${translator.translate("payment_status")}: ${_myOrderController.currentOrder.value.paymentStatus}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: _myOrderController
                                                          .currentOrder
                                                          .value
                                                          .paymentStatus ==
                                                      "paid"
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                  _myOrderController
                                              .currentOrder.value.isCancled ==
                                          1
                                      ? Container()
                                      : _myOrderController.currentOrder.value
                                                  .paymentStatus ==
                                              "paid"
                                          ? Text(
                                              "${translator.translate("payment_method")}: ${translator.translate(_myOrderController.currentOrder.value.paymentType)}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    child: Text(
                                                        "${translator.translate("pay_with_paysky")}"),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    primaryColor)),
                                                    onPressed: () {
                                                      String url =
                                                          "https://mymedicalshope.com/pay_with_paysky/" +
                                                              _myOrderController
                                                                  .currentOrder
                                                                  .value
                                                                  .id
                                                                  .toString() +
                                                              "/" +
                                                              (_myOrderController
                                                                      .currentOrder
                                                                      .value
                                                                      .grandTotal)
                                                                  .toString();
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                        return FawryScreen(
                                                          url: url,
                                                        );
                                                      }));
                                                    }),
                                                ElevatedButton(
                                                    child: Text(
                                                        "${translator.translate("pay_with_fawry")}"),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    primaryColor)),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                        String url =
                                                            "https://mymedicalshope.com/pay_with_fawry/" +
                                                                Constants.LANG +
                                                                "/" +
                                                                // widget.order_id +
                                                                _myOrderController
                                                                    .currentOrder
                                                                    .value
                                                                    .id
                                                                    .toString() +
                                                                "/" +
                                                                (_myOrderController.currentOrder.value.grandTotal)
                                                                    .toString() +
                                                                "/" +
                                                                _myOrderController
                                                                    .currentUser
                                                                    .value
                                                                    .name +
                                                                "/" +
                                                                _myOrderController
                                                                    .currentOrder
                                                                    .value
                                                                    .shippingAddress
                                                                    .address +
                                                                "/" +
                                                                _myOrderController
                                                                    .currentUser
                                                                    .value
                                                                    .email +
                                                                "/" +
                                                                _myOrderController
                                                                    .currentUser
                                                                    .value
                                                                    .id;
                                                        return FawryScreen(
                                                          url: url,
                                                        );
                                                      }));
                                                    }),
                                              ],
                                            ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: _myOrderController
                          .currentOrder.value.orderDetails
                          .map((singleItem) {
                        print(singleItem.product.name);
                        double totalItemPrice =
                            double.parse(singleItem.price.toString()) *
                                singleItem.quantity;

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.93,
                          decoration: boxDecorationRoundedWithShadow(8,
                              backgroundColor: Colors.white),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _myOrderController
                                              .currentOrder.value.isCancled ==
                                          1
                                      ? Text(
                                          "${translator.translate("canceled")}",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "${singleItem.deliveryStatus}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  singleItem.deliveryStatus ==
                                                          "delivered"
                                                      ? Colors.green
                                                      : Colors.red),
                                        ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      "${Constants.IMAGE_BASE_URL}${singleItem.product.thumbnailImg}",
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ).cornerRadiusWithClipRRect(8),
                                  ),
                                  12.width,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(singleItem.product.name,
                                          style: primaryTextStyle(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      4.height,
                                      Row(
                                        children: [
                                          priceWidget(double.parse(
                                              singleItem.price.toString())),
                                          8.width,
                                        ],
                                      ),
                                      8.height,
                                      Row(
                                        children: [
                                          Container(
                                            decoration:
                                                boxDecorationWithRoundedCorners(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              backgroundColor: primaryColor,
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              "X ${singleItem.quantity}  = $totalItemPrice",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).expand(),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${translator.translate("shipping_cost")} :  ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${singleItem.shippingCost}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Spacer(),
                                  singleItem.deliveryStatus != "delivered"
                                      ? MaterialButton(
                                          color: primaryColor,
                                          onPressed: () =>
                                              _myOrderController.refundOrder(
                                                  singleItem.id.toString()),
                                          splashColor: Colors.blueGrey,
                                          child: Text(
                                            "${translator.translate("refund")}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("summary")}",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("sub_total")} : ${_myOrderController.orderTotal.value}",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("coupon_discount")} : ${_myOrderController.currentOrder.value.couponDiscount}",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("shipping_cost")} : ${_myOrderController.totalShippingCost.value}",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${translator.translate("total")} : ${(_myOrderController.orderTotal.value + _myOrderController.totalShippingCost.value) - _myOrderController.currentOrder.value.couponDiscount}",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    _myOrderController.currentOrder.value.isCancled == 1
                        ? Text(
                            "${translator.translate("canceled")}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        : Column(
                            children: [
                              _myOrderController.currentOrder.value
                                              .delivery_status !=
                                          "on_delivery" ||
                                      _myOrderController.currentOrder.value
                                              .delivery_status !=
                                          "delivered"
                                  ? T3AppButton(
                                      onPressed: () {
                                        _myOrderController.cancelOrder();
                                      },
                                      textContent:
                                          "${translator.translate("cancel_order")}",
                                    )
                                  : Container(),
                            ],
                          ),
                  ]),
            ),
          ),
        ));
  }
}
