import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/services/favorite_list_controller.dart';
import 'package:my_medical_app/shopHop/models/ShCategory.dart';
import 'package:my_medical_app/shopHop/models/ShProduct.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/theme10/models/T10Models.dart';
import 'package:my_medical_app/theme10/utils/T10Colors.dart';
import 'package:my_medical_app/theme4/models/T4Models.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class FavoriteScreen extends StatefulWidget {
  static String tag = '/FavoriteScreen';

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  var list = List<ShCategory>();
  var banners = List<String>();
  var newestProducts = List<ShProduct>();
  var featuredProducts = List<ShProduct>();
  var position = 0;
  var colors = [sh_cat_1, sh_cat_2, sh_cat_3, sh_cat_4, sh_cat_5];
  List<T4NewsModel> mHorizontalListings;
  List<T10Product> mList;

  final FavoriteListController c = Get.put(FavoriteListController());

  @override
  void initState() {
    super.initState();
    c.checkLogin();
  }

//MM-48 Exit app function
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${translator.translate("exit_app")}'),
            content: Text("${translator.translate('do_you_want_to_exit')}"),
            actions: [
              MaterialButton(
                  onPressed: () => Get.back(),
                  //MM-47 Change button color
                  child: Text(
                    '${translator.translate("no")}',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor),
              MaterialButton(
                  onPressed: () => SystemNavigator.pop(),
                  //return true when click on "Yes"
                  //MM-47 Change button color
                  child: Text(
                    '${translator.translate("yes")}',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;

    return Obx(
      () => WillPopScope(
        //MM-48 Calls exit popup when user press back button
        onWillPop: showExitPopup, //call function on back button press
        child: Scaffold(
            body: !c.isLogged.value
                ? T3SignIn()
                : c.noProducts.value
                    ? Center(child: Text("No Products"))
                    : SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Obx(
                              () => Column(
                                children: c.productsList.map((e) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        Product productInstance = Product(
                                            e.id,
                                            e.product.name,
                                            null,
                                            e.product.thumbnailImage,
                                            double.parse(
                                                e.product.basePrice.toString()),
                                            double.parse(e
                                                .product.baseDiscountedPrice
                                                .toString()),
                                            null,
                                            null,
                                            e.product.unit,
                                            null,
                                            null,
                                            0,
                                            null,
                                            e.product.rating,
                                            null,
                                            null,
                                            e.product.links.details,
                                            e.product.links.reviews,
                                            e.product.links.related,
                                            e.product.links.topFromSeller,
                                            e.product.country,
                                            e.product.isFavorite);
                                        return ShProductDetail(
                                          is_ad: false,
                                          product: productInstance,
                                          productID: productInstance.id,
                                        );
                                      }));
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: spacing_standard_new,
                                            right: spacing_standard_new,
                                            bottom: spacing_standard_new),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                spacing_middle)),
                                                        child: e.product
                                                                    .thumbnailImage ==
                                                                null
                                                            ? Image.asset(
                                                                "assets/images/default_image_product.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                                height:
                                                                    width * 0.4,
                                                              )
                                                            : Image.network(
                                                                Constants
                                                                        .IMAGE_BASE_URL +
                                                                    e.product
                                                                        .thumbnailImage,
                                                                fit: BoxFit
                                                                    .cover,
                                                                height:
                                                                    width * 0.4,
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: spacing_standard_new,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6,
                                                            child: Text(
                                                              e.product.name,
                                                              style: TextStyle(
                                                                  color: appStore
                                                                      .textPrimaryColor,
                                                                  fontFamily:
                                                                      fontMedium,
                                                                  fontSize: 22),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // textColor: appStore.textPrimaryColor,
                                                              // fontFamily: fontMedium
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      // text(model.discount_type,
                                                      //     textColor: appStore.textSecondaryColor),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              e.product.basePrice ==
                                                                      e.product
                                                                          .baseDiscountedPrice
                                                                  ? Text(
                                                                      "${e.product.basePrice} ${translator.translate("egp")}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    )
                                                                  : Text(
                                                                      "${e.product.basePrice} ",
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                              SizedBox(
                                                                width: 30,
                                                              ),
                                                              e.product.basePrice !=
                                                                      e.product
                                                                          .baseDiscountedPrice
                                                                  ? Text(
                                                                      "${e.product.baseDiscountedPrice}  ${translator.translate("egp")}",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18),
                                                                    )
                                                                  : Container()
/*
                                      SizedBox(width: spacing_control),
                                      text(model.base_price.toString(),
                                          textColor: appStore.textSecondaryColor,
                                          lineThrough: true),
*/
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                c.isLoadingData.value
                                                    ? SpinKitChasingDots(
                                                        color: primaryColor,
                                                        size: 10,
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          c.removeFromWishList(e
                                                              .product.id
                                                              .toString());
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                              ],
                                            ),
                                            SizedBox(
                                                height: spacing_standard_new),
                                            Divider(
                                                color: t10_view_color,
                                                height: 0.5)
                                          ],
                                        )),
                                  );
                                }).toList(),
                              ),
                            )))),
      ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }
}

class ProductList extends StatelessWidget {
  T10Product model;

  ProductList(T10Product model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.only(
            left: spacing_standard_new,
            right: spacing_standard_new,
            bottom: spacing_standard_new),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(spacing_middle)),
                    child: CachedNetworkImage(
                      placeholder: placeholderWidgetFn(),
                      imageUrl: model.img,
                      fit: BoxFit.cover,
                      height: width * 0.2,
                    ),
                  ),
                ),
                SizedBox(
                  width: spacing_standard_new,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          text(model.name,
                              textColor: appStore.textPrimaryColor,
                              fontFamily: fontMedium),
                        ],
                      ),
                      text(model.category,
                          textColor: appStore.textSecondaryColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              text(model.price,
                                  textColor: appStore.textSecondaryColor),
                              SizedBox(width: spacing_control),
                              text(model.subPrice,
                                  textColor: appStore.textSecondaryColor,
                                  lineThrough: true),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: spacing_standard_new),
            Divider(color: t10_view_color, height: 0.5)
          ],
        ));
  }
}
