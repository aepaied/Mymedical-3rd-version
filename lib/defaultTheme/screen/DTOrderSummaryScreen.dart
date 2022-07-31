import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/rating_controller.dart';
import 'package:my_medical_app/controllers/shipping_cost_controller.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';
import 'package:my_medical_app/data/remote/models/CouponModel.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/checkout/checkoutPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/checkout/fawryScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/add_new_address.dart';
import 'package:my_medical_app/defaultTheme/utils/DTWidgets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/main/utils/rating_bar.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/models/paymentType.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/enums/blast_directionality.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/confetti.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/PaymentTypeWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/rechargeWalletDialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CartListView.dart';

class DTOrderSummaryScreen extends StatefulWidget {
  final ShippingCostController shippingCostController =
      Get.put(ShippingCostController());
  final double subTotal;
  final double tax;

  DTOrderSummaryScreen({Key key, @required this.subTotal, @required this.tax})
      : super(key: key);

  @override
  DTOrderSummaryScreenState createState() => DTOrderSummaryScreenState();
}

class DTOrderSummaryScreenState extends State<DTOrderSummaryScreen>
    implements CheckoutCallBack, CartCallBack {
  //List<DTProductModel> data = getCartProducts();

  double totalAmount = 0;
  int shippingCharges = 0;
  double mainCount = 0;

  String name = 'Austin';
  String address = '381, Shirley St. Munster, New York';
  String address2 = 'United States - 10005';

// from old
  TextEditingController couponController = new TextEditingController();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;
  bool isCouponLoading = false;
  bool isItemsData = false;

  bool hasCopuon = false;

  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerBottomCenter;

  // double discount = 0;
  double shipping = 0;
  double coupon_discount = 0;
  bool coupon_applied = false;
  String shippingDate = null;

  bool isLoadingMyAddressesData = false;
  List<MyAddressesData> myAddressesList = List();
  MyAddressesData selecttedAddresses;
  bool addressesGroup = false;

  List<PaymentType> paymentTypeList = List();
  PaymentType selecttedPaymentType;

  CheckoutPresenter presenter;
  CartPresenter cartPresenter;
  List<CartData> cartDataList = List();
  double walletBalance = 0;
  double walletBalanceOrgn = 0;
  double walletDiscount = 0;
  bool useWalletToPay = false;
  bool useWalletAsDiscount = false;

  bool showDone = false;

  unselectAllmyAddressesList() {
    for (MyAddressesData address in myAddressesList) {
      address.select = false;
    }
  }

  unselectAllpaymentTypeList() {
    useWalletToPay = false;
    for (PaymentType paymentType in paymentTypeList) {
      paymentType.selected = false;
    }
  }

  refreshValues() {
    setState(() {});
  }

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    _controllerCenter.play();
    paymentTypeList.add(PaymentType(
        name: 'paysky', logo: 'assets/images/paysky.png', selected: false));
    paymentTypeList.add(PaymentType(
        name: 'fawry', logo: 'assets/images/fawry.png', selected: false));
    paymentTypeList.add(PaymentType(
        name: 'cash_on_delivery',
        logo: 'assets/images/cash_on_delivery.png',
        selected: false));

    if (presenter == null) {
      presenter = CheckoutPresenter(context: context, callBack: this);
      cartPresenter = CartPresenter(context: context, callBack: this);
      cartPresenter.getCartData();
      presenter.getMyAdresses();
      presenter.getWalletBalance();
    }
    widget.shippingCostController.getShippingCoast(context, null);

    Helpers.getUserData().then((_user) {
      setState(() {
        isLogged = _user.isLoggedIn;
        user = _user;
      });
    });
    super.initState();
    init();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();

    super.dispose();
  }

  pickDefaultAddress() {
    for (var item in myAddressesList) {
      if (item.setDefault == 1) {
        item.select = true;
        selecttedAddresses = item;
      }
    }
    setState(() {});
  }

  init() async {
    DateTime dateTime = DateTime.now();

    // calculate();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget addressView() {
      return Container(
        child: myAddressesList.length == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(child: Text("No Address Found , Click to add")),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AddNewAddress(
                          isCheckOut: true,
                          subTotal: widget.subTotal,
                        );
                      }));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: primaryColor,
                  )
                ],
              )
            : Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("${translator.translate("choose_address")}"),
                          Spacer(),
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return AddNewAddress(
                                  //Sending is checkout to make sure that it
                                  // will return back to checkout after adding the address
                                  isCheckOut: true,
                                  subTotal: widget.subTotal,
                                );
                              }));
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            backgroundColor: primaryColor,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.1,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.4),
                        child: ListView(
                          shrinkWrap: true,
                          children: myAddressesList.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  unselectAllmyAddressesList();
                                  selecttedAddresses = e;
                                  e.select = true;
                                  widget.shippingCostController
                                      .getShippingCoast(context, e.region);
                                  setState(() {});
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: boxDecorationRoundedWithShadow(8,
                                      backgroundColor: e.select
                                          ? primaryColor
                                          : Colors.white),
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.phone,
                                            style: boldTextStyle(
                                                size: 18,
                                                color: e.select
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.wUnit * 30,
                                            child: Text("${e.addressCity.name}",
                                                style: boldTextStyle(
                                                    size: 18,
                                                    color: e.select
                                                        ? Colors.white
                                                        : Colors.black)),
                                          ),
                                          10.width,
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                              child: Text(e.address,
                                                  style: boldTextStyle(
                                                      size: 18,
                                                      color: e.select
                                                          ? Colors.white
                                                          : Colors.black))),
                                          10.width,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
      );
    }

    Widget itemTitle() {
      return Row(
        children: [
          Divider().expand(),
          10.width,
          Text('${translator.translate("payment_method")}',
                  style: boldTextStyle(), maxLines: 1)
              .center(),
          10.width,
          Divider().expand(),
        ],
      );
    }

    Widget deliveryDateAndPayBtn() {
      return Column(
        children: [
          T3AppButton(
              textContent: "${translator.translate("continue_to_pay")}",
              onPressed: () {
                if (selecttedAddresses == null) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                            errorText: "no_shipping_address",
                          ));
                } else if (selecttedPaymentType == null && !useWalletToPay) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                            errorText:
                                "${translator.translate("no_payment_type")}",
                          ));
                } else {
                  if (useWalletToPay && widget.subTotal > walletBalance) {
                    Get.snackbar("${translator.translate("error")}",
                        "${translator.translate("not_enough_wallet_balance")}",
                        backgroundColor: primaryColor, colorText: Colors.white);
                  } else {
                    presenter.makeOrder(
                        selecttedAddresses,
                        useWalletToPay ? "wallet" : selecttedPaymentType.name,
                        widget.subTotal.toString(),
                        coupon_discount.toString(),
                        couponController.text,
                        widget.shippingCostController.shippingCost.value
                            .toString(),
                        useWalletAsDiscount ? walletDiscount.toString() : "0");
                  }
                }
              })
        ],
      ).paddingAll(8);
    }

    Widget mobileWidget() {
      BusinessSettingController businessSettingController = Get.find();
      return SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addressView(),
                20.height,
                Column(
                  children: cartDataList.map((singleItem) {
                    double totalItemPrice =
                        singleItem.price * singleItem.quantity;
                    return GestureDetector(
                      onTap: () {
                        print(singleItem.id);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ShProductDetail(
                              is_ad: false, productID: singleItem.product.id);
                        }));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.93,
                        decoration: boxDecorationRoundedWithShadow(8,
                            backgroundColor: Colors.white),
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                "${Constants.IMAGE_BASE_URL}${singleItem.product.image}",
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ).cornerRadiusWithClipRRect(8),
                            ),
                            12.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(singleItem.product.name,
                                    style: primaryTextStyle(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                4.height,
                                Row(
                                  children: [
                                    priceWidget(singleItem.price),
                                    8.width,
                                  ],
                                ),
                                8.height,
                                Row(
                                  children: [
                                    Container(
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: BorderRadius.circular(4),
                                        backgroundColor: primaryColor,
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        "X ${singleItem.quantity}  = $totalItemPrice",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ).expand(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // CartListView(),
                Text(
                  "${translator.translate("sub_total")} : ${widget.subTotal}",
                  style: TextStyle(fontSize: 17),
                ),
                //  Text(
                //   "${translator.translate("tax")} : 0.00",
                //   style: TextStyle(fontSize: 17),
                // ),
                Obx(() => Text(
                      "${translator.translate("shipping_cost")} : ${widget.shippingCostController.shippingCost.value}",
                      style: TextStyle(fontSize: 17),
                    )),
                Obx(() => Text(
                      "${translator.translate("shipping_date")} : ${widget.shippingCostController.shippingDate.value}",
                      style: TextStyle(fontSize: 17),
                    )),
                coupon_applied
                    ? Text(
                        "${translator.translate("coupon_discount")} : ${coupon_applied ? coupon_discount : 00.00}",
                        style: TextStyle(fontSize: 17),
                      )
                    : Container(),
                Text(
                  "${translator.translate(useWalletAsDiscount ? "sub_total" : "total")} : ${double.parse(widget.subTotal.toString()) + double.parse(widget.shippingCostController.shippingCost.value.toString()) - double.parse(coupon_discount.toString())}",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: useWalletAsDiscount
                          ? FontWeight.normal
                          : FontWeight.bold),
                ),
                useWalletAsDiscount
                    ? Text(
                        "${translator.translate("wallet discount")} : $walletDiscount",
                        style: TextStyle(fontSize: 17),
                      )
                    : Container(),
                useWalletAsDiscount
                    ? double.parse(widget.subTotal.toString()) +
                                double.parse(widget
                                    .shippingCostController.shippingCost.value
                                    .toString()) -
                                double.parse(coupon_discount.toString()) -
                                double.parse(walletDiscount.toString()) <
                            0
                        ? Text("${translator.translate("total")} : 0",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold))
                        : Text(
                            "${translator.translate("total")} : ${double.parse(widget.subTotal.toString()) + double.parse(widget.shippingCostController.shippingCost.value.toString()) - double.parse(coupon_discount.toString()) - double.parse(walletDiscount.toString())}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )
                    : Container(),
                20.height,
                itemTitle(),
                8.height,
              ],
            ).paddingAll(8),
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(4),
              ),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Card(
                elevation: 5,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: paymentTypeList.map((e) {
                      return Container(
                        color: e.selected ? Color(0xffe8e9eb) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: PaymentTypeWidget(
                            paymentType: e,
                            value: e.selected,
                            onChanged: () {
                              setState(() {
                                unselectAllpaymentTypeList();
                                e.selected = true;
                                selecttedPaymentType = e;
                              });
                            },
                          ),
                        ),
                      );
                    }).toList()),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            businessSettingController.currentBusinessSettings.value.details
                        .where((element) => element.type == "wallet_system")
                        .toList()[0]
                        .value ==
                    "1"
                ? GestureDetector(
                    onTap: () {
                      unselectAllpaymentTypeList();
                      useWalletToPay = true;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.93,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: useWalletToPay
                                ? Color(0xffe8e9eb)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Center(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.monetization_on,
                                color: Theme.of(context).hintColor,
                                size: 60,
                              ),
                              Image(
                                width: 50,
                                height: 50,
                                fit: BoxFit.fill,
                                image:
                                    AssetImage('assets/icons/ic_mywallet.png'),
                              ),
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
                              Text(
                                walletBalance.toString() + " " + 'le',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                (((widget.subTotal + shipping) -
                                            coupon_discount) >
                                        walletBalance)
                                    ? '${translator.translate("wallet_balance_insufficient")}'
                                    : '${translator.translate("wallet_balance")}',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            RechargeWalletDialog(
                                              context: context,
                                            )).then((value) {
                                      if (value != null) {
                                        if (value != 0) {
                                          Helpers.getUserData().then((user) {
                                            var url =
                                                'https://mymedicalshope.com/recharge_wallet_with_paysky/' +
                                                    user.id +
                                                    '/' +
                                                    value;
                                            Navigator.of(context)
                                                .pushNamed('/Fawry',
                                                    arguments: url)
                                                .then((value) {
                                              presenter.getWalletBalance();
                                            });
                                          });
                                        }

                                        RechargePaymentMethod rpm = value;

                                        if (rpm.type == "paysky") {
                                          Helpers.getUserData().then((user) {
                                            var url =
                                                'https://mymedicalshope.com/recharge_wallet_with_paysky/' +
                                                    user.id +
                                                    '/' +
                                                    rpm.amount;
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return FawryScreen(
                                                url: url,
                                                title: "PaySky",
                                              );
                                            })).then((value) {
                                              presenter.getWalletBalance();
                                            });
                                          });
                                        } else if (rpm.type == "fawry") {
                                          Helpers.getUserData().then((user) {
                                            var url =
                                                'https://mymedicalshope.com/charge_wallet_with_fawry/ar/' +
                                                    user.id +
                                                    '/' +
                                                    rpm.amount;
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return FawryScreen(
                                                  url: url, title: "Fawry");
                                            })).then((value) {
                                              presenter.getWalletBalance();
                                            });
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                      "${translator.translate('recharge_wallet')}",
                                      style: TextStyle(color: Colors.white))),
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                onPressed: () {
                                  //TODO Finish this part
                                  if (useWalletAsDiscount) {
                                    walletBalance += walletDiscount;
                                    useWalletAsDiscount = false;
                                    walletDiscount = 0;
                                  } else {
                                    double diffrince = ((widget.subTotal +
                                                widget.shippingCostController
                                                    .shippingCost.value) -
                                            walletBalance) -
                                        coupon_discount;
                                    print(diffrince);
                                    if (diffrince < 0) {
                                      double newWalletBalance = diffrince.abs();
                                      double newWalletDiscount =
                                          walletBalance - newWalletBalance;
                                      walletBalance = newWalletBalance;
                                      walletDiscount = newWalletDiscount;
                                      useWalletAsDiscount = true;
                                    } else {
                                      if (diffrince > walletBalance) {
                                        walletDiscount = walletBalance;
                                        walletBalance = 0;
                                        useWalletAsDiscount = true;
                                      }
                                    }
                                  }

                                  setState(() {});
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                                color: primaryColor,
                                shape: StadiumBorder(),
                                child: Text(
                                  useWalletAsDiscount
                                      ? '${translator.translate("return_wallet_balance")}'
                                      : '${translator.translate("use_wallet_as_discount")}',
//                        textAlign: TextAlign.ce,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Divider(height: 20),
            businessSettingController.currentBusinessSettings.value.details
                        .where((element) => element.type == "coupon_system")
                        .toList()[0]
                        .value ==
                    "1"
                ? Row(
                    children: [
                      Expanded(
                          child: TextField(
                        enabled: !coupon_applied,
                        controller: couponController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText:
                                "${translator.translate("have_coupon_code")}",
                            fillColor: coupon_applied
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.white70),
                      )),
                      T3AppButton(
                        onPressed: () {
                          if (coupon_applied) {
                            coupon_discount = 00.00;
                            coupon_applied = false;
                            setState(() {});
                          } else {
                            presenter.getCouponDiscount(couponController.text);
                          }
                        },
                        textContent: coupon_applied
                            ? "${translator.translate("cancel")}"
                            : "${translator.translate("save")}",
                      )
                    ],
                  )
                : Container(),
            deliveryDateAndPayBtn(),
          ],
        ),
      );
    }

    Widget webWidget() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  16.height,
                  addressView(),
                  16.height,
                  Divider(),
                  16.height,
                  itemTitle(),
                  16.height,
                  // CartListView(mIsEditable: false, isOrderSummary: true),
                ],
              ),
            ),
          ).expand(flex: 60),
          VerticalDivider(width: 0),
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                20.height,
                CartListView(),
                totalAmountWidget(widget.subTotal),
                Divider(height: 20),
                deliveryDateAndPayBtn(),
              ],
            ),
          ).expand(flex: 40),
        ],
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: '${translator.translate("order")}', isHome: false),
      body: showDone
          ? Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                                '${translator.translate("Congratulations")} !!',
                                style: boldTextStyle(size: 30)),
                            Text('${translator.translate("order_placed")}',
                                style: boldTextStyle(size: 30)),
                            SizedBox(
                              height: 20,
                            ),
                            T3AppButton(
                              textContent: "${translator.translate("Done")}",
                              onPressed: () {
                                RatingController _ratingController =
                                    Get.put(RatingController());
                                bool shouldRate =
                                    _ratingController.checkForLastRating();
                                if (shouldRate) {
                                  Get.defaultDialog(
                                      title:
                                          "${translator.translate("rate_the_app")}",
                                      content: RatingBar(
                                        onRatingChanged: (v) {},
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star,
                                        filledColor: Colors.yellow,
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey)),
                                          onPressed: () {
                                            RatingController _ratingController =
                                                Get.put(RatingController());
                                            _ratingController.recordNewRating();
                                            ShHomeScreen().launch(context);
                                          },
                                          child: Text(
                                              "${translator.translate("later")}"),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor)),
                                          onPressed: () {
                                            if (Theme.of(context).platform ==
                                                TargetPlatform.iOS) {
                                              _ratingController
                                                  .recordNewRating();
                                              launchURL(
                                                  "https://apps.apple.com/us/app/my-medical-shop/id1541531628");
                                            } else {
                                              _ratingController
                                                  .recordNewRating();
                                              launchURL(
                                                  "https://play.google.com/store/apps/details?id=com.mymedical.mymedical");
                                            }

                                            ShHomeScreen().launch(context);
                                          },
                                          child: Text(
                                              "${translator.translate("submit")}"),
                                        ),
                                      ]);
                                } else {
                                  ShHomeScreen().launch(context);
                                }
                              },
                            ),
                          ],
                        )),
                  ],
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    //   don't specify a direction, blast randomly
                    blastDirectionality: BlastDirectionality.explosive,
                    //  start again as soon as the animation is finished
                    shouldLoop: false,
                    //  speed of the animation
                    emissionFrequency: 0.1,
                    canvas: Size.fromRadius(
                        MediaQuery.of(context).size.height * .35),
                    colors: const [
                      //  manually specify the colors to be used
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 150),
                  alignment: Alignment.bottomCenter,
                  child: ConfettiWidget(
                    confettiController: _controllerBottomCenter,
                    blastDirectionality: BlastDirectionality.explosive,
                    // don't specify a direction, blast randomly
                    shouldLoop: false,
                    //
                    emissionFrequency: 0.3,

                    canvas: Size.fromRadius(350),
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: ConfettiWidget(
                    confettiController: _controllerCenterRight,
                    blastDirectionality: BlastDirectionality.explosive,
                    // don't specify a direction, blast randomly
                    shouldLoop: false,
                    //
                    emissionFrequency: 0.2,
                    canvas: Size.fromRadius(
                        MediaQuery.of(context).size.height * .35),
                    colors: const [
                      Colors.black,
                      Colors.redAccent,
                      Colors.tealAccent,
                      Colors.yellowAccent,
                      Colors.orange
                    ], // manually specify the colors to be used
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: ConfettiWidget(
                    confettiController: _controllerCenterLeft,
                    blastDirectionality: BlastDirectionality.explosive,
                    // don't specify a direction, blast randomly
                    shouldLoop: false,
                    //
                    canvas: Size.fromRadius(
                        MediaQuery.of(context).size.height * .35),
                    emissionFrequency: 0.8,
                    colors: const [
                      Colors.deepPurple,
                      Colors.yellow,
                      Colors.blueAccent,
                      Colors.green,
                      Colors.purple
                    ], // manually specify the colors to be used
                  ),
                ),
              ],
            )
          : ContainerX(
              mobile: mobileWidget(),
              web: webWidget(),
            ),
    );
  }

  @override
  void onGetAddressesSuccess(List<MyAddressesData> data) {
    setState(() {
      myAddressesList.clear();
      myAddressesList.addAll(data);
      pickDefaultAddress();
    });
  }

  @override
  void onAddressesDataLoading(bool show) {
    setState(() {
      isLoadingMyAddressesData = show;
    });
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("$message"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                  child: Text("${translator.translate("add")}"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddNewAddress(
                        isCheckOut: true,
                        subTotal: widget.subTotal,
                      );
                    }));
                  },
                )
              ],
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onDataSuccess(String message, int orderId) {
    // Provider.of<CartCounter>(context).setCount(0);
    if (useWalletToPay) {
      selecttedPaymentType = PaymentType(name: "wallet");
      setState(() {});
    }
    if (selecttedPaymentType.name == "fawry") {
      String url = "https://mymedicalshope.com/pay_with_fawry/" +
          Constants.LANG +
          "/" +
          // widget.order_id +
          orderId.toString() +
          "/" +
          ((widget.subTotal + shipping) - coupon_discount).toString() +
          "/" +
          user.name +
          "/" +
          selecttedAddresses.phone +
          "/" +
          user.email +
          "/" +
          user.id;
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return FawryScreen(
          url: url,
        );
      }));
/*
      Navigator.of(context).pushNamed('/Fawry', arguments: url).then((value) {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      });
*/
    } else if (selecttedPaymentType.name == "paysky") {
      print(widget);
      String url = "https://mymedicalshope.com/pay_with_paysky/" +
          orderId.toString() +
          "/" +
          ((widget.subTotal + shipping) - coupon_discount).toString();
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return FawryScreen(
          url: url,
        );
      }));
/*

      Navigator.of(context).pushNamed('/Fawry', arguments: url).then((value) {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      });
*/
    } else if (selecttedPaymentType.name == "wallet") {
      Constants.CART_COUNT = 0;

      shouldShowRate();
      setState(() {});
/*
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomMessageDialog(
                errorText: message,
              )).then((value) {
        presenter.payWithWallet(orderId);
      });
*/
    } else {
      Constants.CART_COUNT = 0;
      shouldShowRate();
      setState(() {});
/*
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomMessageDialog(
                errorText: message,
              )).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ShHomeScreen();
        }));
      });
*/
    }
  }

  shouldShowRate() {
    showDone = true;
  }

  @override
  void onCartDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onCartDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onCartDataSuccess(List<CartData> data) {
    setState(() {
      Constants.CART_COUNT = data.length;
      cartDataList.clear();
      cartDataList.addAll(data);
      // loadItems();
    });
  }

  @override
  void onCouponLoading(bool show) {
    setState(() {
      isCouponLoading = show;
    });
  }

  @override
  void onCouponSuccess(String message, CouponData data) {
    if (data != null) {
      setState(() {
        coupon_discount = data.couponDiscount;
        coupon_applied = true;
        if (useWalletAsDiscount) {
          double diffrince = double.parse(widget.subTotal.toString()) +
              double.parse(
                  widget.shippingCostController.shippingCost.value.toString()) -
              (walletDiscount + double.parse(coupon_discount.toString()));
          if (diffrince < 0) {
            print(diffrince);
            walletBalance += diffrince.abs();
            walletDiscount -= diffrince.abs();
          }
        }
        // hasCopuon = true;
      });
    }

    // couponController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            ));
  }

  @override
  void onCouponError(String message) {
    couponController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onShippingCostSuccess(String shippingDate, double shippingCost) {
    setState(() {
      this.shippingDate = shippingDate;
      this.shipping = shippingCost;

      if (((widget.subTotal + shipping) - coupon_discount) >
          walletBalanceOrgn) {
        if (selecttedPaymentType != null) {
          if (selecttedPaymentType.name == "wallet") {
            unselectAllpaymentTypeList();
          }
        }
      }
    });
  }

  @override
  void onWalletBalanceSuccess(double balance) {
    setState(() {
      this.walletBalance = balance;
      this.walletBalanceOrgn = balance;

      useWalletAsDiscount = false;
      walletDiscount = 0;
    });
  }

  @override
  void onPayWithWalletSuccess() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ShHomeScreen();
    }));
  }
}

void launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}
