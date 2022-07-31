import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/data/remote/models/flashDealsModel.dart';
import 'package:flutter/material.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class ProductItemWidget extends StatefulWidget {
  // String heroTag;
  double marginLeft;
  Product product;

  ProductItemWidget({
    Key key,
    // this.heroTag,
    this.marginLeft,
    this.product,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductItemWidgetState();
  }

/*  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/ProductDetails', arguments: product);
          },
          child: Container(
            // margin: EdgeInsets.only(left: this.marginLeft, right: 20),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: product.thumbnail_image == null
                          ? AssetImage('assets/images/logo.png')
                          : NetworkImage(Constants.IMAGE_BASE_URL +
                              product.thumbnail_image),
                    ),
                  ),
                ),

                */ /*Positioned(
              top: 6,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Theme.of(context).accentColor),
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  '${product.discount} %',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),*/ /*
                Container(
                  margin: EdgeInsets.only(top: 170),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  width: 160,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 2,
                        // softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: <Widget>[
                          // The title of the product
                          Expanded(
                            child: Text(
                              '${product.sales} ' +
                                  AppLocalizations.of(context)
                                      .translate('sales'),
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Text(
                            product.rating.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      Visibility(
                        visible:
                            product.base_price > product.base_discounted_price
                                ? true
                                : false,
                        child: Text(
                          product.base_price.toString(),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Text(
                        '${product.base_discounted_price} ' +
                            AppLocalizations.of(context).translate('le'),
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      */ /*SizedBox(height: 7),
                  Text(
                    '${product.sales} '+AppLocalizations.of(context).translate('available'),
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AvailableProgressBarWidget(
                      available: product.sales.toDouble())*/ /*
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: SizeConfig.vUnit * 16.5),
              padding: EdgeInsets.only(
                  top: SizeConfig.wUnit * 3,
                  bottom: SizeConfig.wUnit * 3,
                  left: SizeConfig.wUnit * 3,
                  right: SizeConfig.wUnit * 2),
              // color: OColors.colorGray,
              child: Icon(
                Icons.favorite,
                color: OColors.colorGray,
                size: 28,
              ),
            ))
      ],
    );
  }*/
}

class ProductItemWidgetState extends State<ProductItemWidget>
    implements AddWishListCallBack {
  WishListPresenter presenter;

  bool isLoadingData = false;
  bool isFavorate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (presenter == null) {
      presenter =
          WishListPresenter(context: context, addWishListCallBack: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/ProductDetails', arguments: widget.product);
          },
          child: Container(
            // margin: EdgeInsets.only(left: this.marginLeft, right: 20),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.product.thumbnail_image == null
                          ? AssetImage('assets/images/logo.png')
                          : NetworkImage(Constants.IMAGE_BASE_URL +
                              widget.product.thumbnail_image),
                    ),
                  ),
                ),

                /*Positioned(
              top: 6,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Theme.of(context).accentColor),
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  '${product.discount} %',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),*/
                Container(
                  margin: EdgeInsets.only(top: 170),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  width: 160,
                  // height: 120,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                        // softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      /*Row(
                        children: <Widget>[
                          // The title of the product
                          Expanded(
                            child: Text(
                              '${widget.product.sales} ' +
                                  AppLocalizations.of(context)
                                      .translate('sales'),
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Text(
                            widget.product.rating.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),*/
                      Visibility(
                        visible: widget.product.base_price >
                                widget.product.base_discounted_price
                            ? true
                            : false,
                        child: Text(
                          widget.product.base_price.toString(),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Text(
                        '${widget.product.base_discounted_price} ' +
                            AppLocalizations.of(context).translate('le'),
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      /*SizedBox(height: 7),
                  Text(
                    '${product.sales} '+AppLocalizations.of(context).translate('available'),
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AvailableProgressBarWidget(
                      available: product.sales.toDouble())*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              Helpers.isLoggedIn().then((_result) {
                setState(() {
                  if (_result) {
                    if (!isFavorate) {
                      presenter.addToWishList(widget.product.id.toString(),false);
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomAlertDialog(
                          errorText: AppLocalizations.of(context).translate('must_sign_in'),
                        ));
                  }
                });
              });

            },
            child: Container(
              margin: EdgeInsets.only(top: SizeConfig.vUnit * 16.5),
              padding: EdgeInsets.only(
                  top: SizeConfig.wUnit * 3,
                  bottom: SizeConfig.wUnit * 3,
                  left: SizeConfig.wUnit * 3,
                  right: SizeConfig.wUnit * 2),
              // color: OColors.colorGray,
              child: isLoadingData
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.favorite,
                      color: isFavorate ? OColors.colorRed : OColors.colorGray,
                      size: 28,
                    ),
            ))
      ],
    );
  }

  @override
  void onAddWishListDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onAddWishListDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onAddWishListDataSuccess(String message,int theID,bool isRemove) {
    setState(() {
      isFavorate = isRemove? false:true;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            ));
  }
}
