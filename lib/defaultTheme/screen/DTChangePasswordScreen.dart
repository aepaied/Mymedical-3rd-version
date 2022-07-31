import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/change_password_controller.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/update_profile_presenetr.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/main/utils/AppColors.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';

import '../../main.dart';

class DTChangePasswordScreen extends StatefulWidget {
  static String tag = '/DTChangePasswordScreen';

  @override
  DTChangePasswordScreenState createState() => DTChangePasswordScreenState();
}

class DTChangePasswordScreenState extends State<DTChangePasswordScreen>
    implements UpdateProfileCallBack, ResetPasswordCallBack {
  bool oldPassObscureText = true;
  bool newPassObscureText = true;
  bool confirmPassObscureText = true;

  var passCont = TextEditingController();
  var newPassCont = TextEditingController();
  var confirmPassCont = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var codeController = TextEditingController();
  var newPassFocus = FocusNode();
  var confirmPassFocus = FocusNode();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChangingPassword = false;
  bool isWritingEmail = true;
  bool isSendingCode = false;
  bool isEmail = true;
  int sentCode;
  ChangePasswordController _changePasswordController =
      Get.put(ChangePasswordController());
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    _changePasswordController.init();
    return Scaffold(
      appBar: CustomAppBar(
        title: '${translator.translate("change_password")}',
      ),
      body: _changePasswordController.isLoading.value
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Container(
              width: dynamicWidth(context),
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Change Password', style: boldTextStyle(size: 24)),
                  30.height,
                  Column(
                    children: [
                      TextFormField(
                        controller:
                            _changePasswordController.newPasswordController,
                        style: primaryTextStyle(),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "${translator.translate("new_password")}",
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: primaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _changePasswordController
                            .newPasswordConfirmController,
                        style: primaryTextStyle(),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText:
                              "${translator.translate("confirm_new_password")}",
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: primaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                  16.height,
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: defaultBoxShadow()),
                    child: Text('Submit',
                        style: boldTextStyle(color: white, size: 18)),
                  ).onTap(() {
                    _changePasswordController.changePassword();
                  }),
                ],
              ),
            ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onDataSuccess(String message, LoginModel data, int theCode) {
    Fluttertoast.showToast(msg: message);
    sentCode = theCode;
    isWritingEmail = false;
    isSendingCode = true;
    setState(() {});

    setState(() {});
  }

  @override
  void onResetPasswordDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onResetPasswordDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onResetPasswordDataSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomMessageDialog(errorText: message));
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return T3SignIn();
      }));
    });
  }
}
