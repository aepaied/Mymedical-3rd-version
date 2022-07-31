import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme/screen/brands/brandsPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';

class BrandsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BrandsScreenState();
  }
}

class BrandsScreenState extends State<BrandsScreen> implements BrandsCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;
  BrandsPresenter presenter;

  List<BrandsData> brandsList = List();

  @override
  void initState() {
    super.initState();

    if (presenter == null) {
      presenter = BrandsPresenter(context: context, brandsCallBack: this);
      presenter.getAllBrandsData();
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
        drawer: DrawerWidget(categoriesList: categoriesList,),
        appBar: CustomAppBar(
          title: "${translator.translate("brands")}"),
        body: isLoadingData
            ? SpinKitChasingDots(
          color: Colors.blue,
        )
            : Container(
          color: Colors.white30,
          child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.all(3.0),
              mainAxisSpacing: 50.0,
              crossAxisSpacing: 3.0,
              children: brandsList.map((brand) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      SearchFilter searchFilter = SearchFilter(
                          key: "brand",
                          value: translator.translate('filter_brands')
                      );
                      SearchFilter sortBy = SearchFilter(
                          key: "new_arrival",
                          value: translator.translate('new_arrival')
                      );
                      return ProductsScreen(search: true,widgetSelectedSearchFilter: searchFilter,widgetSortByFilter: sortBy,widgetSearchText: brand.name,);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Text("${brand.logo}"),
                            brand.logo == "" ?Image.asset("assets/images/default_image_store.png"):Image.network("${Constants.IMAGE_BASE_URL}${brand.logo}", fit: BoxFit.cover),
                            Text("${brand.name}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),

    );
  }

  @override
  void onBrandDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message,
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
      brandsList.addAll(data);
    });
  }
}
