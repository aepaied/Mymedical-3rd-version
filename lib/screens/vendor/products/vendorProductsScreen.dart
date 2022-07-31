import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/screens/vendor/products/vendorProductsPresenter.dart';
import 'package:my_medical_app/widgets/ProductItemWidget.dart';
// import 'package:my_medical_app/widgets/VendorProductWidget.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class VendorProductsScreen extends StatefulWidget {
  String productsLink;

  VendorProductsScreen({this.productsLink});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VendorProductsScreenState();
  }
}

class VendorProductsScreenState extends State<VendorProductsScreen>
    implements VendorProductsCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;
  bool isLoadingMoreData = false;
  bool noProducts = true;
  VendorProductsPresenter presenter;

  String url = Constants.BASE_URL + 'vendors/products';

  List<Product> productsList = List();

  int current_page = 1;
  int last_page = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.productsLink != null) {
      url = widget.productsLink;
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (current_page < last_page) {
          current_page++;
          noProducts = false;
          presenter.getAllProductssData(url, current_page.toString());
        }
      }
    });

    if (presenter == null) {
      presenter = VendorProductsPresenter(context: context, callBack: this);
      noProducts = false;
      presenter.getAllProductssData(url, current_page.toString());
    }

    /*Helpers.isLoggedIn().then((_result) {
      setState(() {
        if (_result) {
          isLogged = true;
        } else {
          isLogged = false;
        }
      });
    });*/

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
      appBar: CustomAppBar(title: "vendor_screen",),
      body: Container(
        padding: EdgeInsets.all(SizeConfig.wUnit * 3),
        child: Column(
          children: [
            /*Padding(
                      padding: EdgeInsets.all(SizeConfig.wUnit * 3),
                      child: SearchBarWidget(),
                    ),*/

            Expanded(
              child: Container(
                child: Stack(
                  // alignment: Alignment(1, 1),
                  children: <Widget>[
                    ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: productsList.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          /*color: Theme.of(context).accentColor,*/
                          height: SizeConfig.vUnit,
                        );
                      },
                      itemBuilder: (context, index) {
                        double _marginLeft = 0;
                        (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
/*
                        return VendorProductWidget(
                          // heroTag: 'products_screen',
                          marginLeft: _marginLeft,
                          // productData: productsDataList[index],
                          product: productsList.elementAt(index),
                          onDelete: () {
                            presenter.deleteProduct(productsList[index].id);
                          },
                          onView: () {
                            Navigator.of(context).pushNamed('/ProductDetails',
                                arguments: productsList[index]);
                          },
                          onRefresh: () {
                            presenter.getAllProductssData(url, "1");
                          },
                        );
*/
                      },
                    ),
                    Visibility(
                      visible: noProducts,
                      child: Center(
                        child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate('there_are_no') +
                                " " +
                                AppLocalizations.of(context)
                                    .translate('products'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .merge(TextStyle(fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Visibility(
                        child: SpinKitChasingDots(
                          color: primaryColor,
                        ),
                        visible: isLoadingData,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        child: CircularProgressIndicator(),
                        visible: isLoadingMoreData,
                        // visible: true,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/AddVendorProduct').then((value) {
            presenter.getAllProductssData(url, "1");
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
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
  void onDataSuccess(List<ProductsData> data, Meta meta) {
    setState(() {
      current_page = meta.currentPage;
      last_page = meta.lastPage;

      if (data.length == 0) {
        noProducts = true;
      } else {
        noProducts = false;
      }

      if (last_page == 1) {
        productsList.clear();
      }
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
      }
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
  void onDeleteSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            )).then((value) {
      presenter.getAllProductssData(url, "1");
    });
  }
}
