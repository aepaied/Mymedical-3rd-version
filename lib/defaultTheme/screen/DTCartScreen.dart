import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/sub_total_controller.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/defaultTheme/utils/DTDataProvider.dart';
import 'package:my_medical_app/main/utils/AppColors.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';

import 'CartListView.dart';
import 'DTDrawerWidget.dart';
import 'DTOrderSummaryScreen.dart';

class DTCartScreen extends StatefulWidget {
  static String tag = '/DTCartScreen';

  @override
  DTCartScreenState createState() => DTCartScreenState();
}

class DTCartScreenState extends State<DTCartScreen> implements CartCallBack {
  bool isLoadingData = false;
  bool noProducts = true;
  bool isLogged = false;
  User user;

  List<CartData> productsList = List();
  CartPresenter presenter;

  double tax = 0;
  final SubTotalController _subTotalController = Get.put(SubTotalController());
  @override
  void initState() {
    super.initState();

    if (presenter == null) {
      presenter = CartPresenter(context: context, callBack: this);
      presenter.getCartData();
    }

    Helpers.getUserData().then((_user) {
      setState(() {
        isLogged = _user.isLoggedIn;
        user = _user;
      });
    });
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget checkOutBtn() {
      return T3AppButton(
        onPressed: () {
          DTOrderSummaryScreen(
            subTotal: _subTotalController.subTotal.value,
            tax: tax,
          ).launch(context);
        },
        textContent: "${translator.translate("check_out")}",
      );
    }

    Widget mobileWidget() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CartListView(),
            Center(
                child: Constants.CART_COUNT == 0
                    ? Column(
                        children: [
                          Text("${translator.translate("no_products_found")}"),
                          SizedBox(
                            height: 50,
                          ),
                          T3AppButton(
                              textContent:
                                  "${translator.translate("continue_shopping")}",
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return ShHomeScreen();
                                }));
                              })
                        ],
                      )
                    : checkOutBtn()),
          ],
        ),
      );
    }

    Widget webWidget() {
      return CartListView();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: '${translator.translate("cart")}',
        isHome: false,
      ),
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
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
        print(c.price);
        _subTotalController.addToSubTotal(c.price * c.quantity);
        // subTotal += (c.price * c.quantity);
        tax += c.tax;
      }
    });
  }
}
