import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/my_order_contraoller.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/size_config.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';

class TrackOrder extends StatelessWidget {
  TrackOrder({Key key}) : super(key: key);
  final MyOrderController _myOrderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${translator.translate("track_order")}',
        isHome: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            children:
                _myOrderController.orderStepsList.asMap().entries.map((e) {
              int intNumber = e.key + 1;
              return StepWidget(
                myOrderController: _myOrderController,
                status: e.value,
                number: intNumber.toString(),
                text: "${translator.translate("${e.value}")}",
              );
            }).toList(),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: T3AppButton(
                textContent: "${translator.translate("order_details")}",
                onPressed: () {
                  Get.back();
                }),
          )
        ],
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final String status;
  final String text;
  final String number;
  const StepWidget({
    Key key,
    @required this.status,
    @required this.text,
    @required this.number,
    @required MyOrderController myOrderController,
  })  : _myOrderController = myOrderController,
        super(key: key);

  final MyOrderController _myOrderController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color:
                        _myOrderController.currentOrder.value.delivery_status !=
                                status
                            ? Colors.white
                            : primaryColor,
                    border: Border.all()),
                child: Center(
                  child:
                      _myOrderController.currentOrder.value.delivery_status !=
                              status
                          ? Text(
                              "$number",
                              style: TextStyle(
                                  color: _myOrderController.currentOrder.value
                                              .delivery_status !=
                                          status
                                      ? Colors.black
                                      : Colors.white),
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "${translator.translate(text)}",
              style: TextStyle(
                  color:
                      _myOrderController.currentOrder.value.delivery_status !=
                              status
                          ? Colors.black
                          : primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )
          ],
        ),
        number != "4"
            ? Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: primaryColor,
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
