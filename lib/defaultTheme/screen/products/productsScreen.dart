import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app/modules/products_search/controllers/products_search_controller.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTCartScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/DTWidgets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/funcs.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/rating_bar.dart';
import 'package:my_medical_app/services/search_controller.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/SearchWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductsScreen extends StatefulWidget {
  // String productsLink;
  // NavigationModel navigationModel;

  // ProductsScreen({/*this.productsLink, */ this.navigationModel});

  final bool search;
  final SearchFilter widgetSelectedSearchFilter;
  final String widgetSearchText;
  final SearchFilter widgetSortByFilter;

  ProductsScreen(
      {Key key,
      @required this.search,
      this.widgetSelectedSearchFilter,
      this.widgetSearchText,
      @required this.widgetSortByFilter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductsScreenState();
  }
}

class ProductsScreenState extends State<ProductsScreen>
    implements
        ProductsCallBack,
        LocalSearchCallBack,
        AddCartCallBack,
        AddWishListCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;
  bool isLoadingMoreData = false;
  bool noProducts = true;
  ProductsPresenter presenter;
  CartPresenter cartPresenter;

  String url = Constants.BASE_URL + 'products';

  List<Product> productsList = List();

  int current_page = 1;
  int last_page = 1;
  String nextURL;
  String lastURL;
  ScrollController _scrollController = ScrollController();
  WishListPresenter wishPresenter;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  final SearchController c = Get.put(SearchController());
  final ProductsSearchController productSearchController =
      Get.isRegistered<ProductsSearchController>()
          ? Get.find()
          : Get.put(ProductsSearchController());
  @override
  void initState() {
    super.initState();
    if (!widget.search) {
      c.doSearch("", "", "", false);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        c.doSearch("", "", "", true);
      }
    });

    if (cartPresenter == null) {
      cartPresenter = CartPresenter(context: context, addCartCallBack: this);
    }
    if (wishPresenter == null) {
      wishPresenter =
          WishListPresenter(context: context, addWishListCallBack: this);
    }

    if (widget.search != null) {
      productSearchController.searchIsVisible.value = true;
    }

    Helpers.getUserData().then((_user) {
      setState(() {
        isLogged = _user.isLoggedIn;
        user = _user;
      });
    });
  }

  bool viewSearchResult = false;

  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(categoriesList: categoriesList),
        appBar: CustomAppBar(
          title: productSearchController.searchIsVisible.value
              ? "${translator.translate("search")}"
              : "${translator.translate("products")}",
          isHome: false,
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              viewSearchResult = false;
            });
          },
          child: Container(
            // padding: EdgeInsets.all(wUnit * 3),
            child: Column(
              children: [
                Container(
                  // padding: EdgeInsets.all(wUnit),
                  child: SearchWidget(
                    searchText: widget.widgetSearchText,
                    isHidden: productSearchController.searchIsVisible.value,
                    widgetSelectedSearchFilter:
                        widget.widgetSelectedSearchFilter,
                    widgetSelectedSortFilter: widget.widgetSortByFilter,
                    hasSearch: widget.search,
                    localSearchCallBack: this,
                    viewSearchResult: viewSearchResult,
                    user: user,
                    onOpenDrawer: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                ),
                SizedBox(
                  height: vUnit,
                ),
                Expanded(
                  child: Obx(
                    () => c.productsList.isEmpty
                        ? Center(
                            child:
                                Text("${translator.translate("no_products")}"),
                          )
                        : LiquidPullToRefresh(
                            backgroundColor: Colors.white,
                            color: primaryColor,
                            onRefresh: _handleRefresh, // refresh callback
                            child: GridView.count(
                              controller: _scrollController,
                              childAspectRatio: 0.75,
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              children: c.productsList.map((data) {
                                return Container(
                                  decoration: boxDecorationRoundedWithShadow(8,
                                      backgroundColor: Colors.white),
                                  margin: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          data.thumbnail_image == null ||
                                                  data.thumbnail_image == ""
                                              ? Image.asset(
                                                  "assets/images/default_image_product.png",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                )
                                              : Image.network(
                                                  "${Constants.IMAGE_BASE_URL}${data.thumbnail_image}",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  fit: BoxFit.cover,
                                                  // height: isMobile ? 110 : 180,
                                                ),
                                          Positioned(
                                            right: 2,
                                            top: 5,
                                            child: GestureDetector(
                                                onTap: () {
                                                  addToFavorite(data);
                                                },
                                                child: Container(
                                                  // margin: EdgeInsets.only(top: vUnit * 16.5),
                                                  // padding: EdgeInsets.only(),
                                                  // color: OColors.colorGray,
                                                  child: isLoadingData
                                                      ? CircularProgressIndicator()
                                                      : data.isFavorite == null
                                                          ? Container()
                                                          : Icon(
                                                              Icons.favorite,
                                                              color: data
                                                                      .isFavorite
                                                                  ? Colors.red
                                                                  : Colors.grey,
                                                              size: 28,
                                                            ),
                                                )),
                                          ),
                                          int.parse(data.current_stock) > 0
                                              ? Positioned(
                                                  right: 1,
                                                  bottom: 1,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        Helpers.isLoggedIn()
                                                            .then((_result) {
                                                          setState(() {
                                                            if (_result) {
                                                              cartPresenter
                                                                  .addToCart(
                                                                      data.id
                                                                          .toString(),
                                                                      false,
                                                                      null,
                                                                      null);
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                        title: Text(
                                                                            "${translator.translate("must_sign_in")}"),
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
                                                      child: Container(
                                                        // margin: EdgeInsets.only(top: vUnit * 16.5),
                                                        // padding: EdgeInsets.only(),
                                                        // color: OColors.colorGray,
                                                        child: isLoadingData
                                                            ? CircularProgressIndicator()
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  cartPresenter
                                                                      .addToCart(
                                                                          data.id
                                                                              .toString(),
                                                                          false,
                                                                          null,
                                                                          null);
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 17,
                                                                  backgroundColor:
                                                                      primaryColor,
                                                                  child: Icon(
                                                                    Icons
                                                                        .add_shopping_cart,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 25,
                                                                  ),
                                                                ),
                                                              ),
                                                      )),
                                                )
                                              : Positioned(
                                                  bottom: 5,
                                                  child: Container(
                                                    color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Text(
                                                        "${translator.translate("out_of_stock")}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(data.name,
                                              style: primaryTextStyle(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          4.height,
                                          Row(
                                            children: [
                                              RatingBar(
                                                onRatingChanged: (r) {},
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star_border,
                                                initialRating:
                                                    double.parse(data.rating),
                                                maxRating: 5,
                                                filledColor: Colors.yellow,
                                                size: 14,
                                              ),
                                              5.width,
                                              Text('${data.rating}',
                                                  style: secondaryTextStyle(
                                                      size: 12)),
                                            ],
                                          ),
                                          4.height,
                                          data.base_discounted_price ==
                                                  data.base_price
                                              ? Row(
                                                  children: [
                                                    priceWidget(
                                                        data.base_price),
                                                    8.width,
                                                    // priceWidget(data.base_price, applyStrike: true),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "${Funcs().removeTrailingZero(data.base_price)} ${translator.translate("egp")}",
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${Funcs().removeTrailingZero(data.base_discounted_price)} LE",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),

                                                    // priceWidget(data.base_price, applyStrike: true),
                                                  ],
                                                ),
                                        ],
                                      ).paddingAll(8),
                                    ],
                                  ),
                                ).onTap(() async {
                                  int index = await ShProductDetail(
                                    is_ad: false,
                                    product: data,
                                    productID: data.id,
                                  ).launch(context);
                                  if (index != null)
                                    appStore.setDrawerItemIndex(index);
                                });
                              }).toList(),
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(wUnit * 3),
                  alignment: Alignment.center,
                  child: Obx(
                    () => Visibility(
                      child: CircularProgressIndicator(),
                      visible: c.isLoadingMore.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onDataSuccess(List<ProductsData> data, Meta meta) {
    setState(() {
      current_page = meta.currentPage;
      last_page = meta.lastPage;
      for (ProductsData p in data) {
        productsList.add(Product(
            p.id,
            p.name,
            p.photos,
            p.thumbnailImage,
            p.basePrice,
            p.baseDiscountedPrice,
            p.todaysDeal,
            p.featured,
            p.current_stock,
            p.tags,
            p.hashtagIds,
            p.discount,
            p.discountType,
            p.rating,
            null,
            p.sales,
            p.links.details,
            p.country,
            p.links.reviews,
            p.links.related,
            p.links.topFromSeller,
            p.isFavorite));
      }
    });
    setState(() {});
  }

  @override
  void onMoreDataLoading(bool show) {
    setState(() {
      // _loadingSearch = show;
      isLoadingMoreData = show;
    });
  }

  @override
  void onSearchDataSuccess(List<Product> data, Meta meta) {
    setState(() {
      current_page = meta.currentPage;
      last_page = meta.lastPage;

      if (data.length == 0) {
        noProducts = true;
        productsList.clear();
      } else {
        noProducts = false;
        productsList.clear();
        productsList.addAll(data);
      }
    });
    setState(() {});
  }

  @override
  void onLoadCurrentProducts(bool load) {
    // TODO: implement onLoadCurrentProducts
    if (load) {
      presenter.getAllProductssData(Constants.BASE_URL + 'products', "1");
    }
  }

  @override
  void onAddCartDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onAddCartDataLoading(bool show) {
    isLoadingData = show;
    setState(() {});
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
  void onAddWishListDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onAddWishListDataLoading(bool show) {}

  @override
  void onAddWishListDataSuccess(String message, int theID, bool isRemove) {
    if (theID == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomMessageDialog(
                errorText: message,
              ));
    } else {
      for (Product item in c.productsList) {
        if (item.id == theID) {
          item.isFavorite = isRemove ? false : true;
          setState(() {});
        }
      }
    }
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 1), () {
      completer.complete();
    });
    //TODO changing here
    if (!widget.search) {
      c.doSearch("", "", "", false);
    } else {
      setState(() {});
    }
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('${translator.translate("refresh_complete")}'),
      ));
    });
  }

  addToFavorite(Product e) {
    Helpers.isLoggedIn().then((_result) {
      setState(() {
        if (_result) {
          e.isFavorite
              ? wishPresenter.removeToWishList(e.id.toString(), true)
              : wishPresenter.addToWishList(e.id.toString(), false);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("${translator.translate("must_sign_in")}"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return T3SignIn();
                            }));
                          },
                          child: Text("${translator.translate("sign_in")}"))
                    ],
                  ));
        }
      });
    });
  }
}
