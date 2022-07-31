import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/otp_controller.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/AuthPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/social_media_widget.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppConstant.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/otp/otp_email_widget.dart';
import 'package:my_medical_app/widgets/otp/otp_widget.dart';
import 'package:my_medical_app/widgets/otp_widget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/theme3/utils/T3Images.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/theme3/utils/colors.dart';
import 'package:my_medical_app/theme3/utils/strings.dart';

import 'package:my_medical_app/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class T3SignUp extends StatefulWidget {
  static var tag = "/T3SignUp";

  @override
  T3SignUpState createState() => T3SignUpState();
}

class T3SignUpState extends State<T3SignUp> implements LoginCallBack {
  bool passwordVisible = false;
  bool isRemember = false;
  AuthPresenter presenter;

  bool isLoadingData = false;
  bool isMobile = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  List<String> errorsList = <String>[];
  @override
  void initState() {
    super.initState();
    if (presenter == null) {
      presenter = AuthPresenter(context: context, loginCallBack: this);
    }
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    var title = "Sign up";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          )
        ],
        title: text(title,
            textColor: sh_textColorPrimary,
            fontFamily: fontBold,
            fontSize: textSizeNormal),
      ),
      body: isLoadingData
          ? SpinKitChasingDots(
              color: primaryColor,
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
                            Image.asset(
                              t3_ic_background,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(t3_lbl_create_account,
                                      style: boldTextStyle(
                                          size: 34, color: t3_white)),
                                  SizedBox(height: 4),
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
                          child:
                              Image.asset(t3_ic_icon, height: 70, width: 70)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !isMobile
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: T3AppButton(
                                      onPressed: () {
                                        isMobile = true;
                                        emailController.text = "";
                                        setState(() {});
                                      },
                                      textContent:
                                          "${translator.translate("register_with_mobile")}",
                                    ),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: T3AppButton(
                                      onPressed: () {
                                        isMobile = false;
                                        mobileController.text = "";
                                        setState(() {});
                                      },
                                      textContent:
                                          "${translator.translate("register_with_email")}",
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: errorsList.map((e) {
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "- $e",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      t3EditTextField(t3_hint_Name, nameController,
                          isPassword: false),
                      SizedBox(height: 16),
                      !isMobile
                          ? t3EditTextField(t3_hint_Email, emailController,
                              isPassword: false)
                          : t3EditTextField(t3_hint_mobile, mobileController,
                              isPassword: false),
                      SizedBox(height: 16),
                      t3EditTextField(t3_hint_password, passwordController,
                          isPassword: true),
                      SizedBox(height: 16),
                      t3EditTextField(
                          t3_hint_confirm_password, confirmPasswordController,
                          isPassword: true),
                      SizedBox(height: 35),
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
                          // makeFacebookSignIn();
                        },
                      ),
                      Platform.isIOS
                          ? SignInWithAppleButton(
                              onPressed: () async {
                                final credential =
                                    await SignInWithApple.getAppleIDCredential(
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: T3AppButton(
                            textContent: t3_lbl_sign_up,
                            onPressed: () {
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                Fluttertoast.showToast(
                                    msg:
                                        "${translator.translate("password_not_match")}");
                              } else {
                                FirebaseMessaging _firebaseMessaging =
                                    FirebaseMessaging.instance;
                                _firebaseMessaging.getToken().then((token) {
                                  presenter.makeRegister(
                                      nameController.text.toString().trim(),
                                      emailController.text.toString().trim(),
                                      mobileController.text.toString().trim(),
                                      passwordController.text.toString().trim(),
                                      confirmPasswordController.text
                                          .toString()
                                          .trim(),
                                      token);
                                });
                              }
                            }),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(t3_lbl_already_have_account,
                              style: primaryTextStyle()),
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: GestureDetector(
                                child: Text(t3_lbl_sign_in,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        decoration: TextDecoration.underline,
                                        color: t3_colorPrimary)),
                                onTap: () {
                                  Navigator.of(context).pop(0);
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
                            Image.asset(t3_ic_sign2,
                                height: 50,
                                width: 70,
                                color: appStore.iconColor),
                            Container(
                                margin: EdgeInsets.only(top: 25, left: 10),
                                child: Image.asset(t3_ic_sign4,
                                    height: 50,
                                    width: 70,
                                    color: appStore.iconColor)),
                            Container(
                                margin: EdgeInsets.only(top: 25, left: 10),
                                child: Image.asset(t3_ic_sign3,
                                    height: 50,
                                    width: 70,
                                    color: appStore.iconColor)),
                            Image.asset(t3_ic_sign1,
                                height: 80,
                                width: 80,
                                color: appStore.iconColor),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void onDataError(String message) {
    print(message);
    // Fluttertoast.showToast(msg: message);
    // toast(message);
    showDialog(
        context: context,
        builder: (BuildContext contgw2ext) => CustomAlertDialog(
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
    errorsList.clear();
    OTPController otpController = Get.put(OTPController());
    otpController.saveCode(data.code);
    otpController.smsSent.value = false;
    otpController.registerMobileNumber.value = mobileController.text;
    otpController.registerEmail.value = emailController.text;
    showDialog(
        context: context,
        builder: (BuildContext context) => OTPCustomDialog(isRegister: true));
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> makeGoogleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) {
        presenter.makeSocialLogin(
            value.email, value.displayName, value.photoUrl);
      });
    } catch (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomAlertDialog(
                errorText: error.toString(),
              ));
    }
  }

/*  makeFacebookSignIn() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn([
      "email",
      "public_profile" */ /*, "user_friends"*/ /*
    ]);

    // final result = await facebookSignIn.logInWithReadPermissions(['email']);
    // final token = result.accessToken.token;
    // final graphResponse = await http.get(
    //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    // final profile = JSON.decode(graphResponse.body);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        presenter.getFacebookData(result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertDialog(
              errorText: result.errorMessage,
            ));
        break;
    }
  }*/

  @override
  void onSocialDataSuccess(LoginModel data) {
    errorsList.clear();
    OTPController otpController = Get.put(OTPController());
    otpController.setClientData(data, true);
  }

  @override
  void onErrorList(Map<String, dynamic> errors) {
    errorsList.clear();
    for (var item in errors.entries) {
      errorsList.add(item.value[0]);
    }
    print(errorsList);
    setState(() {});
  }

  @override
  void onEmailOTP(String text, int code) {
    OTPController otpController = Get.put(OTPController());
    otpController.saveCode(code);
    otpController.smsSent.value = true;
    otpController.registerMobileNumber.value = mobileController.text;
    otpController.registerEmail.value = emailController.text;
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            OTPEmailCustomDialog(isRegister: true));
  }

  @override
  void onMobileOTP(String text, int code) {
    OTPController otpController = Get.put(OTPController());
    otpController.saveCode(code);
    otpController.smsSent.value = true;
    otpController.registerMobileNumber.value = mobileController.text;
    otpController.registerEmail.value = emailController.text;
    showDialog(
        context: context,
        builder: (BuildContext context) => OTPCustomDialog(isRegister: true));
  }
}
