import 'package:flutter/material.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/myPackageModel.dart';
import 'package:my_medical_app/data/remote/models/productsModel.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme/screen/adds_products/addsProductsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/ProductItemWidget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/mustLogin.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class MyAdvsProductsScreen extends StatefulWidget {
  String productsLink;

  MyAdvsProductsScreen({this.productsLink});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAdvsProductsScreenState();
  }
}

class MyAdvsProductsScreenState extends State<MyAdvsProductsScreen>
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
  List<Product> productsList = List();
  List<AddsProductsData> productsDataList = List();

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
      presenter.getMyPackages();
      presenter.getMyAdvs();
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
      appBar: AppBar(
        title: Text("Ads"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/AddAddsProduct').then((value) {
            presenter.getMyAdvs();
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
  void onDataSuccess(List<AddsProductsData> data) {
    setState(() {
      if (data.length == 0) {
        noProducts = true;
      } else {
        noProducts = false;
      }

      if (last_page == 1) {
        productsList.clear();
      }
      productsDataList.clear();
      productsDataList.addAll(data);
      for (AddsProductsData p in data) {
        productsList.add(Product(
            p.id,
            Constants.LANG == "en" ? p.name : p.name,
            p.photos,
            p.thumbnailImg,
            double.parse(p.unitPrice.toString()),
            double.parse(p.unitPrice.toString()),
            0,
            0,
            p.unit,
            Constants.LANG == "en" ? p.tagsEn : p.tagsAr,
            "",
            p.unitDiscount == null ? 0 : p.unitDiscount,
            "amount",
            "",
            p.conditon,
            0,
            "",
            p.country,
            "",
            "",
            "",
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
  void onMyPackagesDataSuccess(MyPackageData data) {
    if (data != null) {
      setState(() {
        myPackageData = data;
      });
    }
  }

  @override
  void onDeleteSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            )).then((value) {
      presenter.getMyAdvs();
    });
  }
}
