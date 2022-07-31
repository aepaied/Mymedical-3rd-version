import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShHomeScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/AuthPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/activate_account_presneter.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

class OtpWidget extends StatefulWidget {
  final String text;
  final String email;
  final String phone;
  final String password;
  final bool isEmail;

  OtpWidget(
      {Key key,
      @required this.text,
      @required this.isEmail,
      this.email,
      this.password,
      this.phone})
      : super(key: key);

  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget>
    implements ActivateAccountCallBack, LoginCallBack {
  bool isLoading = false;
  ActivateAccountPresenter presenter;
  AuthPresenter authPresenter;

  TextEditingController codeController = TextEditingController();

  @override
  void onActivateDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onActivateDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onActivateDataSuccess(LoginModel data) {
    isLoading = true;
    setState(() {});
    authPresenter.makeSignIn(widget.email, widget.phone, widget.password);
  }

  @override
  void onDataError(String message) {
    // TODO: implement onDataError
  }

  @override
  void onDataLoading(bool show) {
    // TODO: implement onDataLoading
  }

  @override
  void onDataSuccess(LoginModel data, bool isSocial) {
    setClientData(data);
  }

  setClientData(LoginModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.token_type, data.tokenType);
    prefs.setString(Constants.access_token, data.accessToken);
    prefs.setString(Constants.expires_at, data.expiresAt);

    prefs.setString(Constants.id, data.user.id.toString());
    prefs.setString(Constants.type, data.user.type);
    prefs.setString(Constants.name, data.user.name);
    prefs.setString(Constants.email, data.user.email ?? "");
    prefs.setString(Constants.avatar, data.user.avatar);
/*
    prefs.setString(Constants.avatar_original, data.user.avatarOriginal);
    prefs.setString(Constants.address, data.user.address);
    prefs.setString(Constants.country, data.user.country);
    prefs.setString(Constants.city, data.user.city);
    prefs.setString(Constants.postal_code, data.user.postalCode);
    prefs.setString(Constants.phone, data.user.phone);
*/

    prefs.setBool(Constants.IS_LOGGEDIN, true);

    // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ShSplashScreen();
    }));
  }

  @override
  void initState() {
    if (presenter == null) {
      presenter = ActivateAccountPresenter(
          context: context, activateAccountCallBack: this);
    }
    if (authPresenter == null) {
      authPresenter = AuthPresenter(context: context, loginCallBack: this);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "${translator.translate("confirmation")}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/otp_back.svg",
                    width: width * 0.25, height: width * 0.4, fit: BoxFit.fill),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${translator.translate("${widget.text}")}",
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: width * 0.7,
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                      hintText: "${translator.translate("confirmation_code")}"),
                )),
            SizedBox(
              height: 30,
            ),
            T3AppButton(
                textContent: "${translator.translate("confirm")}",
                onPressed: () {
                  if (widget.isEmail) {
                    presenter.activateAccount(
                        widget.email, "", codeController.text);
                  } else {
                    presenter.activateAccount(
                        "", widget.phone, codeController.text);
                  }
                }),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${translator.translate("${translator.translate("didnt_receive OTP, click to resend")} ?")}",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onSocialDataSuccess(LoginModel data) {
    // TODO: implement onSocialDataSuccess
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
