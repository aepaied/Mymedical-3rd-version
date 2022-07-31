import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/screen/auth/T3SignIn.dart';
import 'package:my_medical_app/defaultTheme/screen/profile/update_profile_presenetr.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';

class ChangePasswordController extends GetxController
    implements ResetPasswordCallBack {
  var isLoading = false.obs;
  var newPassword = "".obs;
  var newPasswordConfirm = "".obs;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmController = TextEditingController();
  UpdatePresenter presenter;

  @override
  void onInit() {
    if (presenter == null) {
      presenter =
          UpdatePresenter(context: Get.context, resetPasswordCallBack: this);
    }

    super.onInit();
  }

  init() {
    newPasswordController.text = "";
    newPasswordConfirmController.text = "";
  }

  changePassword() {
    if (newPasswordController.text != "" &&
        newPasswordConfirmController.text != "") {
      if (newPasswordController.text != newPasswordConfirmController.text) {
        Get.snackbar('${translator.translate('error')}',
            '${translator.translate('password_not_match')}',
            backgroundColor: primaryColor);
      } else {
        presenter.changepassword(newPasswordConfirmController.text);
      }
    }
  }

  @override
  void onResetPasswordDataError(String message) {
    Get.snackbar("${translator.translate("error")}", message,
        backgroundColor: primaryColor);
    isLoading.value = false;
  }

  @override
  void onResetPasswordDataLoading(bool show) {
    isLoading.value = show;
  }

  @override
  void onResetPasswordDataSuccess(String message) {
    isLoading.value = false;
    Get.offAll(T3SignIn());
    Get.snackbar("${translator.translate("success")}", message,
        backgroundColor: primaryColor);
  }
}
