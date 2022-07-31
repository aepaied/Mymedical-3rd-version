import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mobx/mobx.dart';
import 'package:my_medical_app/controllers/image_upload_controller.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/AuthPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/inner_pages.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_orders_screen.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/account_info.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/my_addresses.dart';
import 'package:my_medical_app/defaultTheme/screen/wallet/wallet_screen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppColors.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/image_upload_dialog.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'DTSecurityScreen.dart';
import 'profile/update_profile_presenetr.dart';

class DTProfileScreen extends StatefulWidget {
  static String tag = '/DTProfileScreen';

  @override
  DTProfileScreenState createState() => DTProfileScreenState();
}

class DTProfileScreenState extends State<DTProfileScreen>
    implements LogoutCallBack, UpdateAvatarCallBack {
  User currentUser;

  AuthPresenter presenter;
  UpdatePresenter upDatePresenter;
  bool isLoadingData = false;
  ImageUploadController _imageUploadController =
      Get.put(ImageUploadController());

  Future gettingUserDetails() async {
    currentUser = await Helpers.getUserData();
    setState(() {});
  }

  bool isSocial = false;

  getSocial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSocial = prefs.getBool("is_social");
    setState(() {});
  }

  @override
  void initState() {
    gettingUserDetails();
    getSocial();
    if (presenter == null) {
      presenter = AuthPresenter(context: context, logoutCallBack: this);
    }
    if (upDatePresenter == null) {
      upDatePresenter =
          UpdatePresenter(context: context, updateAvatarCallBack: this);
    }

    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  updateProfile(String avatar) {
    upDatePresenter.updateAvatar(currentUser.name, currentUser.email, avatar);
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Widget profileView() {
      return isLoadingData
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final ImageUploadController imageUploadC =
                            Get.put(ImageUploadController());
                        imageUploadC.currentUser = currentUser;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              ImageUploadDialog(type: "profile"),
                        );
                      },
                      child: currentUser.avatar == "" ||
                              currentUser.avatar == null
                          ? currentUser.avatarOriginal == "" ||
                                  currentUser.avatarOriginal == null
                              ? Image.asset("assets/images/user.jpg",
                                  height: 70, width: 70, fit: BoxFit.cover)
                              : Image.network(
                                      '${Constants.IMAGE_BASE_URL}${currentUser.avatarOriginal}',
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(40)
                          : Image.network(
                              '${Constants.IMAGE_BASE_URL}${currentUser.avatar}',
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover),
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${currentUser.name}", style: primaryTextStyle()),
                        2.height,
                        Text("${currentUser.email}", style: primaryTextStyle()),
                      ],
                    )
                  ],
                ),
                IconButton(
                  icon:
                      Icon(AntDesign.edit, color: appStore.iconSecondaryColor),
                  onPressed: () {},
                ).visible(false)
              ],
            ).paddingAll(16);
    }

    @computed
    Widget options() {
      BusinessSettingController businessSettingController = Get.find();
      return Column(
        children: [
          settingItem(context, '${translator.translate("account_info")}',
              onTap: () {
            AccountInfo().launch(context);
          }, leading: Icon(MaterialIcons.list), detail: SizedBox()),
          settingItem(context, 'Security', onTap: () {
            DTSecurityScreen().launch(context);
          },
              leading: Icon(MaterialCommunityIcons.shield_check_outline),
              detail: SizedBox()),
          Divider(
            thickness: 3,
          ),
          settingItem(context, '${translator.translate("addresses")}',
              onTap: () {
            MyAddresses(
              isWidget: false,
            ).launch(context);
          }, leading: Icon(MaterialIcons.credit_card), detail: SizedBox()),
          businessSettingController.currentBusinessSettings.value.details
                      .where((element) => element.type == "wallet_system")
                      .toList()[0]
                      .value ==
                  "1"
              ? settingItem(context, '${translator.translate("wallet")}',
                  onTap: () {
                  WalletScreen().launch(context);
                },
                  leading: Icon(Icons.account_balance_wallet_outlined),
                  detail: SizedBox())
              : Container(),
          settingItem(context, '${translator.translate("my_orders")}',
              onTap: () {
            MyOrdersScreen().launch(context);
          }, leading: Icon(Icons.shopping_cart_outlined), detail: SizedBox()),
          Divider(
            thickness: 3,
          ),
          settingItem(context, '${translator.translate("help")}', onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return InnerPage(pageId: 24);
            }));
          }, leading: Icon(MaterialIcons.help_outline), detail: SizedBox()),
          settingItem(context, '${translator.translate("about")}', onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return InnerPage(pageId: 8);
            }));
          }, leading: Icon(MaterialIcons.info_outline), detail: SizedBox()),
          settingItem(context, '${translator.translate("change_language")}',
              onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    height: 180,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${translator.translate("change_language")}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: () {
                            translator.setNewLanguage(
                              context,
                              newLanguage: 'ar',
                              remember: true,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.language),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${translator.translate("arabic")}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            translator.setNewLanguage(
                              context,
                              newLanguage: 'en',
                              remember: true,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${translator.translate("english")}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }, leading: Icon(MaterialIcons.info_outline), detail: SizedBox()),
          settingItem(context, 'Log Out', onTap: () {
            Get.defaultDialog(
                title: "${translator.translate("logout")}",
                middleText: "${translator.translate("sure_logout")}",
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("${translator.translate("cancel")}"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      presenter.makeLogout();
                    },
                    child: Text("${translator.translate("logout")}"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                  ),
                ]);

/*
            showDialog(context: context, builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Logout?',
                  style: boldTextStyle(
                      color: appStore.textPrimaryColor, size: 18),
                ),
                content: Text(
                  'Are you sure want to logout?',
                  style: secondaryTextStyle(
                      color: appStore.textPrimaryColor, size: 16),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: primaryTextStyle(color: dodgerBlue, size: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      'Logout',
                      style: primaryTextStyle(color: redColor, size: 18),
                    ),
                    onPressed: () {
                      presenter.makeLogout();
                    },
                  )
                ],
              );
            },);
*/
            //
          }, detail: SizedBox(), textColor: appColorPrimary),
        ],
      );
    }

    return Scaffold(
      // appBar: CustomAppBar(title: '${translator.translate("profile")}',),
      body: ContainerX(
        mobile: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            children: [
              profileView(),
              Divider(color: appDividerColor, height: 8)
                  .paddingOnly(top: 4, bottom: 4),
              options(),
            ],
          ),
        ),
        web: Column(
          children: [
            profileView(),
            Divider(height: 8).paddingOnly(top: 4, bottom: 4),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: options(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  doLogout() {}

  @override
  void onLogoutDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onLogoutDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
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

  @override
  void onUpdateAvatarError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onUpdateAvatarLoading(bool show) {
    isLoadingData = show;
    setState(() {});
  }

  @override
  void onUpdateAvatarSuccess(String newAvatar) {
    currentUser.avatar = newAvatar;
    setState(() {});
    print(currentUser.avatar);
  }
}
