import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/otp_controller.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTProfileScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/AuthPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignUp.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/social_media_widget.dart';
import 'package:my_medical_app/defaultTheme/screen/forgot_password/forgot_password_view.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/vendor_profile.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/theme3/utils/T3Images.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/theme3/utils/colors.dart';
import 'package:my_medical_app/theme3/utils/strings.dart';
import 'package:my_medical_app/ui/dialogs/address/addAddressPresenter.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/otp/otp_email_widget.dart';
import 'package:my_medical_app/widgets/otp/otp_widget.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class T3SignIn extends StatefulWidget {
  static var tag = "/T3SignIn";

  @override
  T3SignInState createState() => T3SignInState();
}

class T3SignInState extends State<T3SignIn>
    implements LoginCallBack, ActivePhoneCallBack {
  bool passwordVisible = false;
  bool isRemember = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  AuthPresenter presenter;
  AddAddressPresenter addAddressPresenter;

  bool isLoadingData = true;

  bool isLogged = false;
  User currentUser;

  bool isEmail = true;
  String passwordError;
  String emailError;
  Future gettingUserData() async {
    currentUser = await Helpers.getUserData();
    print(currentUser.type);
  }

  Widget mainWidget;
  @override
  void initState() {
    super.initState();
    //already fixed back button
    if (presenter == null) {
      presenter = AuthPresenter(context: context, loginCallBack: this);
    }
    if (addAddressPresenter == null) {
      addAddressPresenter = Get.put(
          AddAddressPresenter(context: Get.context, phoneCallBack: this));
    }

    passwordVisible = false;
    Helpers.isLoggedIn().then((_result) {
      setState(() {
        if (_result) {
          gettingUserData().then((value) {
            isLogged = true;
            isLoadingData = false;
            if (currentUser.type == "seller") {
              mainWidget = VendorProfile(currentUser: currentUser);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
              //   return VendorProfile(currentUser: currentUser,);
              // }));
            } else {
              mainWidget = DTProfileScreen();

/*
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return DTProfileScreen();
              }));
*/
            }
          });
        } else {
          isLogged = false;
          isLoadingData = false;
        }
      });
    });
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
    changeStatusColor(Colors.transparent);
    return WillPopScope(
      //MM-48 Calls exit popup when user press back button
      onWillPop: showExitPopup, //call function on back button press
      child: Scaffold(
        body: isLoadingData
            ? SpinKitChasingDots(
                color: primaryColor,
              )
            : isLogged
                ? mainWidget
                : Observer(
                    builder: (_) => Container(
                      color: appStore.scaffoldBackground,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height:
                                  (MediaQuery.of(context).size.height) / 3.5,
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(t3_ic_background,
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width),
                                  Container(
                                    margin: EdgeInsets.only(left: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                              transform:
                                  Matrix4.translationValues(0.0, -40.0, 0.0),
                              child: Image.asset(t3_ic_icon,
                                  height: 70, width: 70),
                            ),
                            isEmail
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
                                ? t3EditTextField(
                                    t3_hint_Email, emailController,
                                    isPassword: false)
                                : t3EditTextField(
                                    "${translator.translate("phone")}",
                                    phoneController,
                                    isPassword: false),
                            emailError != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$emailError",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(height: 16),
                            t3EditTextField(
                                t3_hint_password, passwordController,
                                isPassword: true),
                            passwordError != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$passwordError",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 14),
/*
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Row(
                      children: <Widget>[
                        CustomTheme(
                          child: Checkbox(
                            focusColor: t3_colorPrimary,
                            activeColor: t3_colorPrimary,
                            value: isRemember,
                            onChanged: (bool value) {
                              setState(() {
                                isRemember = value;
                              });
                            },
                          ),
                        ),
                        Text(t3_lbl_remember, style: secondaryTextStyle(size: 16))
                      ],
                    ),
                  ),
*/
                            SizedBox(height: 14),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: T3AppButton(
                                  textContent: t3_lbl_sign_in,
                                  onPressed: () {
                                    presenter.makeSignIn(
                                        emailController.text.toString().trim(),
                                        phoneController.text.toString().trim(),
                                        passwordController.text
                                            .toString()
                                            .trim());
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordView()));
                              },
                              child: Text(t3_lbl_forgot_password,
                                  style: secondaryTextStyle(size: 16)),
                            ),
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
                                              decoration:
                                                  TextDecoration.underline,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset(t3_ic_sign2,
                                          height: 50,
                                          width: 70,
                                          color: appStore.iconColor),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 25, left: 10),
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

  @override
  void onDataError(String message) {
    Get.snackbar('${translator.translate("error")}', '$message');
    if (message == "messages.Account_not_activated") {
      OTPController otpController = Get.put(OTPController());
      otpController.sendAddressCode();
      if (isEmail) {
        otpController.smsSent.value = false;
        otpController.registerMobileNumber.value = phoneController.text;
        otpController.registerEmail.value = emailController.text;
        otpController.smsSent.value = true;
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                OTPEmailCustomDialog(isRegister: true));
      } else {
        otpController.smsSent.value = false;
        otpController.registerMobileNumber.value = phoneController.text;
        otpController.registerEmail.value = emailController.text;
        otpController.smsSent.value = true;
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                OTPCustomDialog(isRegister: true));
      }
    }
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ShSplashScreen();
    }));
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> makeGoogleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) {
        presenter.makeSocialLogin(
            value.email, value.displayName, value.photoUrl);
      });
    } catch (error) {
      print(error.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomAlertDialog(
                errorText: error.toString(),
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
      presenter.getFacebookData(result.accessToken.token);
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
  void onSocialDataSuccess(LoginModel data) {
    onDataSuccess(data, true);
  }

  @override
  void onErrorList(Map<String, dynamic> errors) {
    for (var item in errors.entries) {
      print(item.value);
      if (item.key == "password") {
        passwordError = item.value[0];
      } else {
        passwordError = null;
      }
      if (item.key == "email") {
        emailError = item.value[0];
      } else {
        emailError = null;
      }
    }
  }

  @override
  void onRegisterErrors(onRegisterErrors) {
    // TODO: implement onRegisterErrors
  }

  @override
  void onEmailOTP(String text, int code) {
    // TODO: implement onEmailOTP
  }

  @override
  void onMobileOTP(String text, int code) {
    // TODO: implement onMobileOTP
  }

  @override
  void onActivePhoneSuccess(String message) {
    // TODO: implement onActivePhoneSuccess
  }

  @override
  void onOtpError(String message) {
    // TODO: implement onOtpError
  }

  @override
  void onOtpSuccess(String message) {
    // TODO: implement onOtpSuccess
  }
}
