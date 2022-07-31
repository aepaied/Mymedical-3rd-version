import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/notification_controller.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignUp.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/social_media_widget.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/notificaion_delete_controller.dart';
import 'package:my_medical_app/theme3/utils/T3Images.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/theme3/utils/colors.dart';
import 'package:my_medical_app/theme3/utils/strings.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets//IMDismissibleScreen.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'auth/AuthPresenter.dart';

class NotificationScreen extends StatefulWidget {
  static String tag = '/NotificationScreen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    implements LoginCallBack {
  NotificationController _notificationController = Get.find();
  bool isLogged = false;
  bool isEmail = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  AuthPresenter authPresenter;

  bool isLoadingData = true;

  @override
  void initState() {
    if (authPresenter == null) {
      authPresenter = AuthPresenter(context: context, loginCallBack: this);
    }
    Helpers.isLoggedIn().then((value) {
      isLogged = value;
      setState(() {});
    });

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

  Widget generateItemsList() {
    return Container(
      child: Obx(
        () => ListView.builder(
          itemCount: _notificationController.notificationsList.length,
          itemBuilder: (context, index) {
            NotificationDeleteController notificationDeleteController =
                Get.isRegistered<NotificationDeleteController>()
                    ? Get.find()
                    : Get.put(NotificationDeleteController());
            return Dismissible(
              key: Key(_notificationController.notificationsList[index].id
                  .toString()),
              child: mDismissibleList(
                  _notificationController.notificationsList[index]),
              background: slideRightBackground(),
              secondaryBackground: slideLeftBackground(),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _notificationController.notificationsList.removeAt(index);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${translator.translate("notification_deleted")}")));
                } else if (direction == DismissDirection.endToStart) {
                  _notificationController.notificationsList.removeAt(index);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${translator.translate("notification_deleted")}")));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            20.width,
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Delete",
              style: primaryTextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: primaryTextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
            20.width,
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  //MM-48 : Function that exits the app
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${translator.translate("exit_app")}'),
            content: Text("${translator.translate('do_you_want_to_exit')}"),
            actions: [
              MaterialButton(
                  onPressed: () => Get.back(),
                  //MM-47 Change button color
                  child: Text(
                    '${translator.translate("no")}',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor),
              MaterialButton(
                  onPressed: () => SystemNavigator.pop(),
                  //return true when click on "Yes"
                  //MM-47 Change button color
                  child: Text(
                    '${translator.translate("yes")}',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    _notificationController.init();
    return WillPopScope(
      onWillPop: showExitPopup, //call function on back button press
      child: SafeArea(
        child: isLogged
            ? Obx(
                () => Scaffold(
                  backgroundColor: appStore.scaffoldBackground,
                  body: _notificationController.isLoadingData.value
                      ? SpinKitChasingDots(
                          color: primaryColor,
                        )
                      : generateItemsList(),
                ),
              )
            : Observer(
                builder: (_) => Container(
                  color: appStore.scaffoldBackground,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.height) / 3.5,
                          child: Stack(
                            children: <Widget>[
                              Image.asset(t3_ic_background,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(t3_lbl_welcome,
                                        style: boldTextStyle(
                                            size: 40, color: t3_white)),
                                    SizedBox(height: 4),
                                    Text(t3_lbl_back,
                                        style: boldTextStyle(
                                            size: 34, color: t3_white))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(right: 45),
                          transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                          child: Image.asset(t3_ic_icon, height: 70, width: 70),
                        ),
                        isEmail
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: T3AppButton(
                                  onPressed: () {
                                    isEmail = false;
                                    emailController.text = "";
                                    setState(() {});
                                  },
                                  textContent:
                                      "${translator.translate("sign_with_mobile")}",
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: T3AppButton(
                                  onPressed: () {
                                    isEmail = true;
                                    phoneController.text = "";
                                    setState(() {});
                                  },
                                  textContent:
                                      "${translator.translate("sign_with_email")}",
                                ),
                              ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(height: 16),
                        isEmail
                            ? t3EditTextField(t3_hint_Email, emailController,
                                isPassword: false)
                            : t3EditTextField(
                                "${translator.translate("phone")}",
                                phoneController,
                                isPassword: false),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(height: 16),
                        t3EditTextField(t3_hint_password, passwordController,
                            isPassword: true),
                        SizedBox(height: 14),
                        SizedBox(height: 14),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: T3AppButton(
                              textContent: t3_lbl_sign_in,
                              onPressed: () {
                                authPresenter.makeSignIn(
                                    emailController.text.toString().trim(),
                                    phoneController.text.toString().trim(),
                                    passwordController.text.toString().trim());
                              }),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${translator.translate("or_login_with_social")}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(height: 5),
                        SocialMediaWidget(
                          onGooglePressed: () {
                            makeGoogleSignIn();
                          },
                          onFaceBookPressed: () {
                            makeFacebookSignIn();
                          },
                        ),
                        Platform.isIOS
                            ? SignInWithAppleButton(
                                onPressed: () async {
                                  final credential = await SignInWithApple
                                      .getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );

                                  print(credential);

                                  // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                  // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                },
                              )
                            : Container(),
                        SizedBox(height: 20),
                        Text(t3_lbl_forgot_password,
                            style: secondaryTextStyle(size: 16)),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(t3_lbl_don_t_have_account,
                                style: primaryTextStyle()),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: GestureDetector(
                                  child: Text(t3_lbl_sign_up,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          decoration: TextDecoration.underline,
                                          color: t3_colorPrimary)),
                                  onTap: () {
                                    T3SignUp().launch(context);
                                  }),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(
                              top: 50, left: 16, right: 16, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image.asset(t3_ic_sign2,
                                      height: 50,
                                      width: 70,
                                      color: appStore.iconColor),
                                  Container(
                                    margin: EdgeInsets.only(top: 25, left: 10),
                                    child: Image.asset(t3_ic_sign4,
                                        height: 50,
                                        width: 70,
                                        color: appStore.iconColor),
                                  ),
                                ],
                              ),
                              Container(
                                child: Image.asset(t3_ic_sign1,
                                    height: 80,
                                    width: 80,
                                    color: appStore.iconColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> makeGoogleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) {
        authPresenter.makeSocialLogin(
            value.email, value.displayName, value.photoUrl);
      });
    } catch (error) {
      print(error.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomAlertDialog(
                errorText: error,
              ));
    }
  }

  makeFacebookSignIn() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken;
      authPresenter.getFacebookData(result.accessToken.token);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomAlertDialog(
                errorText: result.message,
              ));
      print(result.status);
      print(result.message);
    }
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
  void onDataSuccess(LoginModel data, bool isSocial) {
    setClientData(data, isSocial);
  }

  @override
  void onSocialDataSuccess(LoginModel data) {
    onDataSuccess(data, true);
  }

  setClientData(LoginModel data, bool isSocial) async {
    final box = GetStorage();
    box.write(Constants.token_type, data.tokenType);
    box.write(Constants.access_token, data.accessToken);
    box.write(Constants.expires_at, data.expiresAt);
    box.write(Constants.isSocial, isSocial);
    box.write(Constants.id, data.user.id.toString());
    box.write(Constants.type, data.user.type ?? "");
    box.write(Constants.type, data.user.type ?? "");
    box.write(Constants.name, data.user.name ?? "");
    box.write(Constants.email, data.user.email ?? "");
    box.write(Constants.avatar, data.user.avatar ?? "");
    box.write(Constants.avatar_original, data.user.avatarOriginal ?? "");
    box.write(Constants.phone, data.user.phone ?? "");
    box.write(Constants.IS_LOGGEDIN, true);

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(Constants.token_type, data.tokenType);
    // prefs.setString(Constants.access_token, data.accessToken);
    // prefs.setString(Constants.expires_at, data.expiresAt);
    // prefs.setBool(Constants.isSocial,isSocial );
    // prefs.setString(Constants.id, data.user.id.toString());
    // prefs.setString(Constants.type, data.user.type?? "");
    // prefs.setString(Constants.type, data.user.type?? "");
    // prefs.setString(Constants.name, data.user.name?? "");
    // prefs.setString(Constants.email, data.user.email?? "");
    // prefs.setString(Constants.avatar, data.user.avatar?? "");
    // prefs.setString(Constants.avatar_original, data.user.avatarOriginal??"");
    // prefs.setString(Constants.phone, data.user.phone ?? "");
/*
    prefs.setString(Constants.address, data.user.address);
    prefs.setString(Constants.country, data.user.country);
    prefs.setString(Constants.city, data.user.city);
    prefs.setString(Constants.postal_code, data.user.postalCode);
*/

    // prefs.setBool(Constants.IS_LOGGEDIN, true);

    // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ShSplashScreen();
    }));
  }

  @override
  void onErrorList(Map<String, dynamic> errors) {
    // TODO: implement onErrorList
  }

  @override
  void onRegisterErrors(onRegisterErrors) {
    // TODO: implement onRegisterErrors
  }

  @override
  void onEmailOTP(String text,int code) {
    // TODO: implement onEmailOTP
  }

  @override
  void onMobileOTP(String text,int code) {
    // TODO: implement onMobileOTP
  }
}
