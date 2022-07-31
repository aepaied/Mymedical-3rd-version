import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/product_options_controller.dart';
import 'package:my_medical_app/controllers/related_products_controller.dart';
import 'package:my_medical_app/controllers/reviews_controller.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTCartScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/funcs.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/main/utils/flutter_rating_bar.dart' as RB;
import 'package:my_medical_app/models/product_details.dart';
import 'package:my_medical_app/shopHop/models/ShReview.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShStrings.dart';
import 'package:my_medical_app/size_config.dart';
import 'package:my_medical_app/theme10/utils/T10Colors.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/cart/ShoppingCartButtonWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class ShProductDetail extends StatefulWidget {
  static String tag = '/ShProductDetail';
  Product product;
  bool is_ad;
  int productID;

  ShProductDetail(
      {Key key, this.product, @required this.is_ad, @required this.productID})
      : super(key: key);

  @override
  ShProductDetailState createState() => ShProductDetailState();
}

class ShProductDetailState extends State<ShProductDetail>
    implements AddCartCallBack, ProductDetailsCallBack {
  var position = 0;
  bool isExpanded = false;
  var selectedColor = -1;
  var selectedSize = -1;
  double fiveStar = 0;
  double fourStar = 0;
  double threeStar = 0;
  double twoStar = 0;
  double oneStar = 0;
  var list = List<ShReview>();
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  String desc;
  bool noReviews = false;
  CartPresenter cartPresenter;

  bool isLoadingAddCart = false;

  AddsProductsData currentAdProduct;
  ProductsPresenter presenter;

  gettingTheData() async {
    if (presenter == null) {
      presenter = ProductsPresenter(context: context, detailsCallBack: this);
    }

    if (widget.is_ad) {
      //TODO do vars  for ads products
      presenter.getAdsProductDetails(widget.productID.toString());
    } else {
      //TODO do vars  for normal products
      _productOptionsController
          .getNormalProductData(widget.productID.toString());
    }
    _productOptionsController.isLoading.value = false;
  }

  ProductOptionsController _productOptionsController =
      Get.put(ProductOptionsController());
  ReviewController _reviewController = Get.put(ReviewController());
  RelatedProductsController relatedProductsController =
      Get.put(RelatedProductsController());
  @override
  void initState() {
    super.initState();
    _productOptionsController.isLoading.value = true;
    setState(() {});
    gettingTheData();
    if (cartPresenter == null) {
      cartPresenter = CartPresenter(context: context, addCartCallBack: this);
    }
    setState(() {});
  }

  setRating() {
    fiveStar = 0;
    fourStar = 0;
    threeStar = 0;
    twoStar = 0;
    oneStar = 0;
    list.forEach((review) {
      switch (review.rating) {
        case 5:
          fiveStar++;
          break;
        case 4:
          fourStar++;
          break;
        case 3:
          threeStar++;
          break;
        case 2:
          twoStar++;
          break;
        case 1:
          oneStar++;
          break;
      }
    });
    fiveStar = (fiveStar * 100) / list.length;
    fourStar = (fourStar * 100) / list.length;
    threeStar = (threeStar * 100) / list.length;
    twoStar = (twoStar * 100) / list.length;
    oneStar = (oneStar * 100) / list.length;
    print(fiveStar);
  }

  @override
  void dispose() {
    changeStatusColor(Colors.white);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _reviewController.init();
    changeStatusColor(Colors.transparent);
    var width = MediaQuery.of(context).size.width;
    var sliderImages = Container(
      height: 330,
      child: PageView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return !widget.is_ad
              ? _productOptionsController.currentProduct.value.photos.isEmpty ==
                          null ||
                      _productOptionsController.currentProduct.value.image ==
                          "" ||
                      _productOptionsController
                          .currentProduct.value.photos.isEmpty
                  ? Image.asset("assets/images/default_image_product.png")
                  : CarouselSlider(
                      options: CarouselOptions(height: 400.0),
                      items: _productOptionsController
                          .currentProduct.value.photos
                          .map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                final imageProvider = Image.network(
                                        "${Constants.IMAGE_BASE_URL}${i}")
                                    .image;

                                showImageViewer(context, imageProvider,
                                    onViewerDismissed: () {
                                  print("dismissed");
                                });
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Image.network(
                                      "${Constants.IMAGE_BASE_URL}${i}",
                                      width: width,
                                      height: width * 1.05,
                                      fit: BoxFit.cover)),
                            );
                          },
                        );
                      }).toList(),
                    )
              : currentAdProduct.thumbnailImg == null ||
                      currentAdProduct.thumbnailImg == ""
                  ? Image.asset("assets/images/default_image_product.png")
                  : Image.network(
                      "${Constants.IMAGE_BASE_URL}${currentAdProduct.thumbnailImg}",
                      width: width,
                      height: width * 1.05,
                      fit: BoxFit.cover);
        },
        onPageChanged: (index) {
          position = index;
          setState(() {});
        },
      ),
    );

    var reviews = _reviewController.reviews.isEmpty
        ? Center(child: Text("No Reviews"))
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              children: _reviewController.reviews.map((e) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _productOptionsController
                                      .currentProduct.value.image ==
                                  null
                              ? Image.asset(
                                  "assets/images/default_image_product.png",
                                  width: 100,
                                  height: 100,
                                )
                              : Image.network(
                                  "${Constants.IMAGE_BASE_URL}${_productOptionsController.currentProduct.value.image}",
                                  width: 100,
                                  height: 100,
                                ),
                          RB.RatingBar(
                            initialRating: double.parse("${e.rating}"),
                            direction: Axis.horizontal,
                            // allowHalfRating: true,
                            tapOnlyMode: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemSize: 35,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${e.comment}"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "${e.userName}",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "${e.time}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );

    var descriptionTab = GetBuilder<ProductOptionsController>(
      init: ProductOptionsController(),
      initState: (_) {},
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(spacing_standard_new),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    !widget.is_ad
                        ? translator.currentLanguage == "en"
                            ? Html(
                                data:
                                    "${_productOptionsController.currentProduct.value.description}")
                            : Html(
                                data:
                                    "${_productOptionsController.currentProduct.value.description}")
                        : translator.currentLanguage == "en"
                            ? Html(
                                data: currentAdProduct == null
                                    ? ""
                                    : currentAdProduct.name == null
                                        ? ""
                                        : "${currentAdProduct.name}")
                            : Html(data: "${currentAdProduct.name}")
                  ],
                ),
                currentAdProduct != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 50,
                                  color: primaryColor,
                                ),
                                Text(
                                  "${currentAdProduct.addedBy}",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 50,
                                  color: primaryColor,
                                ),
                                Text(
                                  "${currentAdProduct.location}",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_android,
                                  size: 50,
                                  color: primaryColor,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launch("tel:${currentAdProduct.phone}");
                                  },
                                  child: Text(
                                    "${currentAdProduct.phone}",
                                    style: TextStyle(
                                        fontSize: 30, color: primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: spacing_standard_new),
                SizedBox(height: spacing_standard_new),
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 20, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${translator.translate("related_products")}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22),
                              ),
                            ),
                          ],
                        ),
                        GetBuilder<RelatedProductsController>(
                          init: RelatedProductsController(),
                          initState: (_) {},
                          builder: (_) {
                            return Column(
                              children: relatedProductsController
                                  .relatedProduct.value.details
                                  .map((e) {
                                Product _product = Product(
                                    e.id,
                                    e.name,
                                    e.photos,
                                    e.thumbnailImage,
                                    e.basePrice,
                                    e.baseDiscountedPrice,
                                    e.todaysDeal,
                                    e.featured,
                                    e.currentStock.toString(),
                                    e.tags,
                                    e.hashtagIds,
                                    e.discount,
                                    e.discountType,
                                    e.rating.toString(),
                                    "text",
                                    e.sales,
                                    e.links.details,
                                    e.links.reviews,
                                    e.links.related,
                                    e.links.topFromSeller,
                                    e.country,
                                    e.isFavorite);
                                return GestureDetector(
                                  onTap: () {
                                    Get.off(ShProductDetail(
                                      is_ad: false,
                                      product: _product,
                                      productID: e.id,
                                    ));
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
                                                      child: e.thumbnailImage ==
                                                              null
                                                          ? Image.asset(
                                                              "assets/images/default_image_product.png",
                                                              fit: BoxFit
                                                                  .contain,
                                                              height:
                                                                  width * 0.4,
                                                            )
                                                          : Image.network(
                                                              Constants
                                                                      .IMAGE_BASE_URL +
                                                                  e.thumbnailImage,
                                                              fit: BoxFit
                                                                  .contain,
                                                              height:
                                                                  width * 0.4,
                                                            ),
                                                    ),
                                                    int.parse(e.currentStock
                                                                .toString()) >
                                                            0
                                                        ? Positioned(
                                                            left: 45,
                                                            bottom: 10,
                                                            child:
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      Helpers.isLoggedIn()
                                                                          .then(
                                                                              (_result) {
                                                                        setState(
                                                                            () {
                                                                          if (_result) {
                                                                            cartPresenter.addToCart(
                                                                                e.id.toString(),
                                                                                false,
                                                                                null,
                                                                                null);
                                                                          } else {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                      title: Text("${translator.translate("must_sign_in")}"),
                                                                                      actions: [
                                                                                        ElevatedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                                                return T3SignIn();
                                                                                              }));
                                                                                            },
                                                                                            child: Text("${translator.translate("sign_in")}"))
                                                                                      ],
                                                                                    ));
                                                                          }
                                                                        });
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      // margin: EdgeInsets.only(top: vUnit * 16.5),
                                                                      // padding: EdgeInsets.only(),
                                                                      // color: OColors.colorGray,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          cartPresenter.addToCart(
                                                                              e.id.toString(),
                                                                              false,
                                                                              null,
                                                                              null);
                                                                        },
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              17,
                                                                          backgroundColor:
                                                                              primaryColor,
                                                                          child:
                                                                              Icon(
                                                                            Icons.add_shopping_cart,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                25,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                          )
                                                        : Container(),
                                                    int.parse(e.currentStock
                                                                .toString()) ==
                                                            0
                                                        ? Positioned(
                                                            left: 0,
                                                            bottom: 25,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                  "${translator.translate("out_of_stock")}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
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
                                                      CrossAxisAlignment.start,
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
                                                              0.5,
                                                          child: Text(
                                                            e.name,
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
                                                    //
                                                    //     textColor: appStore.textSecondaryColor),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        e.basePrice ==
                                                                e.baseDiscountedPrice
                                                            ? Row(
                                                                children: [
                                                                  text(
                                                                      Funcs().removeTrailingZero(e
                                                                              .basePrice) +
                                                                          " " +
                                                                          "${translator.translate("EGP")}",
                                                                      textColor:
                                                                          appStore
                                                                              .textSecondaryColor),
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "${Funcs().removeTrailingZero(e.basePrice)}",
                                                                    style: TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .lineThrough,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Text(
                                                                    "${Funcs().removeTrailingZero(e.baseDiscountedPrice)}  ${translator.translate("EGP")}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  )
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
                                              )
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

    var moreInfoTab = SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(left: 16, top: 20, right: 16),
          child: Column(
            children: [
              _productOptionsController.currentProduct.value.videoLink != null
                  ? GestureDetector(
                      onTap: () {
                        if (currentAdProduct != null) {
                          _launchURL(currentAdProduct.videoLink);
                        } else {
                          _launchURL(_productOptionsController
                              .currentProduct.value.videoLink);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.airplay_outlined),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text("${translator.translate("view_video")}")
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  if (currentAdProduct != null && currentAdProduct.pdf != "") {
                    _launchURL("${Constants.BASE_URL}${currentAdProduct.pdf}");
                  } else if (_productOptionsController.currentProduct.value !=
                          null &&
                      _productOptionsController.currentProduct.value.pdf !=
                          "") {
                    _launchURL(
                        "${Constants.BASE_URL}${_productOptionsController.currentProduct.value.pdf}");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.analytics_outlined),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text("${translator.translate("download_info")}")
                  ],
                ),
              ),
            ],
          )),
    );

    var reviewsTab = SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 60),
      child: Container(
        margin: EdgeInsets.only(left: 16, top: 20, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(spacing_standard_new),
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                text(sh_lbl_reviews,
                    textColor: sh_textColorPrimary,
                    fontFamily: fontMedium,
                    fontSize: textSizeNormal),
              ],
            ),
            reviews
          ],
        ),
      ),
    );

    var bottomButtons = Container(
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(3, 1))
      ], color: sh_white),
      child: isLoadingAddCart
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print("added to cart");
                      cartPresenter.addToCart(
                          _productOptionsController.currentProduct.value.id
                              .toString(),
                          false,
                          _productOptionsController.finalVariant,
                          _productOptionsController.finalColor);
                    },
                    child: Container(
                      child: text(sh_lbl_add_to_cart,
                          textColor: sh_textColorPrimary,
                          fontSize: textSizeLargeMedium,
                          fontFamily: fontMedium),
                      color: sh_white,
                      alignment: Alignment.center,
                      height: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print("added to cart");
                      cartPresenter.addToCart(
                          _productOptionsController.currentProduct.value.id
                              .toString(),
                          true,
                          _productOptionsController.finalVariant,
                          _productOptionsController.finalColor);
                    },
                    child: Container(
                      child: text(sh_lbl_buy_now,
                          textColor: sh_white,
                          fontSize: textSizeLargeMedium,
                          fontFamily: fontMedium),
                      color: sh_colorPrimary,
                      alignment: Alignment.center,
                      height: double.infinity,
                    ),
                  ),
                )
              ],
            ),
    );

    return Obx(
      () => Scaffold(
        body: _productOptionsController.isLoading.value
            ? _productOptionsController.currentProduct.value == null
                ? Container()
                : SpinKitChasingDots(color: primaryColor)
            : Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  DefaultTabController(
                    length: _productOptionsController
                                .currentProduct.value.videoLink !=
                            null
                        ? 3
                        : 2,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        changeStatusColor(innerBoxIsScrolled
                            ? Colors.white
                            : Colors.transparent);
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: _productOptionsController
                                        .currentProduct !=
                                    null
                                ? _productOptionsController
                                            .currentProduct.value.variant !=
                                        null
                                    ? _productOptionsController
                                            .currentProduct.value.variant
                                        ? MediaQuery.of(context).size.height *
                                            0.82
                                        : MediaQuery.of(context).size.height *
                                            0.64
                                    : MediaQuery.of(context).size.height * 0.64
                                : MediaQuery.of(context).size.height * 0.64,
                            floating: false,
                            pinned: true,
                            titleSpacing: 0,
                            backgroundColor: sh_white,
                            iconTheme:
                                IconThemeData(color: sh_textColorPrimary),
                            actionsIconTheme:
                                IconThemeData(color: sh_textColorPrimary),
                            actions: <Widget>[
                              // cartIcon(context, 3),
                              ShoppingCartButtonWidget(),
                            ],
                            title: text(
                                innerBoxIsScrolled
                                    ? _productOptionsController
                                        .currentProduct.value.name
                                    : "",
                                textColor: sh_textColorPrimary,
                                fontSize: textSizeNormal,
                                fontFamily: fontMedium),
                            flexibleSpace: Obx(
                              () => FlexibleSpaceBar(
                                background: Column(
                                  children: <Widget>[
                                    sliderImages,
                                    _productOptionsController
                                                .currentProduct.value ==
                                            null
                                        ? Container()
                                        : Obx(
                                            () => Padding(
                                              padding: EdgeInsets.all(14),
                                              child: Column(
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
                                                              0.7,
                                                          child: text(
                                                              !widget
                                                                      .is_ad
                                                                  ? _productOptionsController
                                                                      .currentProduct
                                                                      .value
                                                                      .name
                                                                  : currentAdProduct
                                                                      .name,
                                                              textColor:
                                                                  sh_textColorPrimary,
                                                              fontFamily:
                                                                  fontMedium,
                                                              fontSize:
                                                                  textSizeXNormal)),
                                                      Obx(
                                                        () => Text(
                                                          "${_productOptionsController.currentProduct.value.name != null ? _productOptionsController.currentProduct.value.price : currentAdProduct.unitPrice}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: null,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                fontMedium,
                                                            fontSize:
                                                                textSizeXNormal,
                                                            color:
                                                                sh_colorPrimary,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                      // Obx(
                                                      //   () => text(
                                                      //     "${_productOptionsController.currentProduct != null ? _productOptionsController.currentProduct.value.price : currentAdProduct.unitPrice}",
                                                      //     textColor:
                                                      //         sh_colorPrimary,
                                                      //     fontSize:
                                                      //         textSizeXNormal,
                                                      //     fontFamily: fontMedium,
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                  SizedBox(height: 1),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            _productOptionsController
                                                                        .currentProduct !=
                                                                    null
                                                                ? _productOptionsController.currentProduct.value.country == null ||
                                                                        _productOptionsController.currentProduct.value.country ==
                                                                            "null" ||
                                                                        _productOptionsController.currentProduct.value.country ==
                                                                            ""
                                                                    ? Container()
                                                                    : text(
                                                                        "${_productOptionsController.currentProduct.value.country}")
                                                                : currentAdProduct.country == null ||
                                                                        currentAdProduct.country ==
                                                                            "" ||
                                                                        currentAdProduct.country ==
                                                                            "null"
                                                                    ? Container()
                                                                    : Text(
                                                                        "${currentAdProduct.country}"),
                                                            _productOptionsController
                                                                        .currentProduct !=
                                                                    null
                                                                ? RB.RatingBar(
                                                                    initialRating:
                                                                        double.parse(
                                                                            "3"),
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        true,
                                                                    tapOnlyMode:
                                                                        true,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        16,
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    onRatingUpdate:
                                                                        (rating) {},
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          '${translator.translate("share_to")}')
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            Share.share(
                                                                'https://mymedicalshope.com/product/${_productOptionsController.currentProduct.value.id}');
                                                          },
                                                          child: Image.asset(
                                                            "assets/icons/whatsapp.png",
                                                            width: 25,
                                                          )),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            Share.share(
                                                                'https://mymedicalshope.com/product/${_productOptionsController.currentProduct.value.id}');
                                                          },
                                                          child: Image.asset(
                                                            "assets/icons/facebook.png",
                                                            width: 25,
                                                          )),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            Share.share(
                                                                'https://mymedicalshope.com/product/${_productOptionsController.currentProduct.value.id}');
                                                          },
                                                          child: Image.asset(
                                                            "assets/icons/instagram.png",
                                                            width: 25,
                                                          )),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            Share.share(
                                                                'https://mymedicalshope.com/product/${_productOptionsController.currentProduct.value.id}');
                                                          },
                                                          child: Image.asset(
                                                            "assets/icons/linkedin.png",
                                                            width: 25,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  _productOptionsController
                                                              .currentProduct
                                                              .value
                                                              .name !=
                                                          null
                                                      ? _productOptionsController
                                                              .currentProduct
                                                              .value
                                                              .variant
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                    "${translator.translate("options")}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            )
                                                          : Container()
                                                      : Container(),
                                                  Column(
                                                    children: _productOptionsController
                                                                .currentProduct
                                                                .value
                                                                .name !=
                                                            null
                                                        ? _productOptionsController
                                                            .currentProduct
                                                            .value
                                                            .options
                                                            .map((element) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "${element.title}"),
                                                                  Spacer(),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: element
                                                                        .options
                                                                        .asMap()
                                                                        .entries
                                                                        .map(
                                                                            (e) {
                                                                      return Obx(
                                                                        () =>
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (element.title ==
                                                                                "Size") {
                                                                              _productOptionsController.changeSize(e.key, e.value, _productOptionsController.currentProduct.value.id);
                                                                              Future.delayed(Duration(seconds: 1), () {
                                                                                setState(() {});
                                                                              });
                                                                            } else if (element.title ==
                                                                                "weight") {
                                                                              _productOptionsController.changeWeight(e.key, e.value, _productOptionsController.currentProduct.value.id);
                                                                              Future.delayed(Duration(seconds: 1), () {
                                                                                setState(() {});
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(6.0),
                                                                            child:
                                                                                Container(
                                                                              width: 22,
                                                                              height: 22,
                                                                              decoration: BoxDecoration(
                                                                                  color: element.title == "Size"
                                                                                      ? _productOptionsController.chosenSizeIndex.value == e.key
                                                                                          ? primaryColor
                                                                                          : Color(0xffC9EDF4)
                                                                                      : _productOptionsController.chosenWeightIndex.value == e.key
                                                                                          ? primaryColor
                                                                                          : Color(0xffC9EDF4)),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                '${e.value}',
                                                                                style: TextStyle(
                                                                                    color: element.title == "Size"
                                                                                        ? _productOptionsController.chosenSizeIndex.value == e.key
                                                                                            ? Colors.white
                                                                                            : Colors.black
                                                                                        : _productOptionsController.chosenWeightIndex == e.key
                                                                                            ? Colors.white
                                                                                            : Colors.black),
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList()
                                                        : [],
                                                  ),
                                                  _productOptionsController
                                                                  .currentProduct
                                                                  .value
                                                                  .colors !=
                                                              null &&
                                                          _productOptionsController
                                                              .currentProduct
                                                              .value
                                                              .colors
                                                              .isNotEmpty
                                                      ? Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "${translator.translate("colors")}"),
                                                            ),
                                                            Spacer(),
                                                            Container(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              child: Row(
                                                                children:
                                                                    _productOptionsController
                                                                        .currentProduct
                                                                        .value
                                                                        .colors
                                                                        .asMap()
                                                                        .entries
                                                                        .map(
                                                                            (e) {
                                                                  Color color =
                                                                      HexColor(
                                                                          "${e.value}");

                                                                  return Obx(
                                                                    () =>
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        _productOptionsController.changeColor(
                                                                            e.key,
                                                                            e.value,
                                                                            _productOptionsController.currentProduct.value.id);
                                                                        Future.delayed(
                                                                            Duration(seconds: 1),
                                                                            () {
                                                                          setState(
                                                                              () {});
                                                                        });
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          decoration: BoxDecoration(
                                                                              color: color,
                                                                              border: Border.all(color: _productOptionsController.chosenColorIndex.value == e.key ? primaryColor : color, width: 2)),
                                                                          child:
                                                                              Text(""),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                collapseMode: CollapseMode.pin,
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              _productOptionsController
                                          .currentProduct.value.videoLink !=
                                      null
                                  ? TabBar(
                                      labelColor: sh_colorPrimary,
                                      indicatorColor: sh_colorPrimary,
                                      unselectedLabelColor: sh_textColorPrimary,
                                      tabs: [
                                        Tab(text: sh_lbl_description),
                                        Tab(text: sh_lbl_tab_more_info),
                                        Tab(text: sh_lbl_reviews),
                                        // Tab(
                                        //     text:
                                        //         "${translator.translate("related_products")}"),
                                      ],
                                    )
                                  : TabBar(
                                      labelColor: sh_colorPrimary,
                                      indicatorColor: sh_colorPrimary,
                                      unselectedLabelColor: sh_textColorPrimary,
                                      tabs: [
                                        Tab(text: sh_lbl_description),
                                        // Container(),
                                        Tab(text: sh_lbl_reviews),
                                        // Tab(
                                        //     text:
                                        //         "${translator.translate("related_products")}"),
                                      ],
                                    ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: _productOptionsController
                                  .currentProduct.value.videoLink !=
                              null
                          ? TabBarView(
                              children: [
                                descriptionTab,
                                moreInfoTab,
                                reviewsTab,
                              ],
                            )
                          : TabBarView(
                              children: [
                                descriptionTab,
                                reviewsTab,
                              ],
                            ),
                    ),
                  ),
                  _productOptionsController.currentProduct.value != null
                      ? bottomButtons
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget reviewText(rating,
      {size = 15.0,
      fontSize = textSizeLargeMedium,
      fontFamily = fontMedium,
      textColor = sh_textColorPrimary}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        text(rating.toString(),
            textColor: textColor, fontFamily: fontFamily, fontSize: fontSize),
        SizedBox(width: spacing_control),
        Icon(Icons.star, color: Colors.amber, size: size)
      ],
    );
  }

/*
  Widget ratingProgress(value, color) {
    return Expanded(
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        percent: value / 100,
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: Colors.grey.withOpacity(0.2),
        progressColor: color,
      ),
    );
  }
*/

  void showRatingDialog(BuildContext context) {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: boxDecoration(
                        bgColor: sh_white,
                        showShadow: false,
                        radius: spacing_middle),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: text("Review",
                              fontSize: 24,
                              fontFamily: fontBold,
                              textColor: sh_textColorPrimary),
                        ),
                        Divider(
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(spacing_large),
                          child: RB.RatingBar(
                            initialRating: double.parse("3"),
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            tapOnlyMode: true,
                            itemCount: 5,
                            itemSize: 16,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: spacing_large, right: spacing_large),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: controller,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              validator: (value) {
                                return value.isEmpty
                                    ? "Review Filed Required!"
                                    : null;
                              },
                              style: TextStyle(
                                  fontFamily: fontRegular,
                                  fontSize: textSizeNormal,
                                  color: sh_textColorPrimary),
                              decoration: new InputDecoration(
                                hintText: 'Describe your experience',
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                filled: false,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(spacing_large),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  textColor: sh_colorPrimary,
                                  child: text(sh_lbl_cancel,
                                      fontSize: textSizeNormal,
                                      textColor: sh_colorPrimary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    side: BorderSide(color: sh_colorPrimary),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(ConfirmAction.CANCEL);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: spacing_standard_new,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  color: sh_colorPrimary,
                                  textColor: Colors.white,
                                  child: text(sh_lbl_submit,
                                      fontSize: textSizeNormal,
                                      textColor: sh_white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                  ),
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                    } else {
                                      setState(() => _autoValidate = true);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void onAddCartDataError(String message) {
    Future.delayed(Duration(seconds: 1), () {
      Future.delayed(Duration(seconds: 1), () {
        _productOptionsController.isLoading.value = false;
        setState(() {});
      });
    });
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onAddCartDataLoading(bool show) {
    setState(() {
      isLoadingAddCart = show;
    });
  }

  @override
  void onAddCartDataSuccess(String message, bool gotoShop) {
    if (gotoShop) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return DTCartScreen();
      }));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomMessageDialog(
                errorText: message,
              )).then((value) {
        setState(() {
          // Constants.CART_COUNT++;
          // Constants.INCRECE_CART_COUNT();
          // isAddedToCart = true;
        });
      });
    }
  }

  @override
  void onAdsDataSuccess(AddsProductsData data) {
    _productOptionsController.currentProduct.value.name = null;
    _productOptionsController.currentProduct.value.colors = null;
    currentAdProduct = data;
  }

  @override
  void onDataError(String message) {
    // TODO: implement onDataError
  }

  @override
  void onDataLoading(bool show) {
    // TODO: implement onDataLoading
  }

  @override
  void onDataSuccess(ProductDetails data) {
    print(data);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      color: sh_white,
      child: Container(child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
