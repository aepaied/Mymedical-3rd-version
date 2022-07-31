import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/notification_controller.dart';
import 'package:my_medical_app/controllers/showcase_controller.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/categories_list.dart';
import 'package:my_medical_app/defaultTheme/screen/favoritesScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/notificationScreen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/shopHop/models/ShCategory.dart';
import 'package:my_medical_app/shopHop/screens/ShCartFragment.dart';
import 'package:my_medical_app/shopHop/screens/ShHomeFragment.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShExtension.dart';
import 'package:my_medical_app/theme1/utils/T1Colors.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:showcaseview/showcaseview.dart';

import 'notifications/notificationsPresenter.dart';

class ShHomeScreen extends StatefulWidget {
  static String tag = '/ShHomeScreen';
  final int initCurrentTab;

  ShHomeScreen({this.initCurrentTab});

  @override
  ShHomeScreenState createState() => ShHomeScreenState();
}

class ShHomeScreenState extends State<ShHomeScreen> {
  var list = List<ShCategory>();
  var homeFragment = ShHomeFragment();
  var cartFragment = ShCartFragment();
  var categoriesFragment = CategoriesList();
  var profileFragment = T3SignIn();
  var favoriteFragment = FavoriteScreen();
  var notificationFragment = NotificationScreen();
  var fragments;
  var selectedTab = 0;
  var currentIndex = 0;
  String url = Constants.BASE_URL + 'products';
  NotificationsPresenter notificationsPresenter;

  bool isLoadingNotificationsCount = false;
  NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    _notificationController.init();
    if (widget.initCurrentTab != null) {
      currentIndex = widget.initCurrentTab;
      selectedTab = widget.initCurrentTab;
      setState(() {});
    }
    final box = GetStorage();
    box.write('1st_run', false);

    setState(() {});
    fragments = [
      homeFragment,
      categoriesFragment,
      favoriteFragment,
      profileFragment,
      notificationFragment
    ];
    fetchData();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      selectedTab = index;
    });
  }

  fetchData() async {
    loadCategory().then((categories) {
      setState(() {
        list.clear();
        list.addAll(categories);
      });
    }).catchError((error) {
      toast(error);
    });
  }

  Future<List<ShCategory>> loadCategory() async {
    String jsonString =
        await loadContentAsset('assets/shophop_data/category.json');
    final jsonResponse = json.decode(jsonString);
    return (jsonResponse as List).map((i) => ShCategory.fromJson(i)).toList();
  }

  ShowcaseController _showcaseController = Get.put(ShowcaseController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    var title = "${translator.translate("home")}";

    return ShowCaseWidget(
      onFinish: () {
        // _showcaseController.runThirdShowcase();
      },
      builder: Builder(
        builder: (context) {
          // _showcaseController.secondContext = context;
          return Obx(
            () => Scaffold(
              appBar: CustomAppBar(title: title),
              bottomNavigationBar: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: shadowColorGlobal,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 3.0)),
                      ],
                    ),
                    //done
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          tabItem(1, Icons.list_outlined),
                          tabItem(2, Icons.favorite),
                          Container(width: 45, height: 45),
                          tabItem(3, Icons.person),
                          Stack(
                            children: [
                              tabItem(4, Icons.notifications),
                              _notificationController.notificationCount.value >
                                      0
                                  ? CircleAvatar(
                                      backgroundColor: primaryColor,
                                      radius: 10,
                                      child: Text(
                                        "${_notificationController.notificationCount.value}",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  : Positioned(top: 10, child: Container())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: FloatingActionButton(
                      backgroundColor: sh_colorPrimary,
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ShHomeScreen();
                        }));
                      },
                      child: Icon(Icons.home, color: t1_white),
                    ),
                  )
                ],
              ),
              body: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  fragments[selectedTab],
                  Container(
                    height: 58,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[],
                    ),
                  )
                ],
              ),
              drawer: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height,
                child: DrawerWidget(
                  categoriesList: categoriesList,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getDrawerItem(String icon, String name, {VoidCallback callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        color: sh_white,
        padding: EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          children: <Widget>[
            icon != null
                ? Image.asset(icon, width: 20, height: 20)
                : Container(width: 20),
            SizedBox(width: 20),
            text(name,
                textColor: sh_textColorPrimary,
                fontSize: textSizeMedium,
                fontFamily: fontMedium)
          ],
        ),
      ),
    );
  }

  Widget tabItem(var pos, IconData icon) {
    return GestureDetector(
      onTap: () {
        selectedTab = pos;
        setState(() {});
      },
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: selectedTab == pos
            ? BoxDecoration(
                shape: BoxShape.circle, color: sh_colorPrimary.withOpacity(0.2))
            : BoxDecoration(),
        child: Icon(icon,
            color:
                selectedTab == pos ? sh_colorPrimary : sh_textColorSecondary),
      ),
    );
  }

  @override
  void onAllDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    isLoadingNotificationsCount = show;
    setState(() {});
  }
}
