import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/controllers/system_settings_controller.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/ui/models/paymentType.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class PaymentTypeWidget extends StatelessWidget {
  const PaymentTypeWidget({
    this.paymentType,
    this.value,
    this.onChanged,
  });

  final PaymentType paymentType;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    BusinessSettingController businessSettingController = Get.find();
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        child: businessSettingController.currentBusinessSettings.value.details
                        .where((element) => element.type == "paysky")
                        .toList()[0]
                        .value ==
                    "1" &&
                paymentType.name == "paysky"
            ? Image.asset(
                "assets/images/visa_master_logo.png",
                // color: Theme.of(context).textTheme.display3.color,
                width: 100,
                height: 200,
              )
            : businessSettingController.currentBusinessSettings.value.details
                            .where((element) => element.type == "fawry")
                            .toList()[0]
                            .value ==
                        "1" &&
                    paymentType.name == "fawry"
                ? Image.asset(
                    "assets/images/fawry_logo.png",
                    // color: Theme.of(context).textTheme.display3.color,
                    width: 100,
                    height: 200,
                  )
                : paymentType.name == "cash_on_delivery"
                    ? Image.asset(
                        "assets/images/cash_on_delivery.png",
                        // color: Theme.of(context).textTheme.display3.color,
                        width: 100,
                        height: 200,
                      )
                    : Container(),
      ),
    );
  }
}
