import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/myPackageModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/DTWidgets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/shopHop/utils/ShImages.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme//screen/adds_products/addsProductsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsPresenter.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/ProductItemWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/mustLogin.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:nb_utils/nb_utils.dart';

class AllAdvsProductsScreen extends StatefulWidget {
  String productsLink;

  AllAdvsProductsScreen({this.productsLink});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllAdvsProductsScreenState();
  }
}

class AllAdvsProductsScreenState extends State<AllAdvsProductsScreen>
    implements AddsProductsCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;
  bool isLoadingMoreData = false;
  bool noProducts = true;
  AddsProductsPresenter presenter;

  String url = Constants.BASE_URL + 'products';
  MyPackageData myPackageData = null;
  List<AddsProductsData> productsList = List();

  int current_page = 1;
  int last_page = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.productsLink != null) {
      url = widget.productsLink;
    }

    if (presenter == null) {
      presenter = AddsProductsPresenter(context: context, callBack: this);
      noProducts = false;
      // presenter.getMyPackages();
      presenter.getAllAdvs();
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
      drawer: DrawerWidget(
        categoriesList: categoriesList,
      ),
      appBar: CustomAppBar(
        title: "classified_ads",
      ),
      body: isLoadingData
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              children: productsList.map((data) {
                return Container(
                  decoration: boxDecorationRoundedWithShadow(8,
                      backgroundColor: Colors.white),
                  margin: EdgeInsets.all(8),
                  height: 250,
                  width: 200,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        print(data.name);
                        return ShProductDetail(
                          is_ad: true,
                          productID: data.id,
                        );
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 16,
                              color: Colors.green,
                              child: Center(
                                  child: Text(
                                "${data.conditon}",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ],
                        ),
                        Container(
                          child: Stack(
                            children: [
                              data.thumbnailImg == null ||
                                      data.thumbnailImg == ""
                                  ? Image.asset(
                                      "assets/images/default_image_store.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.236,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.236,
                                    )
                                  : Image.network(
                                      "${Constants.IMAGE_BASE_URL}${data.thumbnailImg}",
                                      fit: BoxFit.cover,
                                      // height: isMobile ? 110 : 180,
                                      width: MediaQuery.of(context).size.width *
                                          0.236,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.236,
                                    ).cornerRadiusWithClipRRect(8),
/*
                        Positioned(
                          right: 10,
                          top: 10,
                          child: data..validate() ? Icon(Icons.favorite, color: Colors.red, size: 16) : Icon(Icons.favorite_border, size: 16),
                          // child: Icon(Icons.favorite, color: Colors.red, size: 16) : Icon(Icons.favorite_border, size: 16),
                        ),
*/
                            ],
                          ),
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.name,
                                style: primaryTextStyle(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            4.height,
/*
                      Row(
                        children: [
                          RatingBar(
                            onRatingChanged: (r) {},
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            initialRating: data.,
                            maxRating: 5,
                            filledColor: Colors.yellow,
                            size: 14,
                          ),
                          5.width,
                          Text('${data.rating}', style: secondaryTextStyle(size: 12)),
                        ],
                      ),
*/
                            4.height,
                            Row(
                              children: [
                                priceWidget(
                                    double.parse(data.unitPrice.toString())),
                                8.width,
                                priceWidget(
                                    double.parse(data.unitPrice.toString()),
                                    applyStrike: true),
                              ],
                            ),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  ),
                ).onTap(() async {
/*
            int index = await DTProductDetailScreen(productModel: data).launch(context);
            if (index != null) appStore.setDrawerItemIndex(index);
*/
                });
              }).toList(),
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

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onDataSuccess(List<AddsProductsData> data) {
    setState(() {
      if (data.length == 0) {
        noProducts = true;
      } else {
        noProducts = false;
      }

      if (last_page == 1) {
        productsList.clear();
        productsList.addAll(data);
      }
      /* for (AddsProductsData p in data) {
        productsList.add(Product(
            p.id,
            Constants.LANG == "en" ? p.nameEn : p.nameAr,
            p.photos,
            p.thumbnailImg,
            p.unitPrice,
            p.unitPrice,
            0,
            0,
            p.unit,
            Constants.LANG == "en" ? p.tagsEn : p.tagsAr,
            "",
            0,
            "amount",
            "",
            p.conditon,
            0,
            "",
            "",
            "",
            ""));
      }*/
    });
  }

  @override
  void onMoreDataLoading(bool show) {
    setState(() {
      // _loadingSearch = show;
      isLoadingMoreData = show;
    });
  }

  @override
  void onMyPackagesDataSuccess(MyPackageData data) {
    if (data != null) {
      setState(() {
        myPackageData = data;
      });
    }
  }

  @override
  void onDeleteSuccess(String message) {
    // TODO: implement onDeleteSuccess
  }
}
