import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/productDetailsModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/data/remote/models/viewAdvsProductModel.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/defaultTheme/screen/adds_products/addsProductsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/wishlist/wishListPresenter.dart';

import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class AdvsproductDetailsScreen extends StatefulWidget {
  AddsProductsData product;

  AdvsproductDetailsScreen({this.product});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AdvsproductDetailsScreenState();
  }
}

class AdvsproductDetailsScreenState extends State<AdvsproductDetailsScreen>
    with SingleTickerProviderStateMixin
    implements ViewProductCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  bool isLoadingData = false;
  bool isLoadingRelatedProduct = false;
  bool isLoadingFavorateData = false;
  bool isFavorate = false;
  TabController _tabController;
  int _tabIndex = 0;

  ViewAdvsProductData productDetailsData;
  AddsProductsPresenter presenter;

  @override
  void initState() {
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);

    super.initState();

    if (presenter == null) {
      presenter =
          AddsProductsPresenter(context: context, viewProductCallBack: this);
      presenter.viewProduct(widget.product.id);
    }

    Helpers.isLoggedIn().then((_result) {
      setState(() {
        if (_result) {
          isLogged = true;
        } else {
          isLogged = false;
        }
      });
    });
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: DrawerWidget(),
      /*appBar: MyAppBar(
        scaffoldKey: _scaffoldKey,
        // title: AppLocalizations.of(context).translate('brands'),
        isLogged: isLogged,
      ),*/
      body: isLoadingData
          ? SpinKitChasingDots(
        color: primaryColor,
            )
          : Container()
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onViewProductDataSuccess(ViewAdvsProductData data) {
    setState(() {
      productDetailsData = data;
    });
  }
}
