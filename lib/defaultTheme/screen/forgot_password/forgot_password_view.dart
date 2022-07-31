import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/screen/forgot_password/forgot_password_controller.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key key}) : super(key: key);
  final ForgotPasswordController controller =
      Get.isRegistered<ForgotPasswordController>()
          ? Get.find()
          : Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios),
                    )
                  ],
                ),
              ),
              controller.isResetPassword.value
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: controller.codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "${translator.translate('code')}",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: controller.newPasswordController,
                              decoration: InputDecoration(
                                labelText:
                                    "${translator.translate('new_password')}",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              )),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: controller.emailOrPhoneNumberController,
                          decoration: InputDecoration(
                            labelText:
                                "${translator.translate('email_or_phone_number')}",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          )),
                    ),
              controller.isResetPassword.value
                  ? T3AppButton(
                      textContent: "${translator.translate('reset_password')}",
                      onPressed: () {
                        controller.resetPassword();
                      })
                  : T3AppButton(
                      textContent: "${translator.translate('submit')}",
                      onPressed: () {
                        controller.validateData();
                      })
            ],
          ),
        ),
      ),
    );
  }
}
