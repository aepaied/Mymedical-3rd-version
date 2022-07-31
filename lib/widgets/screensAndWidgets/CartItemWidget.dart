import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

import 'package:provider/provider.dart';
import 'package:my_medical_app/utils/CartCounter.dart';
import 'package:flutter/material.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/cart/ShoppingCartButtonWidget.dart';
import 'package:my_medical_app/utils/constants.dart';

class CartItemWidget extends StatefulWidget {
  CartData item;
  Function reloadList;

  CartItemWidget({Key key, this.item, this.reloadList}) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget>
    implements QuantityCartCallBack, DeleteCartCallBack {
  bool loadingRemove = false;
  bool loadingQty = false;

  CartPresenter presenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (presenter == null) {
      presenter = CartPresenter(
          context: context,
          quantityCartCallBack: this,
          deleteCartCallBack: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        // Navigator.of(context).pushNamed('/Product',
        //     arguments: RouteArgument(id: widget.product.id, argumentsList: [widget.product, widget.heroTag]));
      },
      child:
    );*/
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: widget.item.product.image == null
                            ? AssetImage('assets/images/logo.png')
                            : NetworkImage(Constants.IMAGE_BASE_URL +
                                widget.item.product.image),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.item.product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              widget.item.price.toString(),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      loadingQty
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    /*  setState(() {
                                      widget.item.quantity = this
                                          .incrementQuantity(
                                              widget.item.quantity);
                                    });*/

                                    presenter.changeQuantityCart(
                                        widget.item.id.toString(),
                                        (widget.item.quantity + 1).toString(),
                                        true);
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  icon: Icon(Icons.add_circle_outline),
                                  color: Theme.of(context).hintColor,
                                ),
                                Text(widget.item.quantity.toString(),
                                    style: Theme.of(context).textTheme.subtitle1),
                                IconButton(
                                  onPressed: () {
                                    /*setState(() {
                                      widget.item.quantity = this
                                          .decrementQuantity(
                                              widget.item.quantity);
                                    });*/
                                    if (widget.item.quantity > 1) {
                                      presenter.changeQuantityCart(
                                          widget.item.id.toString(),
                                          (widget.item.quantity - 1).toString(),
                                          false);
                                    }
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  icon: Icon(Icons.remove_circle_outline),
                                  color: Theme.of(context).hintColor,
                                ),
                              ],
                            ),
                    ],
                  ),
                )
              ],
            ),
            if (loadingRemove) Center(
                    child: CircularProgressIndicator(),
                  ) else FlatButton(
                    onPressed: () {
                      presenter.removeFromCart(widget.item.id.toString());
                    },
                    child: Text(
                      translator.translate('remove'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      // style: Theme.of(context).textTheme.subtitle1,
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
          ],
        ));
  }

  incrementQuantity() {
    setState(() {
      if (widget.item.quantity <= 99) {
        return ++widget.item.quantity;
      } else {
        return widget.item.quantity;
      }
    });
  }

  decrementQuantity() {
    setState(() {
      if (widget.item.quantity > 1) {
        return --widget.item.quantity;
      } else {
        return widget.item.quantity;
      }
    });
  }

  @override
  void onChangeQuantityError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(errorText: message,
            ));
  }

  @override
  void onChangeQuantityLoading(bool show) {
    setState(() {
      loadingQty = show;
    });
  }



  @override
  void onDeleteCartError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(errorText: message,
            ));
  }

  @override
  void onDeleteCartLoading(bool show) {
    setState(() {
      loadingRemove = show;
    });
  }

  @override
  void onDeleteCartSuccess(String message) {
    ShoppingCartButtonWidgetState.reloadCart();
    widget.reloadList();
    setState(() { });
  }

  @override
  void onChangeQuantitySuccess(String theID, double quantity, bool increment) {
    // TODO: implement onChangeQuantitySuccess
  }
}
