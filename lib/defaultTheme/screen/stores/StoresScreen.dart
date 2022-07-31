import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/AllShopsModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme/screen/brands/brandsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/stores/StoresPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';

class StoresScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoresScreenState();
  }
}
//Stores api fixed
class StoresScreenState extends State<StoresScreen> implements StoresCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;
  StoresPresenter presenter;

  List<ShopData> shopsList = List();

  @override
  void initState() {
    super.initState();

    if (presenter == null) {
      presenter = StoresPresenter(context: context, callBack: this);
      presenter.loadAllStoresData();
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
        drawer: DrawerWidget(categoriesList: categoriesList,),
        appBar: CustomAppBar(title: "${translator.translate("stores")}",),
        body: isLoadingData
            ? SpinKitChasingDots(color: primaryColor,
              )
            : Container(
          color: Colors.white30,
          child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.all(3.0),
              mainAxisSpacing: 50.0,
              crossAxisSpacing: 3.0,
              children: shopsList.map((brand) {
                return GestureDetector(
                  onTap: (){
                    SearchFilter sortBy = SearchFilter(
                        key: "new_arrival",
                        value: translator.translate('new_arrival')
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return ProductsScreen(search:true,widgetSearchText: brand.name,widgetSelectedSearchFilter:SearchFilter(
                        key: "store",
                        value: "stores"
                      ), widgetSortByFilter: sortBy ,);
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
                            brand.logo == "" ?Image.asset("assets/images/default_image_store.png"):Image.network("${Constants.IMAGE_BASE_URL}${brand.logo}", fit: BoxFit.cover),
                            // Image.network("${Constants.IMAGE_BASE_URL}${brand.logo}", fit: BoxFit.cover),
                            Text("${brand.name}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),);
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
  void onDataSuccess(List<ShopData> data) {
    setState(() {
      shopsList.clear();
      shopsList.addAll(data);
    });
  }
}
