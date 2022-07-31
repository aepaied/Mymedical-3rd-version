import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/otp_controller.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/shopHop/utils/ShConstant.dart';
import 'package:my_medical_app/theme10/utils/T10Colors.dart';
import 'package:my_medical_app/theme10/utils/T10Strings.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class OTPEmailCustomDialog extends StatelessWidget {
  final bool isRegister;
  final String email;
  final String mobile;

  OTPEmailCustomDialog({@required this.isRegister, this.email, this.mobile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, isRegister),
    );
  }
}

dialogContent(BuildContext context, bool isRegister) {
  final OTPController otpC = Get.put(OTPController());
  otpC.init(false);
  var width = MediaQuery.of(context).size.width;
  return Obx(
    () => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: defaultBoxShadow(),
      ),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(spacing_standard_new),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            SvgPicture.asset("assets/images/t10_ic_otp.svg",
                width: width * 0.25, height: width * 0.4, fit: BoxFit.fill),
            SizedBox(height: spacing_standard_new),
            otpC.smsSent.value
                ? Text("${translator.translate('email_code_sent')}",
                    style: secondaryTextStyle(), textAlign: TextAlign.center)
                : Container(),
            SizedBox(height: spacing_standard_new),
            TextFormField(
              controller: otpC.smsSent.value
                  ? otpC.otpCodeEditingController
                  : otpC.mobileNumberEditingController,
              cursorColor: t10_colorPrimary,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 4, 8),
                hintText: otpC.smsSent.value
                    ? "${translator.translate("code")}"
                    : "${translator.translate("mobile_number")}",
                hintStyle: secondaryTextStyle(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 0.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 0.0),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: textSizeMedium,
                color: appStore.textPrimaryColor,
              ),
            ),
            SizedBox(height: spacing_standard_new),
            T3AppButton(
              onPressed: () {
                otpC.smsSent.value
                    ? isRegister
                        ? otpC.activeAccount()
                        : otpC.activatePhone()
                    : otpC.sendAddressCode();
              },
              textContent: otpC.smsSent.value
                  ? "${translator.translate("activate")}"
                  : "${translator.translate("send_code")}",
            ),
            SizedBox(height: spacing_large),
            otpC.smsSent.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text(theme10_lbl_did_not_receive,
                          textColor: t10_textColorSecondary,
                          fontFamily: fontMedium,
                          fontSize: textSizeSMedium),
                      SizedBox(width: spacing_control),
                      GestureDetector(
                        onTap: otpC.counter.value == 0
                            ? () {
                                otpC.sendAddressCode();
                              }
                            : null,
                        child: otpC.counter.value == 0
                            ? text(theme10_lbl_resend_code,
                                fontFamily: fontMedium,
                                textAllCaps: true,
                                textColor: primaryColor,
                                fontSize: textSizeSMedium)
                            : text(
                                '$theme10_lbl_resend_code (${otpC.counter.value})',
                                fontFamily: fontMedium,
                                textAllCaps: true,
                                fontSize: textSizeSMedium),
                      )
                    ],
                  )
                : Container(),
            otpC.smsSent.value
                ? SizedBox(height: spacing_standard)
                : Container(),
            Text("${translator.translate("mail_sent")} ${otpC.registerEmail}")
          ],
        ),
      ),
    ),
  );
}
