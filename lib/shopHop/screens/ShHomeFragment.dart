import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as fd;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/deep_link_controller.dart';
import 'package:my_medical_app/controllers/showcase_controller.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/bannerModel.dart';
import 'package:my_medical_app/data/remote/models/flashDealsModel.dart';
import 'package:my_medical_app/data/remote/models/homeCategoriesModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/sliderModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTCartScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/brands/brandsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/brands/brandsScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/cart/cartPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/categoriesPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/main_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/sub_sub_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/home/homePresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/inner_pages.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/funcs.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/main/utils/dots_indicator/dots_indicator.dart';
import 'package:my_medical_app/main/utils/rating_bar.dart';
import 'package:my_medical_app/services/api_services.dart';
import 'package:my_medical_app/shopHop/models/ShCategory.dart';
import 'package:my_medical_app/shopHop/models/ShProduct.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/shopHop/screens/ShViewAllProducts.dart';
import 'package:my_medical_app/shopHop/screens/ShWishlistFragment.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShExtension.dart';
import 'package:my_medical_app/shopHop/utils/ShStrings.dart';
import 'package:my_medical_app/shopHop/utils/ShWidget.dart';
import 'package:my_medical_app/theme10/models/T10Models.dart';
import 'package:my_medical_app/theme10/utils/T10Colors.dart';
import 'package:my_medical_app/theme10/utils/T10DataGenerator.dart';
import 'package:my_medical_app/theme4/models/T4Models.dart';
import 'package:my_medical_app/theme4/utils/T4DataGenerator.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/category.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:my_medical_app/widgets/search/SearchBarWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:uni_links/uni_links.dart';

class ShHomeFragment extends StatefulWidget {
  static String tag = '/ShHomeFragment';

  @override
  ShHomeFragmentState createState() => ShHomeFragmentState();
}

class ShHomeFragmentState extends State<ShHomeFragment>
    implements
        HomeCallBack,
        AddWishListCallBack,
        BrandsCallBack,
        AddCartCallBack,
        MainCategoriesCallBack {
  var list = List<ShCategory>();
  var banners = List<String>();
  var newestProducts = List<ShProduct>();
  var featuredProducts = List<ShProduct>();
  var position = 0;
  var colors = [sh_cat_1, sh_cat_2, sh_cat_3, sh_cat_4, sh_cat_5];
  List<SliderData> slider = List();
  List<T4NewsModel> mHorizontalListings;
  T10Product model;
  List<T10Product> mList;
  HomePresenter presenter;
  CategoriesPresenter allCategoriesPresenter;
  int current_page = 1;
  String url = Constants.BASE_URL + 'products';
  bool isLoadingData = false;
  List<Product> categoryProductsList = List();
  bool isLoadingCategoryProductsData = false;
  String flashDealTitle = "";
  String flashDealEndDate = "";
  List<Product> flashDealsList = List();
  List<Product> topSellersList = List();
  List<Product> featuredProductsList = List();
  List<BannerData> bannerList = List();
  List<Product> productsList = List();
  bool zeroFlashDeal = false;
  bool isLoadingProductsData = false;

  int last_page = 1;
  ScrollController _scrollController = ScrollController();

  String flashDealEnds;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;
  WishListPresenter wishPresenter;

  bool isFavorate = false;

  List<BrandsData> brandsList = List();
  BrandsPresenter brandsPresenter;

  CartPresenter cartPresenter;

  String devide_id;

  bool isWishListLoading = false;

  Uri _initialUri;
  Uri _latestUri;
  Object _err;
  StreamSubscription _sub;

  List<MainCategoryModel> allCategoriesList = List();
  BusinessSettingController businessSettingController = Get.find();
  void _handleIncomingLinks() {
    if (!fd.kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri uri) {
        if (!mounted) return;
        print('got uri: $uri');
        _launchURL(uri.toString());
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  ShowcaseController _showcaseController = Get.put(ShowcaseController());
  DeepLinkController _deepLinkController = Get.put(DeepLinkController());

  @override
  void initState() {
    _handleIncomingLinks();
    super.initState();
    //brands presenter
    if (brandsPresenter == null) {
      brandsPresenter = BrandsPresenter(context: context, brandsCallBack: this);
      brandsPresenter.getAllBrandsData();
    }
    if (cartPresenter == null) {
      cartPresenter = CartPresenter(context: context, addCartCallBack: this);
    }

    if (wishPresenter == null) {
      wishPresenter =
          WishListPresenter(context: context, addWishListCallBack: this);
    }
    if (allCategoriesPresenter == null) {
      allCategoriesPresenter =
          CategoriesPresenter(context: context, mainCategoriesCallBack: this);
      allCategoriesPresenter.getMainCategoriesData();
    }

    mHorizontalListings = getList2Data();
    mList = getProducts();
    print(getProducts());
    print(mList);
    fetchData();
    fetchAllData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (current_page < last_page) {
          current_page++;
          // noProducts = false;
          presenter.getAllProductssData(url, current_page.toString());
        }
      }
    });
    Future.delayed(Duration(seconds: 3), () {
      _showcaseController.runShowcase();
    });
  }

  Future fetchTopSellers() async {
    ApiServices().getTopSellers().then((resp) {
      for (var item in resp['data']) {
        List<String> photos = [];
        photos.add(item['thumbnail_image']);
        topSellersList.add(Product(
            item['id'],
            item['name'],
            photos,
            item['thumbnail_image'],
            double.parse(item['base_price'].toString()),
            double.parse(item['base_discounted_price'].toString()),
            double.parse(item['todays_deal'].toString()),
            item['featured'],
            item['unit'],
            item['tags'],
            item['hashtag_ids'],
            item['discount'],
            item['discount_type'],
            item['rating'].toString(),
            null,
            item['sales'],
            item['links']['details'],
            item['links']['reviews'],
            item['links']['related'],
            item['links']['top_from_seller'],
            item['country'],
            item['is_favorite']));
      }
    });
  }

  Future fetchFeatured() async {
    ApiServices().getFeatured().then((resp) {
      for (var item in resp['data']) {
        List<String> photos = [];
        photos.add(item['thumbnail_image']);
        featuredProductsList.add(Product(
            item['id'],
            item['name'],
            photos,
            item['thumbnail_image'],
            double.parse(item['base_price'].toString()),
            double.parse(item['base_discounted_price'].toString()),
            double.parse(item['todays_deal'].toString()),
            item['featured'],
            item['unit'],
            item['tags'],
            item['hashtag_ids'],
            item['discount'],
            item['discount_type'],
            item['rating'].toString(),
            null,
            item['sales'],
            item['links']['details'],
            item['links']['reviews'],
            item['links']['related'],
            item['links']['top_from_seller'],
            item['country'],
            item['is_favorite']));
      }
    });
  }

  fetchAllData() async {
    devide_id = await Helpers.getFcmToken();
    if (presenter == null) {
      presenter = HomePresenter(context: context, callBack: this);
      presenter.getSliderData();
      presenter.getBannerData();
      presenter.getFlashDealsData();
      presenter.getCategoriesData();
      // presenter.getTopBrandsData();
      presenter.getAllProductssData(url, current_page.toString());
    }
    fetchTopSellers();
    fetchFeatured();
  }

  fetchData() async {
    loadCategory().then((categories) {
      setState(() {
        list.clear();
        list.addAll(categories);
      });
    }).catchError((error) {
      toast(error.toString());
    });
    List<ShProduct> products = await loadProducts();
    var featured = List<ShProduct>();
    products.forEach((product) {
      if (product.featured) {
        featured.add(product);
      }
    });
/*
    var banner = List<String>();
    for (var i = 1; i < 7; i++) {
      banner
          .add("https://mymedicalshope.com/api/v1/uploads\/all\/3yKPiniCxH7LnmngggJW8D7hWIBQjmt0IegpW5NM.jpeg");
          // .add("images/shophop/img/products/banners/b" + i.toString() + ".jpg");
    }
*/
    setState(() {
      newestProducts.clear();
      featuredProducts.clear();
      banners.clear();
      // banners.addAll(banner);
      newestProducts.addAll(products);
      featuredProducts.addAll(featured);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

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
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    return isLoadingData
        ? SpinKitChasingDots(
            color: primaryColor,
          )
        : ShowCaseWidget(
            onFinish: () {
              _showcaseController.finishShowcase();
            },
            onStart: (index, key) {
            },
            builder: Builder(builder: (context) {
              _showcaseController.myContext = context;
              return WillPopScope(
                onWillPop: showExitPopup, //call function on back button press
                child: Scaffold(
                    body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 30, top: 30),
                      child: StickyHeader(
                        header: Showcase(
                            key: _showcaseController.searchShowcase,
                            title: '${translator.translate("search")}',
                            description:
                                '${translator.translate("search_products")}',
                            child: SearchBarWidget()),
                        content: Column(
                          children: <Widget>[
                            Container(
                              height: height * 0.55,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  PageView.builder(
                                    itemCount: slider.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          print(slider[index].link);
                                          _launchURL(slider[index].link);
                                        },
                                        child: Image.network(
                                            Constants.IMAGE_BASE_URL +
                                                slider[index].photo,
                                            width: width,
                                            height: height * 0.55,
                                            fit: BoxFit.cover),
                                      );
                                    },
                                    onPageChanged: (index) {
                                      setState(() {
                                        position = index;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: slider == null || slider.length <= 0
                                        ? Container()
                                        : DotsIndicator(
                                            dotsCount: slider.length,
                                            position: position,
                                            decorator: DotsDecorator(
                                              color: sh_view_color,
                                              activeColor: sh_colorPrimary,
                                              size: const Size.square(7.0),
                                              activeSize:
                                                  const Size.square(10.0),
                                              spacing: EdgeInsets.all(3),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Showcase(
                              key: _showcaseController.catShowcase,
                              title: '${translator.translate('categories')}',
                              description:
                                  '${translator.translate('all_categories')}',
                              child: Container(
                                height: 140,
                                margin:
                                    EdgeInsets.only(top: spacing_standard_new),
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                  itemCount: categoriesList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(
                                      left: spacing_standard,
                                      right: spacing_standard),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        SearchFilter sortBy = SearchFilter(
                                            key: "new_arrival",
                                            value: translator
                                                .translate('new_arrival'));

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductsScreen(
                                                      search: true,
                                                      widgetSearchText:
                                                          "${categoriesList[index].name}",
                                                      widgetSelectedSearchFilter:
                                                          (SearchFilter(
                                                              key: "category",
                                                              value: translator
                                                                  .translate(
                                                                      'categories'))),
                                                      widgetSortByFilter:
                                                          sortBy,
                                                    )));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(
                                                  spacing_middle),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                // color: colors[index % colors.length]
                                              ),
                                              child: Image.network(
                                                  Constants.IMAGE_BASE_URL +
                                                      categoriesList[index]
                                                          .icon,
                                                  width: 50),
                                            ),
                                            SizedBox(height: spacing_control),
                                            GestureDetector(
                                              onTap: () {
                                                SearchFilter sortBy =
                                                    SearchFilter(
                                                        key: "new_arrival",
                                                        value: translator
                                                            .translate(
                                                                'new_arrival'));
                                                print("pressed");
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return ProductsScreen(
                                                    search: false,
                                                    widgetSortByFilter: sortBy,
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.24,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  child: Text(
                                                    categoriesList[index].name,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            zeroFlashDeal
                                ? Container()
                                : horizontalHeading(sh_lbl_flash_sale,
                                    callback: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => ShViewAllProductScreen(
                                    //             prodcuts: newestProducts,
                                    //             title: sh_lbl_newest_product)
                                    //     )
                                    // );
                                  },
                                    haveCounter: true,
                                    theDate: flashDealEndDate,
                                    context: context),
                            zeroFlashDeal
                                ? Container()
                                : ProductHorizontalList(
                                    list: flashDealsList,
                                    isHorizontal: false,
                                    haveCounter: true,
                                  ),
                            zeroFlashDeal
                                ? Container()
                                : SizedBox(height: spacing_standard_new),
                            businessSettingController
                                        .currentBusinessSettings.value.details
                                        .where((element) =>
                                            element.type == "best_selling")
                                        .toList()[0]
                                        .value ==
                                    "1"
                                ? horizontalHeading(sh_lbl_top_sales,
                                    callback: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShViewAllProductScreen(
                                                    prodcuts: featuredProducts,
                                                    title: sh_lbl_Featured)));
                                  }, haveCounter: false, context: context)
                                : Container(),
                            businessSettingController
                                        .currentBusinessSettings.value.details
                                        .where((element) =>
                                            element.type == "best_selling")
                                        .toList()[0]
                                        .value ==
                                    "1"
                                ? ProductHorizontalList(
                                    list: topSellersList,
                                    haveCounter: false,
                                    isHorizontal: false,
                                  )
                                : Container(),
                            Container(
                              width: width,
                              height: height * 0.35,
                              margin: EdgeInsets.only(top: 22),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bannerList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: index == bannerList.length - 1
                                          ? EdgeInsets.only(left: 16, right: 16)
                                          : EdgeInsets.only(left: 16),
                                      alignment: Alignment.topLeft,
                                      width: width * 0.8,
                                      child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              print(bannerList[index].url);
                                              _launchURL(bannerList[index].url);
                                            },
                                            child: ClipRRect(
                                              child: CachedNetworkImage(
                                                placeholder:
                                                    placeholderWidgetFn(),
                                                imageUrl:
                                                    Constants.IMAGE_BASE_URL +
                                                        bannerList[index].photo,
                                                height: height * 0.28,
                                                width: width * 0.8,
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            horizontalHeading(sh_lbl_featured, callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShViewAllProductScreen(
                                              prodcuts: featuredProducts,
                                              title: sh_lbl_Featured)));
                            }, haveCounter: false, context: context),
                            ProductHorizontalList(
                              list: featuredProductsList,
                              haveCounter: true,
                              isHorizontal: true,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${translator.translate("all_products")}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: productsList.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return ShProductDetail(
                                        is_ad: false,
                                        product: e,
                                        productID: e.id,
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
                                                      child:
                                                          e.thumbnail_image ==
                                                                  null
                                                              ? Image.asset(
                                                                  "assets/images/default_image_product.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height:
                                                                      width *
                                                                          0.4,
                                                                )
                                                              : Image.network(
                                                                  Constants
                                                                          .IMAGE_BASE_URL +
                                                                      e.thumbnail_image,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height:
                                                                      width *
                                                                          0.4,
                                                                ),
                                                    ),
                                                    Positioned(
                                                      left: 55,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Helpers.isLoggedIn()
                                                                .then(
                                                                    (_result) {
                                                              setState(() {
                                                                if (_result) {
                                                                  e.isFavorite
                                                                      ? wishPresenter.removeToWishList(
                                                                          e.id
                                                                              .toString(),
                                                                          true)
                                                                      : wishPresenter.addToWishList(
                                                                          e.id.toString(),
                                                                          false);
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          AlertDialog(
                                                                            title:
                                                                                Text("${translator.translate("must_sign_in")}"),
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
                                                                : e.isFavorite ==
                                                                        null
                                                                    ? Container()
                                                                    : Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: e.isFavorite
                                                                            ? Colors.red
                                                                            : Colors.grey,
                                                                        size:
                                                                            28,
                                                                      ),
                                                          )),
                                                    ),
                                                    int.parse(e.current_stock) >
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
                                                                      child: isLoadingData
                                                                          ? CircularProgressIndicator()
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                cartPresenter.addToCart(e.id.toString(), false, null, null);
                                                                              },
                                                                              child: CircleAvatar(
                                                                                radius: 17,
                                                                                backgroundColor: primaryColor,
                                                                                child: Icon(
                                                                                  Icons.add_shopping_cart,
                                                                                  color: Colors.white,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    )),
                                                          )
                                                        : Container(),
                                                    int.parse(e.current_stock) ==
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
                                                              0.6,
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
                                                      children: [
                                                        RatingBar(
                                                          onRatingChanged:
                                                              (r) {},
                                                          filledIcon:
                                                              Icons.star,
                                                          emptyIcon:
                                                              Icons.star_border,
                                                          initialRating:
                                                              double.parse(e
                                                                  .rating
                                                                  .toString()),
                                                          maxRating: 5,
                                                          filledColor:
                                                              Colors.yellow,
                                                          size: 22,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        e.base_price ==
                                                                e.base_discounted_price
                                                            ? Row(
                                                                children: [
                                                                  text(
                                                                      Funcs().removeTrailingZero(e
                                                                              .base_price) +
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
                                                                    "${Funcs().removeTrailingZero(e.base_price)}",
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
                                                                    "${Funcs().removeTrailingZero(e.base_discounted_price)}  ${translator.translate("EGP")}",
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
                            ),

                            /*
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: productsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ProductList(productsList[index], index);
                            }),
              */
                            Container(
                              margin: EdgeInsets.all(wUnit * 3),
                              alignment: Alignment.center,
                              child: Visibility(
                                child: CircularProgressIndicator(),
                                visible: isLoadingProductsData,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      )),
                )),
              );
            }),
          );
  }

  void _launchURL(String theUrl) {
    bool isBrandsPage = theUrl == null ? false : theUrl.contains("brands");
    bool isCategoriesPage =
        theUrl == null ? false : theUrl.contains("categories");
    bool isProductsPage = theUrl == null ? false : theUrl.contains("products");
    if (theUrl == null) {
      print("no link");
      return null;
    } else if (theUrl == "https://mymedicalshope.com/") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ShHomeScreen();
      }));
    } else if (isBrandsPage) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return BrandsScreen();
      }));
    } else if (isCategoriesPage) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ShWishlistFragment();
      }));
    } else if (isProductsPage) {
      SearchFilter sortBy = SearchFilter(
          key: "new_arrival", value: translator.translate('new_arrival'));
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ProductsScreen(
          search: false,
          widgetSortByFilter: sortBy,
        );
      }));
    } else if (theUrl.contains("brand")) {
      int start = theUrl.indexOf("brand/");
      int end = theUrl.length;
      String theID = theUrl.substring(start + 6, end);
      print(theUrl);
      List products =
          brandsList.where((i) => i.id == int.parse(theID)).toList();
      SearchFilter sortBy = SearchFilter(
          key: "new_arrival", value: translator.translate('new_arrival'));
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        SearchFilter searchFilter = SearchFilter(
            key: "brand", value: translator.translate('filter_brands'));
        return ProductsScreen(
          search: true,
          widgetSelectedSearchFilter: searchFilter,
          widgetSortByFilter: sortBy,
          widgetSearchText: products[0].name,
        );
      }));
    } else if (theUrl.contains('category')) {
      print(theUrl);
      int start = theUrl.indexOf("category/");
      int end = theUrl.length;
      String theID = theUrl.substring(start + 9, end);
      print(theID);
      MainCategoryModel chosenCat;
      SubSubCategoryModel chosenSubCat;
      print("$categoriesList");
      for (MainCategoryModel item in allCategoriesList) {
        print(item.id);
        if (item.id == int.parse(theID)) {
          chosenCat = item;
          chosenSubCat = null;
        }
        for (SubSubCategoryModel subItem in item.subCats) {
          print(subItem.id);
          print(theID);
          if (subItem.id == int.parse(theID)) {
            chosenCat = null;
            chosenSubCat = subItem;
          }
        }
      }
      SearchFilter sortBy = SearchFilter(
          key: "new_arrival", value: translator.translate('new_arrival'));
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        SearchFilter searchFilter = SearchFilter(
            key: "category", value: translator.translate('categories'));
        return ProductsScreen(
          search: true,
          widgetSearchText:
              chosenCat != null ? chosenCat.name : chosenSubCat.name,
          widgetSelectedSearchFilter: searchFilter,
          widgetSortByFilter: sortBy,
        );
      }));
    } else if (theUrl.contains("customer")) {
      int start = theUrl.indexOf("customer-products/");
      int end = theUrl.length;
      String theID = theUrl.substring(start + 48, end);
      print(theID);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ShProductDetail(
          is_ad: true,
          productID: int.parse(theID),
        );
      }));
    } else if (theUrl.contains("product")) {
      int start = theUrl.indexOf("product/");
      int end = theUrl.length;
      String theID = theUrl.substring(start + 8, end);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ShProductDetail(
          is_ad: false,
          productID: int.parse(theID),
        );
      }));
      print('item not found');
    } else {
      int lastSlash = theUrl.lastIndexOf("/");
      String theID = theUrl.substring(lastSlash + 1, theUrl.length);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return InnerPage(pageId: int.parse(theID));
      }));
    }
  }

  @override
  void onBrandDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onBrandDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onBrandDataSuccess(List<BrandsData> data) {
    setState(() {
      brandsList.clear();
      fetchedBrandsList.clear();
      brandsList.addAll(data);
      fetchedBrandsList.addAll(data);
    });
  }

  @override
  void onSliderDataSuccess(List<SliderData> data) {
    setState(() {
      slider.clear();
      slider.addAll(data);
    });
  }

  @override
  void onBannerDataSuccess(List<BannerData> data) {
    setState(() {
      bannerList.clear();
      bannerList.addAll(data);
    });
  }

  @override
  void onDataError(String message) {
    print("error $message");
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onFlashDealsSuccess(FlashDealsData data) {
    if (data != null) {
      flashDealEnds = data.endDate;
      setState(() {
        flashDealTitle = data.title;
        flashDealEndDate = data.endDate;
        flashDealsList.clear();
        for (FlashProductsData p in data.products.data) {
          flashDealsList.add(Product(
              p.id,
              p.name,
              p.photos,
              p.thumbnailImage,
              double.parse(p.basePrice.toString()),
              double.parse(p.baseDiscountedPrice.toString()),
              double.parse(p.todaysDeal.toString()),
              p.featured,
              p.unit,
              p.tags,
              p.hashtagIds,
              p.discount,
              p.discountType,
              p.rating.toString(),
              null,
              p.sales,
              p.links.details,
              p.links.reviews,
              p.links.related,
              p.links.topFromSeller,
              p.country,
              p.isFavorite));
        }
        // flashDealsList.addAll(data.products.data);
      });
    }
  }

  @override
  void onCategoriesSuccess(List<HomeCategoriesData> data) {
    setState(() {
      categoriesList.clear();
      for (HomeCategoriesData c in data) {
        print(c.id);
        categoriesList.add(Category(
            name: c.name,
            icon: c.icon,
            id: c.id,
            banner: c.banner,
            productsLink: c.links.products,
            subCategoriesLink: c.links.subCategories,
            selected: false));
      }

      if (categoriesList.length > 0) {
        categoriesList[0].selected = true;
        presenter.getCategoryProductsData(categoriesList[0].productsLink);
      }
    });
  }

  // @override
  // void onBrandsSuccess(List<BrandsData> data) {
  //   setState(() {
  //     brandsList.clear();
  //
  //     for (BrandsData b in data) {
  //       brandsList.add(Brand(
  //           name: b.name,
  //           logo: b.logo,
  //           productsLink: b.links.products,
  //           selected: false));
  //     }
  //
  //     if (brandsList.length > 0) {
  //       brandsList[0].selected = true;
  //       presenter.getBrandProductsData(brandsList[0].productsLink);
  //     }
  //   });
  // }
  //
  @override
  void onCategoryProductsSuccess(List<ProductsData> data, Meta meta) {
    if (data != null) {
      setState(() {
        categoryProductsList.clear();
        for (ProductsData p in data) {
          categoryProductsList.add(Product(
              p.id,
              p.name,
              p.photos,
              p.thumbnailImage,
              double.parse(p.basePrice.toString()),
              double.parse(p.todaysDeal.toString()),
              double.parse(p.baseDiscountedPrice.toString()),
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
              p.links.reviews,
              p.links.related,
              p.links.topFromSeller,
              p.country,
              p.isFavorite));
        }
      });
    }
    if (_deepLinkController.currentDeepURL.value != "") {
      if (!_showcaseController.showShowcase()) {
        _launchURL(_deepLinkController.currentDeepURL.value);
      }
    }
  }

  @override
  void onCategoryProductsDataLoading(bool show) {
    setState(() {
      isLoadingCategoryProductsData = show;
    });
  }

  @override
  void onProductsDataLoading(bool show) {
    setState(() {
      isLoadingProductsData = show;
    });
  }

  @override
  void onProductsDataSuccess(List<ProductsData> data, Meta meta) {
    current_page = meta.currentPage;
    last_page = meta.lastPage;
    if (data != null) {
      setState(() {
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
              p.links.reviews,
              p.links.related,
              p.links.topFromSeller,
              p.country,
              p.isFavorite));
          fetchedProductsList.add(Product(
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
              p.links.reviews,
              p.links.related,
              p.links.topFromSeller,
              p.country,
              p.isFavorite));
        }
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
  void onAddWishListDataLoading(bool show) {
    setState(() {
      isWishListLoading = show;
    });
  }

  @override
  void onAddWishListDataSuccess(String message, int theID, bool isRemove) {
    for (Product item in productsList) {
      if (item.id == theID) {
        item.isFavorite = isRemove ? false : true;
        setState(() {});
      }
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
  void onDataSuccess(List<MainCategoryModel> data) {
    allCategoriesList.clear();
    allCategoriesList.addAll(data);
  }

  @override
  void noFlashDeal() {
    zeroFlashDeal = true;
    setState(() {});
  }
// @override
// void onBrandProductsDataLoading(bool show) {
//   setState(() {
//     isLoadingBrandProductsData = show;
//   });
// }
//
// @override
// void onBrandProductsSuccess(List<ProductsData> data, Meta meta) {
//   if (data != null) {
//     setState(() {
//       for (ProductsData p in data) {
//         brandProductsList.add(Product(
//             p.id,
//             p.name,
//             p.photos,
//             p.thumbnailImage,
//             p.basePrice,
//             p.baseDiscountedPrice,
//             p.todaysDeal,
//             p.featured,
//             p.unit,
//             p.tags,
//             p.hashtagIds,
//             p.discount,
//             p.discountType,
//             p.rating,
//             null,
//             p.sales,
//             p.links.details,
//             p.links.reviews,
//             p.links.related,
//             p.links.topFromSeller));
//       }
//     });
//   }
// }
//

//
// @override
// void onSearchDataLoading(bool show) {
//   // TODO: implement onSearchDataLoading
// }
//
// @override
// void onSearchDataSuccess(SearchModel data) {
//   // TODO: implement onSearchDataSuccess
// }
}

class ProductList extends StatelessWidget {
  Product model;

  ProductList(Product model, int pos) {
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
                    child: model.thumbnail_image == null
                        ? Image.asset('assets/images/default_image_product.png',
                            fit: BoxFit.cover)
                        : CachedNetworkImage(
                            placeholder: placeholderWidgetFn(),
                            imageUrl: Constants.IMAGE_BASE_URL +
                                model.thumbnail_image,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.name,
                            style: TextStyle(
                                color: appStore.textPrimaryColor,
                                fontFamily: fontMedium),
                            overflow: TextOverflow.ellipsis,
                            // textColor: appStore.textPrimaryColor,
                            // fontFamily: fontMedium
                          ),
                        ],
                      ),
                      // text(model.discount_type,
                      //     textColor: appStore.textSecondaryColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              text(model.base_price.toString() + " " + "LE",
                                  textColor: appStore.textSecondaryColor),
/*
                              SizedBox(width: spacing_control),
                              text(model.base_price.toString(),
                                  textColor: appStore.textSecondaryColor,
                                  lineThrough: true),
*/
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
// you must sign in call to action added
