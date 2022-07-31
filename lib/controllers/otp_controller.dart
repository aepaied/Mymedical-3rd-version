import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/loginModel.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/activate_account_presneter.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/add_new_address.dart';
import 'package:my_medical_app/ui/dialogs/address/addAddressPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';

class OTPController extends GetxController
    implements ActivePhoneCallBack, ActivateAccountCallBack {
  var smsSent = false.obs;
  var isCheckOut = false.obs;
  TextEditingController mobileNumberEditingController = TextEditingController();
  TextEditingController otpCodeEditingController = TextEditingController();
  var registerMobileNumber = "".obs;
  var registerEmail = "".obs;
  AddAddressPresenter presenter;
  ActivateAccountPresenter activeAccountPresenter;
  var savedCode = 0.obs;
  var counter = 60.obs;
  Timer timer;

  @override
  void onInit() {
    smsSent.value = false;
    mobileNumberEditingController.text = "";
    otpCodeEditingController.text = "";
    super.onInit();
  }

  startCounting() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (counter.value > 0) {
        counter.value--;
      }
    });
  }

  init(bool checkOut) {
    if (timer != null) {
      if (timer.isActive) {
        timer.cancel();
      }
    }
    isCheckOut.value = checkOut;
    counter.value = 60;
    startCounting();
  }

  finish() {
    registerMobileNumber.value = "";
    registerEmail.value = "";
    savedCode.value = 0;
    mobileNumberEditingController.text = "";
    otpCodeEditingController.text = "";
  }

  sendAddressCode() {
    if (presenter == null) {
      presenter =
          AddAddressPresenter(context: Get.context, phoneCallBack: this);
    }
    presenter.sendOtpCode(mobileNumberEditingController.value.text);
    startCounting();
  }

  activatePhone() {
    if (presenter == null) {
      presenter =
          AddAddressPresenter(context: Get.context, phoneCallBack: this);
    }
    presenter.activePhone(mobileNumberEditingController.value.text,
        otpCodeEditingController.value.text);
  }

  activeAccount() {
    print(otpCodeEditingController.text);
    print(savedCode.value);
    activeAccountPresenter = ActivateAccountPresenter(
        context: Get.context, activateAccountCallBack: this);
    if (otpCodeEditingController.text != savedCode.value.toString()) {
      Get.snackbar('${translator.translate("error")}',
          '${translator.translate("wrong_code")}');
    } else {
      activeAccountPresenter.activateAccount(registerEmail.value,
          registerMobileNumber.value, otpCodeEditingController.value.text);
    }
  }

  @override
  void onActivePhoneSuccess(String message) {
    smsSent.value = false;
    mobileNumberEditingController.text = "";
    otpCodeEditingController.text = "";
    finish();
    Get.to(() => AddNewAddress(
          isCheckOut: isCheckOut.value,
        ));
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
  void onOtpError(String message) {
    Get.snackbar("${translator.translate("error")}", message);
  }

  @override
  void onOtpSuccess(String message) {
    smsSent.value = true;
  }

  saveCode(int code) {
    savedCode.value = code;
  }

  @override
  void onActivateDataError(String message) {
    Get.snackbar("", message);
  }

  @override
  void onActivateDataLoading(bool show) {
    // TODO: implement onActivateDataLoading
  }

  @override
  void onActivateDataSuccess(LoginModel data) {
    finish();
    setClientData(data, false);
  }

  setClientData(LoginModel data, bool isSocial) async {
    final box = GetStorage();
    box.write(Constants.token_type, data.tokenType);
    box.write(Constants.access_token, data.accessToken);
    box.write(Constants.expires_at, data.expiresAt);
    box.write(Constants.isSocial, isSocial);
    box.write(Constants.id, data.user.id.toString());
    box.write(Constants.type, data.user.type ?? "");
    box.write(Constants.name, data.user.name ?? "");
    box.write(Constants.email, data.user.email ?? "");
    box.write(Constants.avatar, data.user.avatar ?? "");
    box.write(Constants.avatar_original, data.user.avatarOriginal ?? "");
    box.write(Constants.phone, data.user.phone ?? "");
    box.write(Constants.IS_LOGGEDIN, true);
    Get.offAll(ShSplashScreen());
  }
}
