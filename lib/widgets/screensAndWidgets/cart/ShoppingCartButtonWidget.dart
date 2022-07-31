import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTCartScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/cart/cartListener.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/CartCounter.dart';
import 'package:provider/provider.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  // ShoppingCartButtonWidget();

  @override
  State<StatefulWidget> createState() {
    return ShoppingCartButtonWidgetState();
  }
}

class ShoppingCartButtonWidgetState extends State<ShoppingCartButtonWidget>
    implements CartCallBack /*, UpdateCartBadge*/ {
  static CartPresenter presenter;

  static reloadCart() {
    if (presenter != null) {
      presenter.getCartData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    if (presenter == null) {
      presenter = CartPresenter(context: context, callBack: this);
    }
    presenter.getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (Constants.CART_COUNT > 0 ){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return DTCartScreen();
          }));
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).hintColor,
              size: 28,
            ),
          ),
          Constants.CART_COUNT == 0 ?Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(
                minWidth:20, maxWidth: 20, minHeight: 20, maxHeight: 20),

          ):Container(
            /*child: Text(
              Constants.CART_COUNT.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.merge(
                    TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 9),
                  ),
            ),*/


            child: Text(
                  Constants.CART_COUNT.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption.merge(
                    TextStyle(
                        color: Colors.white, fontSize: 14),
                  ),
                ),






            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(
                minWidth:20, maxWidth: 20, minHeight: 20, maxHeight: 20),
          ),
        ],
      ),
    );
  }

  @override
  void onCartDataError(String message) {
    /* showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(
          context: context,
          content: message,
        ));*/
  }

  @override
  void onCartDataLoading(bool show) {
/*    setState(() {
      isLoadingData = show;
    });*/
  }

  @override
  void onCartDataSuccess(List<CartData> data) {
    if (this.mounted) {
      setState(() {
        Constants.CART_COUNT = data.length;

        // Provider.of<CartCounter>(context).setCount(data.length);
      });
    } else {
      try {
        super.initState();
      } catch (ex) {
        print('Error =======> '+ex.toString());

      }
    }
  }

/*  @override
  void onIncreaseBadge() {
    setState(() {
      Constants.CART_COUNT++;
    });
  }*/

/* static void onIncreaseBadge(BuildContext context) async {
    ShoppingCartButtonWidgetState state = context.ancestorStateOfType(TypeMatcher<ShoppingCartButtonWidgetState>());
    state.setState(() {
      Constants.CART_COUNT++;
    });

  }*/
}
