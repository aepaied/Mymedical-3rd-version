import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';
import 'package:my_medical_app/data/remote/models/StaticPagesListModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/on_boarding.dart';
import 'package:my_medical_app/defaultTheme/screen/staticPagesPresenter.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/services/notification_services.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShImages.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:nb_utils/nb_utils.dart';

class ShSplashScreen extends StatefulWidget {
  static String tag = '/ShophopSplash';

  @override
  ShSplashScreenState createState() => ShSplashScreenState();
}

class ShSplashScreenState extends State<ShSplashScreen>
    implements AllStaticPagesCallBack {
  StaticPagesPresenter staticPagesPresenter;

  bool showOnBoarding() {
    final box = GetStorage();
    return box.read('1st_run') != null ? box.read('1st_run') : true;
  }

  BusinessSettingController systemSettingController =
      Get.put(BusinessSettingController());

  @override
  void initState() {
    super.initState();
    subToNotificationTopic();
    if (staticPagesPresenter == null) {
      staticPagesPresenter =
          StaticPagesPresenter(context: context, allStaticPagesCallBack: this);
    }
    staticPagesPresenter.getAllPages();
  }

  void subToNotificationTopic() {
    if (translator.activeLanguageCode == "ar") {
      NotificationServices().enToAr();
    } else {
      NotificationServices().arToEn();
    }
  }

  goToNextPage() async {
    navigationPage();
  }

  void navigationPage() {
    finish(context);
    // ShWalkThroughScreen().launch(context);
    print(showOnBoarding());
    showOnBoarding()
        ? OnBoarding().launch(context)
        : ShHomeScreen().launch(context);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.black);
    var width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: width + width * 0.4,
        child: Stack(
          children: <Widget>[
            Image.asset(splash_bg,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover),
            Positioned(
              top: -width * 0.2,
              left: -width * 0.2,
              child: Container(
                width: width * 0.65,
                height: width * 0.65,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sh_colorPrimary.withOpacity(0.3)),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(ic_app_icon, width: width * 0.3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("My",
                          style: boldTextStyle(
                              color: sh_textColorPrimary,
                              size: 35,
                              fontFamily: 'Bold')),
                      Text("Medical",
                          style: boldTextStyle(
                              color: sh_colorPrimary,
                              size: 35,
                              fontFamily: 'Bold')),
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: -width * 0.2,
                    right: -width * 0.2,
                    child: Container(
                      width: width * 0.65,
                      height: width * 0.65,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sh_colorPrimary.withOpacity(0.3)),
                    ),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(splash_img,
                    width: width * 0.5, height: width * 0.5))
          ],
        ),
      ),
    );
  }

  @override
  void onDataError(String message) {
    staticPagesPresenter.getAllPages();
  }

  @override
  void onDataLoading(bool show) {
    // TODO: implement onDataLoading
  }

  @override
  void onDataSuccess(List<CategoriesData> data) {
    Constants.drawerCategoriesList.clear();
    Constants.drawerCategoriesList.addAll(data);
    staticPagesPresenter.getAllPages();
  }

  @override
  void onAllPagesDataSuccess(List<PageData> data) {
    Constants.drawerStaticPagesList.clear();
    Constants.drawerStaticPagesList.addAll(data);
    goToNextPage();
    /*if(notificationsPresenter != null){
      notificationsPresenter.loadNotificationsCount();
    } else{
      loadData();
    }*/
    // loadData();
  }

  @override
  void onAllDataError(String message) {}
}
