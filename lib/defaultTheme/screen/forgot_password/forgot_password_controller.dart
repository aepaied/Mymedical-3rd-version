import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/defaultTheme/screen/forgot_password/forgot_password_provider.dart';

class ForgotPasswordController extends GetxController
    implements ForgotPasswordCallback {
  TextEditingController emailOrPhoneNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  ForgotPasswordProvider forgotPasswordProvider;
  String email;
  String phone;
  String code;
  var isResetPassword = false.obs;

  @override
  void onInit() {
    if (forgotPasswordProvider == null) {
      forgotPasswordProvider =
          ForgotPasswordProvider(forgotPasswordCallback: this);
    }
    super.onInit();
  }

  void validateData() {
    if (emailOrPhoneNumberController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email or phone number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10));
    } else {
      if (isNumeric(emailOrPhoneNumberController.text)) {
        Map<String, dynamic> body = {
          "phone": emailOrPhoneNumberController.text
        };
        forgotPasswordProvider.doForgotPassword(body);
      } else {
        Map<String, dynamic> body = {
          "email": emailOrPhoneNumberController.text
        };
        forgotPasswordProvider.doForgotPassword(body);
      }
    }
  }

  void resetPassword() {
    if (codeController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10));
    } else {
      if (newPasswordController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter your new password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.all(10));
      } else {
        if (isNumeric(emailOrPhoneNumberController.text)) {
          Map<String, dynamic> body = {
            "phone": emailOrPhoneNumberController.text,
            "code": codeController.text,
            "password": newPasswordController.text
          };
          forgotPasswordProvider.doResetPassword(body);
        } else {
          Map<String, dynamic> body = {
            "email": emailOrPhoneNumberController.text,
            "code": codeController.text,
            "password": newPasswordController.text
          };
          forgotPasswordProvider.doResetPassword(body);
        }
      }
    }
  }

  bool isNumeric(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }

    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  @override
  void onForgotPasswordError(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(10));
  }

  @override
  void onForgotPasswordSuccess(
      String message, String email, String phone, String code) {
    Get.snackbar('Success', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(10));
    code = code.toString();
    if (email != null) {
      email = email;
    } else {
      phone = phone;
    }
    isResetPassword.value = true;
  }

  @override
  void onResetPasswordError() {
    Get.snackbar('Error', 'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(10));
  }

  @override
  void onResetPasswordSuccess() {
    Get.snackbar('Success', 'Password has been changed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(10));
    Navigator.pop(Get.context);
  }
}
