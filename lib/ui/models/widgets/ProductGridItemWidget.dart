import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_medical_app/utils/ui_icons.dart';
import 'package:my_medical_app/data/remote/models/homeCategoriesModel.dart';
import 'package:my_medical_app/ui/models/category.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class ProductGridItemWidget extends StatefulWidget {
  ProductGridItemWidget(
      {Key key, @required this.product, this.wishListId, this.reloadWishList
      // @required this.heroTag,
      })
      : super(key: key);

  final Product product;
  int wishListId;
  Function reloadWishList;

  @override
  State<StatefulWidget> createState() {
    return ProductGridItemWidgetState();
  }
}

class ProductGridItemWidgetState extends State<ProductGridItemWidget>
    implements AddWishListCallBack {
  WishListPresenter presenter;
  bool isLoadingData = false;

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
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Theme.of(context).accentColor.withOpacity(0.08),
        onTap: () {
          Navigator.of(context)
              .pushNamed('/ProductDetails', arguments: widget.product);
        },
        child: Stack(
          alignment: Alignment(1, -1),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.10),
                      offset: Offset(0, 4),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 160,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: widget.product.thumbnail_image == null
                            ? AssetImage('assets/images/logo.png')
                            : NetworkImage(Constants.IMAGE_BASE_URL +
                                widget.product.thumbnail_image),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Center(
                    // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      widget.product.base_discounted_price.toString() +
                          " " +
                          'le',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Visibility(
                    visible: widget.product.base_price >
                            widget.product.base_discounted_price
                        ? true
                        : false,
                    child: Center(
                      // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text(
                        widget.product.base_price.toString(),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Visibility(
                    visible: widget.product.base_price >
                            widget.product.base_discounted_price
                        ? true
                        : false,
                    child: Container(
                      width: 160,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                      ),
                      child: Text(
                        widget.product.discount.toString() +
                            " " +
                            'Discount',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
                visible: widget.wishListId !=null,
                child: GestureDetector(
                onTap: () {
                  presenter.removeToWishList(widget.wishListId.toString(),true);
                },
                child: isLoadingData
                    ? CircularProgressIndicator()
                    : Container(
                  padding: EdgeInsets.all(SizeConfig.wUnit * 2),
                  child: SvgPicture.asset("assets/icons/ic_remove2.svg",
                      semanticsLabel: "arrow_right",
                      color: Colors.grey,
                      width: SizeConfig.wUnit * 10,
                      height: SizeConfig.wUnit * 10),
                )))
          ],
        ));
  }

  @override
  void onAddWishListDataError(String message) {
    Fluttertoast.showToast(msg: message);
/*
    showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(
              context: context,
              content: message,
            ));
*/
  }

  @override
  void onAddWishListDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onAddWishListDataSuccess(String message,int theID,bool isRemove) {
    Fluttertoast.showToast(msg: message);
/*
    showDialog(
        context: context,
        builder: (BuildContext context) => InfoDialog(
              context: context,
              content: message,
            )).then((value) => widget.reloadWishList());
*/
  }
}
