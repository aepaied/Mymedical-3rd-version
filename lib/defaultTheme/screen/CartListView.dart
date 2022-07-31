import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/cart_controller.dart';
import 'package:my_medical_app/controllers/sub_total_controller.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/defaultTheme/model/DTProductModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTCartScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/DTDataProvider.dart';
import 'package:my_medical_app/defaultTheme/utils/DTWidgets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppColors.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class CartListView extends StatefulWidget {
  // double subTotal;

  // CartListView({Key key, @required this.productsList})
  //     : super(key: key);

  @override
  CartListViewState createState() => CartListViewState();
}

class CartListViewState extends State<CartListView>
    implements QuantityCartCallBack, CartCallBack, DeleteCartCallBack {
  List<DTProductModel> data = getCartProducts();

  double tax = 0;
  List<CartData> productsList = List();

  double totalAmount = 0;
  double shippingCharges = 0;
  double mainCount = 0;

  CartPresenter presenter;

  bool noProducts = false;
  bool isLoading = false;
  final SubTotalController _subTotalController = Get.put(SubTotalController());

  @override
  void initState() {
    if (presenter == null) {
      presenter = CartPresenter(
          context: context,
          quantityCartCallBack: this,
          callBack: this,
          deleteCartCallBack: this);
      presenter.getCartData();
    }
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCart(DTProductModel data, int index) {
      return isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Obx(
              () => Container(
                decoration: boxDecorationRoundedWithShadow(8,
                    backgroundColor: appStore.appBarColor),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        "${Constants.IMAGE_BASE_URL}${data.image}",
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
                        Text(data.name,
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Row(
                          children: [
                            priceWidget(
                                double.parse(data.discountPrice.toString()),
                                applyStrike: true),
                            8.width,
                          ],
                        ),
                        8.height,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: appColorPrimaryDark,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.remove, color: whiteColor)
                                  .onTap(() {}),
                              6.width,
                              Text(data.qty.toString(),
                                  style: boldTextStyle(color: whiteColor)),
                              6.width,
                              Icon(Icons.add, color: whiteColor).onTap(() {}),
                            ],
                          ),
                        ),
                      ],
                    ).expand(),
                  ],
                ),
              ),
            );
    }

    Widget cartItemList() {
      return Column(
        children: productsList.map((e) {
          double totalItemPrice = e.price * e.quantity;
          return Container(
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
                    "${Constants.IMAGE_BASE_URL}${e.product.image}",
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
                    Text(e.product.name,
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        priceWidget(totalItemPrice),
                        8.width,
                      ],
                    ),
                    8.height,
                    Row(
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: primaryColor,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.remove, color: whiteColor).onTap(() {
                                if (e.quantity > 1) {
                                  double newQuantity = e.quantity - 1;
                                  presenter.changeQuantityCart(e.id.toString(),
                                      newQuantity.toString(), false);
                                }
                              }),
                              6.width,
                              Text(e.quantity.toString(),
                                  style: boldTextStyle(color: whiteColor)),
                              6.width,
                              Icon(Icons.add, color: whiteColor).onTap(() {
                                double newQuantity = e.quantity + 1;
                                presenter.changeQuantityCart(e.id.toString(),
                                    newQuantity.toString(), true);
                              }),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              presenter.removeFromCart(e.id.toString());
                            },
                            child: Icon(Icons.delete))
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        }).toList(),
      );
    }

    return ContainerX(
      mobile: Column(
        children: [
          totalItemCountWidget(productsList.length),
          SingleChildScrollView(child: cartItemList()),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${translator.translate("sub_total")}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${_subTotalController.subTotal.value}",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${translator.translate("tax")}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${tax}",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
      web: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(child: cartItemList()),
          ).expand(flex: 60),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(8),
            decoration: boxDecoration(
                showShadow: true, bgColor: appStore.scaffoldBackground),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                totalAmountWidget(_subTotalController.subTotal.value),
                Row(
                  children: [Text("${translator.translate("tax")}")],
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  decoration: boxDecorationRoundedWithShadow(8,
                      backgroundColor: appColorPrimary),
                  child: Text('Checkout', style: boldTextStyle(color: white)),
                ).onTap(() {}),
              ],
            ),
          ).expand(flex: 40),
        ],
      ),
    );
  }

  @override
  void onChangeQuantityError(String message) {
    // TODO: implement onChangeQuantityError
  }

  @override
  void onChangeQuantityLoading(bool show) {
    // TODO: implement onChangeQuantityLoading
  }

  @override
  void onChangeQuantitySuccess(String theID, double quantity, bool increment) {
    _subTotalController.resetSubTotal();
    for (CartData item in productsList) {
      if (item.id == int.parse(theID)) {
        item.quantity = quantity;
      }
      _subTotalController.addToSubTotal(item.price * item.quantity);
    }
    setState(() {});
  }

  @override
  void onCartDataError(String message) {
    // TODO: implement onCartDataError
  }

  @override
  void onCartDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onCartDataSuccess(List<CartData> data) {
    setState(() {
      if (data.length == 0) {
        noProducts = true;
      } else {
        noProducts = false;
      }

      Constants.CART_COUNT = data.length;

      productsList.clear();
      productsList.addAll(data);
      _subTotalController.resetSubTotal();
      tax = 0;

      for (CartData c in data) {
        _subTotalController.addToSubTotal(c.price * c.quantity);
        tax += (c.tax * c.quantity);
      }
    });
  }

  @override
  void onDeleteCartError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDeleteCartLoading(bool show) {
    // TODO: implement onDeleteCartLoading
  }

  @override
  void onDeleteCartSuccess(String message) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return DTCartScreen();
    }));
  }
}
