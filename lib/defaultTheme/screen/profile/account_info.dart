import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/DTProfileScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/update_profile_presenetr.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helper.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/long_string_print.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:nb_utils/nb_utils.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo>
    implements UpdateProfileCallBack {
  User currentUser;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  UpdatePresenter presenter;
  bool isLoading = false;

  @override
  void initState() {
    if (presenter == null) {
      presenter =
          UpdatePresenter(context: context, updateProfileCallBack: this);
    }
    Helpers.getUserData().then((value) {
      currentUser = value;
      nameController.text = value.name;
      emailController.text = value.email;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${translator.translate("account_info")}",
        isHome: false,
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("${translator.translate("name")}"),
                      subtitle: TextField(
                        controller: nameController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text("${translator.translate("email")}"),
                      subtitle: TextField(
                        controller: emailController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: T3AppButton(
                          textContent: "${translator.translate("update")}",
                          onPressed: () {
                            presenter.updateProfile(
                                nameController.text, emailController.text);
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void onDataError(String message) {
    CustomAlertDialog(
      errorText: message,
    );
  }

  @override
  void onDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  Future<void> onDataSuccess(message, data, code) async {
    LongStringPrint().printWrapped(data.toString());
    if (message != null) {
      Get.snackbar('', message);
    }
    Helpers.saveUserData(data);
    Future.delayed(Duration(seconds: 1), () {
      Get.off(() => T3SignIn());
    });
    // await setClientData(data).then((value) {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (BuildContext context) {
    //     return T3SignIn();
    //   }));
    // });
  }

  Future setClientData(LoginModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.token_type, data.tokenType ?? "");
    prefs.setString(Constants.access_token, data.accessToken ?? "");
    prefs.setString(Constants.expires_at, data.expiresAt ?? "");

    prefs.setString(Constants.id, data.user.id.toString());
    prefs.setString(Constants.type, data.user.type ?? "");
    prefs.setString(Constants.name, data.user.name ?? "");
    prefs.setString(Constants.email, data.user.email ?? "");
    prefs.setString(Constants.avatar, data.user.avatar ?? "");
/*
    prefs.setString(Constants.avatar_original, data.user.avatarOriginal);
    prefs.setString(Constants.address, data.user.address);
    prefs.setString(Constants.country, data.user.country);
    prefs.setString(Constants.city, data.user.city);
    prefs.setString(Constants.postal_code, data.user.postalCode);
    prefs.setString(Constants.phone, data.user.phone);
*/

    prefs.setBool(Constants.IS_LOGGEDIN, true);
  }
}
