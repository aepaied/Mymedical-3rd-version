import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/cartModel.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/CartItemWidget.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> implements CartCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoadingData = false;
  bool noProducts = true;
  bool isLogged = false;
  User user;

  List<CartData> productsList = List();
  CartPresenter presenter;

  double subTotal = 0;
  double tax = 0;

  @override
  void initState() {
    // TODO: implement initState
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon:
              new Icon(Icons.keyboard_return, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          translator.translate('cart'),
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: user.isLoggedIn
            ? <Widget>[
                Container(
                    width: 30,
                    height: 30,
                    margin: Constants.LANG == "en"
                        ? EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20)
                        : EdgeInsets.only(top: 12.5, bottom: 12.5, left: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(300),
                      onTap: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 1);
                      },
                      child: CircleAvatar(
                        backgroundImage: user.avatar == null
                            ? AssetImage('assets/images/user.png')
                            // : NetworkImage(Constants.IMAGE_BASE_URL + user.avatar),
                            : NetworkImage(user.avatar),
                      ),
                    )),
              ]
            : <Widget>[],
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 150),
            padding: EdgeInsets.only(bottom: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        translator.translate('shopping_cart'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        translator
                            .translate('click_checkout'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  isLoadingData
                      ? /*Container(
                          margin: EdgeInsets.only(top: SizeConfig.vUnit * 15),
                          child: ProgressWidget(
                            width: SizeConfig.wUnit * 30,
                            height: SizeConfig.wUnit * 30,
                          ),
                        )*/
                      SpinKitChasingDots(
                        color: primaryColor,
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: productsList.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              item: productsList.elementAt(index),
                              reloadList: () {
                                presenter.getCartData();
                              },
                            );
                          },
                        ),
                  /*Expanded(child:  SizedBox(width: 10,))*/
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 170,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        offset: Offset(0, -2),
                        blurRadius: 5.0)
                  ]),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            translator.translate('subtotal'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Text(subTotal.toString(),
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    ),
                    SizedBox(height: 10),
                    Stack(
                      fit: StackFit.loose,
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: FlatButton(
                            onPressed: () {
                              if (productsList.length > 0) {
                                Navigator.of(context).pushNamed('/Checkout');
                              }
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            child: Text(
                              translator
                                  .translate('checkout'),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "" /*(subTotal + tax).toString()*/,
                            style: Theme.of(context).textTheme.headline4.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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

      subTotal = 0;
      tax = 0;

      for (CartData c in data) {
        subTotal += (c.price * c.quantity);
        tax += c.tax;
      }
    });
  }
}
