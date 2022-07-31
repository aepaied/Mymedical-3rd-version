import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/StaticPagesListModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/adds_products/allAdvsProductsScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/AuthPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/brands/brandsScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/inner_pages.dart';
import 'package:my_medical_app/defaultTheme/screen/my_ads/my_ads_screen.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_orders_screen.dart';
import 'package:my_medical_app/defaultTheme/screen/products/productsScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/stores/StoresScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/support_tickets.dart';
import 'package:my_medical_app/defaultTheme/screen/wallet/wallet_screen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/screens/vendor/sellerDashboard.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/shopHop/utils/ShImages.dart';
import 'package:my_medical_app/ui/models/SearchFilter.dart';
import 'package:my_medical_app/ui/models/category.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

class DrawerWidget extends StatefulWidget {
  final List<Category> categoriesList;

  DrawerWidget({Key key, @required this.categoriesList}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> implements LogoutCallBack {
  List<Widget> categories = List();
  List<Widget> staticPages = List();
  AuthPresenter presenter;
  String username;
  BusinessSettingController businessSettingController = Get.find();
  loadCategories() {
    // color: Theme.of(context).focusColor.withOpacity(0.3),
    categories.clear();
    for (Category cat in categoriesList) {
      categories.add(
        ListTile(
          onTap: () {
            SearchFilter sortBy = SearchFilter(
                key: "new_arrival", value: translator.translate('new_arrival'));

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductsScreen(
                          search: true,
                          widgetSearchText: "${cat.name}",
                          widgetSelectedSearchFilter: (SearchFilter(
                              key: "category",
                              value: translator.translate('categories'))),
                          widgetSortByFilter: sortBy,
                        )));
          },
          leading: Image.network(Constants.IMAGE_BASE_URL + cat.icon,
              width: 30, height: 30),
          title: Text(
            cat.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
    }
  }

  loadStaticPages() {
    // color: Theme.of(context).focusColor.withOpacity(0.3),
    staticPages.clear();
    setState(() {
      for (PageData c in Constants.drawerStaticPagesList) {
        staticPages.add(ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return InnerPage(
                pageId: c.id,
              );
            }));
          },
          leading: c.icon == null
              ? Icon(
                  Icons.account_balance_outlined,
                  color: Theme.of(context).focusColor.withOpacity(1),
                )
              : Image.network(
                  Constants.IMAGE_BASE_URL + c.icon,
                  width: 30,
                  height: 30,
                ),
          title: Text(
            c.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ));
      }
    });
  }

  Future getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("name") == null
        ? "Guest User"
        : prefs.getString("name");
    setState(() {});
  }

  bool _isLoggedIn = false;
  User user;
  bool isLoadingData = false;

  String _projectVersion = '';
  String name = '';
  String email = '';
  String personalImage = "";
  bool isSocial = false;

  getSocial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSocial = prefs.getBool("is_social");
    setState(() {});
  }

  @override
  void initState() {
    getSocial();
    getUserName();
    if (presenter == null) {
      presenter = AuthPresenter(context: context, logoutCallBack: this);
    }
    Helpers.getUserData().then((_user) {
      setState(() {
        user = _user;
        name = _user.name;
        email = _user.email;
        _isLoggedIn = _user.isLoggedIn;
        if (_user.avatar != null) {
          // personalImage = Constants.IMAGE_BASE_URL + _user.avatar;
          personalImage = _user.avatar;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadStaticPages();
    loadCategories();
    return Drawer(
      elevation: 8,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: sh_white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 60, right: spacing_large),
                        child: !_isLoggedIn
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return T3SignIn();
                                  }));
                                },
                                child: Text("Click To Login"))
                            : Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: user.avatar == "" ||
                                            user.avatar == null
                                        ? user.avatarOriginal == "" ||
                                                user.avatarOriginal == null
                                            ? Image.asset(
                                                "assets/images/user.jpg",
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover)
                                            : Image.network(
                                                    '${Constants.IMAGE_BASE_URL}${user.avatarOriginal}',
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.cover)
                                                .cornerRadiusWithClipRRect(40)
                                        : Image.network(
                                            '${Constants.IMAGE_BASE_URL}${user.avatar}',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover),
                                    /*CircleAvatar(
                                    backgroundImage:user.avatar != null ?NetworkImage(isSocial ? "${user.avatar}":"${user.avatar}"):AssetImage(ic_user),
                                    radius: 25),*/
                                  ),
                                  SizedBox(height: spacing_middle),
                                  text("${user.name} ",
                                      textColor: sh_textColorPrimary,
                                      fontFamily: fontBold,
                                      fontSize: textSizeNormal),
                                  !_isLoggedIn
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            Get.defaultDialog(
                                                title:
                                                    "${translator.translate("logout")}",
                                                middleText:
                                                    "${translator.translate("sure_logout")}",
                                                actions: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    primaryColor)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                        "${translator.translate("cancel")}"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      presenter.makeLogout();
                                                    },
                                                    child: Text(
                                                        "${translator.translate("logout")}"),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .red)),
                                                  ),
                                                ]);

/*
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        'Logout?',
                                        style: boldTextStyle(
                                            color: appStore.textPrimaryColor,
                                            size: 18),
                                      ),
                                      content: Text(
                                        'Are you sure want to logout?',
                                        style: secondaryTextStyle(
                                            color: appStore.textPrimaryColor,
                                            size: 16),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                            'Cancel',
                                            style: primaryTextStyle(
                                                color: dodgerBlue, size: 18),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text(
                                            'Logout',
                                            style: primaryTextStyle(
                                                color: redColor, size: 18),
                                          ),
                                          onPressed: () {
                                            presenter.makeLogout();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
*/
                                          },
                                          child: Text(
                                            "Logout",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12),
                                          ),
                                        )
                                ],
                              )),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: spacing_standard_new, top: 30),
                          child: Icon(Icons.clear)))
                ],
              ),
              SizedBox(height: 30),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ShHomeScreen();
                  }));
                },
                // leading: Icon(
                //   UiIcons.home,
                //   color: Theme
                //       .of(context)
                //       .focusColor
                //       .withOpacity(1),
                // ),
                leading: Image(
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_home.png'),
                ),
                title: Text(
                  'home',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              // ShSettingsScreen().launch(context);
              Visibility(
                visible: _isLoggedIn,
                child: Visibility(
                  visible: (user != null
                      ? (user.type == 'seller' ? true : false)
                      : false),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return SellerDashboard();
                      }));
                    },
                    // leading: Icon(
                    //   // UiIcons.planet_earth,
                    //   UiIcons.laptop,
                    //   color: Theme
                    //       .of(context)
                    //       .focusColor
                    //       .withOpacity(1),
                    // ),
                    leading: Image(
                      width: 25,
                      height: 25,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/icons/ic_dashboard.png'),
                    ),
                    title: Text(
                      'dashBoard',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),

              ListTile(
                dense: true,
                title: Text(
                  'categories',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Theme.of(context).focusColor.withOpacity(0.3),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ShHomeScreen(
                      initCurrentTab: 1,
                    );
                  }));
                  // Navigator.of(context).pushNamed('/Pages', arguments: 3);
                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  //   return CategoriesList();
                  // }));
                },
                leading: Icon(
                  Icons.folder,
                  color: sh_colorPrimary.withOpacity(0.5),
                ),
                title: Text(
                  "${translator.translate("all_categories")}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),

              Column(
                children: categories,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'products',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Theme.of(context).focusColor.withOpacity(0.3),
                ),
              ),
              ListTile(
                onTap: () {
                  SearchFilter sortBy = SearchFilter(
                      key: "new_arrival",
                      value: translator.translate('new_arrival'));
                  // Navigator.of(context).pushNamed('/Products');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ProductsScreen(
                      search: false,
                      widgetSortByFilter: sortBy,
                    );
                  }));
                },
                // leading: Icon(
                //   UiIcons.folder_1,
                //   color: Theme
                //       .of(context)
                //       .focusColor
                //       .withOpacity(1),
                // ),
                leading: Image(
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_products.png'),
                ),
                title: Text(
                  "products",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return AllAdvsProductsScreen();
                  }));
                  // Navigator.of(context).pushNamed('/AllAdvsProducts');
                },
                // leading: SvgPicture.asset("assets/icons/ic_advs.svg",
                //     semanticsLabel: "ic_advs",
                //     color: Theme
                //         .of(context)
                //         .focusColor
                //         .withOpacity(1),
                //     width: SizeConfig.wUnit * 8,
                //     height: SizeConfig.wUnit * 8),
                leading: Image(
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_advs.png'),
                ),
                title: Text(
                  "classified_ads",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return BrandsScreen();
                  }));
                },
                // leading: Icon(
                //   UiIcons.folder_1,
                //   color: Theme
                //       .of(context)
                //       .focusColor
                //       .withOpacity(1),
                // ),
                leading: Image(
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_brands.png'),
                ),
                title: Text(
                  "filter_brands",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pushNamed('/Stores');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return StoresScreen();
                  }));
                },
                // leading: SvgPicture.asset("assets/icons/ic_shop.svg",
                //     semanticsLabel: "ic_shop",
                //     color: Theme
                //         .of(context)
                //         .focusColor
                //         .withOpacity(1),
                //     width: SizeConfig.wUnit * 8,
                //     height: SizeConfig.wUnit * 8),
                leading: Image(
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_stores.png'),
                ),
                title: Text(
                  "stores",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  "help",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Theme.of(context).focusColor.withOpacity(0.3),
                ),
              ),
              ListTile(
                onTap: () {
                  if (Get.locale.languageCode == "en") {
                    translator.setNewLanguage(
                      context,
                      newLanguage: 'ar',
                      remember: true,
                    );
                  } else {
                    translator.setNewLanguage(
                      context,
                      newLanguage: 'en',
                      remember: true,
                    );
                  }
                },
                leading: Image(
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_language.png'),
                ),
                title: Text(
                  "changeLanguage",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Column(
                children: staticPages,
              ),
              Divider(),
              !_isLoggedIn
                  ? Container()
                  : ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MyOrdersScreen();
                        }));
                      },
                      // leading: Icon(
                      //   UiIcons.planet_earth,
                      //   color: Theme
                      //       .of(context)
                      //       .focusColor
                      //       .withOpacity(1),
                      // ),
                      leading: Image(
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/icons/ic_myorders.png'),
                      ),
                      title: Text(
                        "${translator.translate("my_orders")}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
              !_isLoggedIn
                  ? Container()
                  : ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MyAdsScreen();
                        }));
                      },
                      // leading: Icon(
                      //   UiIcons.planet_earth,
                      //   color: Theme
                      //       .of(context)
                      //       .focusColor
                      //       .withOpacity(1),
                      // ),
                      leading: Image(
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/icons/ic_advs.png'),
                      ),
                      title: Text(
                        "${translator.translate("my_ads")}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
              !_isLoggedIn
                  ? Container()
                  : businessSettingController
                              .currentBusinessSettings.value.details
                              .where(
                                  (element) => element.type == "wallet_system")
                              .toList()[0]
                              .value ==
                          "1"
                      ? ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return WalletScreen();
                            }));
                          },
                          // leading: Icon(
                          //   UiIcons.planet_earth,
                          //   color: Theme
                          //       .of(context)
                          //       .focusColor
                          //       .withOpacity(1),
                          // ),
                          leading: Image(
                            width: 25,
                            height: 25,
                            fit: BoxFit.fill,
                            image: AssetImage('assets/icons/ic_mywallet.png'),
                          ),
                          title: Text(
                            "${translator.translate("my_wallet")}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        )
                      : Container(),
              !_isLoggedIn
                  ? Container()
                  : ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SupportTickets();
                        }));
                      },
                      // leading: Icon(
                      //   UiIcons.planet_earth,
                      //   color: Theme
                      //       .of(context)
                      //       .focusColor
                      //       .withOpacity(1),
                      // ),
                      leading: Image(
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/icons/ic_supporttickets.png'),
                      ),
                      title: Text(
                        "${translator.translate("support_tickets")}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),

              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  share();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.share, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Share and invite", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sh_colorPrimary.withOpacity(0.2)),
                padding: EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    Image.asset(ic_app_icon, width: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        text("My",
                            textColor: sh_textColorPrimary,
                            fontSize: textSizeMedium,
                            fontFamily: fontBold),
                        text("Medical",
                            textColor: sh_colorPrimary,
                            fontSize: textSizeMedium,
                            fontFamily: fontBold),
                      ],
                    ),
                    text("v 1.0",
                        textColor: sh_textColorPrimary, fontSize: textSizeSmall)
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'My Medical',
        text: 'My Medical',
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.mymedical.mymedical',
        chooserTitle: 'My Medical Application');
  }

  Widget getDrawerItem(String icon, bool network, String name,
      {VoidCallback callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        color: sh_white,
        padding: EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          children: <Widget>[
            icon != null
                ? network
                    ? Image.network(icon, width: 20, height: 20)
                    : Image.asset(icon, width: 20, height: 20)
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

  @override
  void onLogoutDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onLogoutDataLoading(bool show) {
    setState(() {});
  }

  @override
  void onLogoutDataSuccess(String message) {
    Helpers.logout().then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ShSplashScreen();
      }));
    });
  }
}
