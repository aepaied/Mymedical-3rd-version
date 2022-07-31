import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
// import 'package:osouly/utils/localizations/localizations.dart';

class Helpers {
  BuildContext context;
  DateTime currentBackPressTime;

  Helpers.of(BuildContext _context) {
    this.context = _context;
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(
      //     msg: translator.translate('taptoleave'));

      Toast.show("tap to leave", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  static Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString(Constants.APP_LANG) ?? "en";
    return lang;
  }

/*  static Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mobile = prefs.getString(Constants.MOBILE) ?? "";
    return mobile;
  }*/

  /* static setMobile(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.MOBILE, mobile);
  }*/

  static Future<String> getMyToken() async {
    final box = GetStorage();
    String tokenType = box.read(Constants.token_type) ?? "";
    String accessToken = box.read(Constants.access_token) ?? "";

    return tokenType + " " + accessToken;
  }

  static Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String fcmToken = prefs.getString(Constants.FCM_TOKEN) ?? "";

    return fcmToken;
  }

  static Future<bool> setFcmToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(Constants.FCM_TOKEN, fcmToken);
  }

  static Future<bool> isLoggedIn() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final box = GetStorage();

    bool _visit = box.read(Constants.IS_LOGGEDIN) ?? false;

    return _visit;
  }

  static Future<String> getAppLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString(Constants.APP_LANG) ?? "en";

    return lang;
  }

  static Future<User> getUserData() async {
    final box = GetStorage();

    User user = User(
        accessToken: box.read(Constants.access_token) ?? "",
        name: box.read(Constants.name) ?? "",
        address: box.read(Constants.address) ?? "",
        avatar: box.read(Constants.avatar) ?? "",
        avatarOriginal: box.read(Constants.avatar_original) ?? "",
        city: box.read(Constants.city) ?? "",
        country: box.read(Constants.country) ?? "",
        email: box.read(Constants.email) ?? "",
        expiresAt: box.read(Constants.expires_at) ?? "",
        id: box.read(Constants.id) ?? "",
        isLoggedIn: box.read(Constants.IS_LOGGEDIN) ?? false,
        phone: box.read(Constants.phone) ?? "",
        postalCode: box.read(Constants.postal_code) ?? "",
        tokenType: box.read(Constants.token_type) ?? "",
        type: box.read(Constants.type) ?? "");
    return user;
  }

  static saveUserData(LoginModel data) {
    final box = GetStorage();
    box.write(Constants.token_type, data.tokenType ?? "");
    box.write(Constants.access_token, data.accessToken ?? "");
    box.write(Constants.expires_at, data.expiresAt ?? "");

    box.write(Constants.id, data.user.id.toString());
    box.write(Constants.type, data.user.type ?? "");
    box.write(Constants.name, data.user.name ?? "");
    box.write(Constants.email, data.user.email ?? "");
    box.write(Constants.avatar, data.user.avatar ?? "");
/*
    prefs.setString(Constants.avatar_original, data.user.avatarOriginal);
    prefs.setString(Constants.address, data.user.address);
    prefs.setString(Constants.country, data.user.country);
    prefs.setString(Constants.city, data.user.city);
    prefs.setString(Constants.postal_code, data.user.postalCode);
    prefs.setString(Constants.phone, data.user.phone);
*/

    box.write(Constants.IS_LOGGEDIN, true);
  }

  static Future logout() async {
    final box = GetStorage();
    box.remove(Constants.token_type);
    box.remove(Constants.access_token);
    box.remove(Constants.expires_at);
    box.remove(Constants.isSocial);
    box.remove(Constants.id);
    box.remove(Constants.type);
    box.remove(Constants.type);
    box.remove(Constants.name);
    box.remove(Constants.email);
    box.remove(Constants.avatar);
    box.remove(Constants.avatar_original);
    box.remove(Constants.phone);
    box.write(Constants.IS_LOGGEDIN, false);
  }

  static launchContact(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    /*if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else*/
    if (regExp.hasMatch(value)) {
      return false; //Please enter valid mobile number
    } else {
      return true;
    }
  }

  static bool validateEmail(String value) {
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    /*if (value.length == 0) {
      return 'Please enter Email';
    }
    else*/
    if (!regExp.hasMatch(value)) {
      return false; //Please enter valid Email
    } else {
      return true;
    }
  }
}
