import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_medical_app/integrations/app_localizations.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class RechargeWalletDialog extends Dialog {
  RechargeWalletDialog(
      {Key key,
      this.elevation,
      this.insetAnimationDuration = const Duration(milliseconds: 100),
      this.insetAnimationCurve = Curves.decelerate,
      this.context,
      this.image})
      : super(key: key);

  final Color backgroundColor = Colors.transparent;
  final double elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final BuildContext context;
  String image;

  @override
  // TODO: implement child
  ShapeBorder get shape {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0));
  }

  @override
  // TODO: implement child
  Widget get child {
    return RechargeWalletWidget();
  }
}

class RechargeWalletWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RechargeWalletWidgetState();
  }
}

class RechargeWalletWidgetState extends State<RechargeWalletWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  List<RechargePaymentMethod> paymentList = List();
  RechargePaymentMethod selectedPayment;

  String selectRechargeType;

  @override
  Widget build(BuildContext context) {
    if (paymentList.length == 0) {
      paymentList.add(
          RechargePaymentMethod(type: "paysky", name: 'paysky', amount: "0"));
      paymentList.add(
          RechargePaymentMethod(type: "fawry", name: 'fawry', amount: "0"));
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Wallet Recharge"),
          DropdownButton(
            isExpanded: true,
            hint: Text('select_payment'),
            value: selectedPayment,
            onChanged: (newValue) {
              setState(() {
                selectedPayment = newValue;
              });
            },
            items: paymentList.map((type) {
              return DropdownMenuItem(
                child: new Text(type.name),
                value: type,
              );
            }).toList(),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(
              hintText: "Amount"
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                    onTap: () {
                        if (selectedPayment != null) {
                          selectedPayment.amount = amountController.text.toString().trim();
                          Navigator.of(context).pop(selectedPayment);
                        }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('recharge'
                            .toUpperCase(),
                        style: TextStyle(
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )),
              ),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('close'
                            .toUpperCase(),
                        style: TextStyle(
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )),
              ),
            ],
          )

        ],
      ),
    );
    /*Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.vUnit),
              child: Text(
                'recharge_wallet',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
//              SizedBox(height: 16.0),
            DropdownButton(
              isExpanded: true,
              hint: Text('select_payment'),
              value: selectedPayment,
              onChanged: (newValue) {
                setState(() {
                  selectedPayment = newValue;
                });
              },
              items: paymentList.map((type) {
                return DropdownMenuItem(
                  child: new Text(type.name),
                  value: type,
                );
              }).toList(),
            ),
            SizedBox(height:MediaQuery.of(context).size.height * 0.1),
            TextFormField(
              textInputAction: TextInputAction.next,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              controller: amountController,
              onFieldSubmitted: (String value) {
                */ /*setState(() {
          });*/ /*
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate('required');
                }
                return null;
              },
              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelStyle: Theme.of(context).textTheme.bodyText1,
                labelText:
                    'amount',
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          if (selectedPayment != null) {
                            selectedPayment.amount = amountController.text.toString().trim();
                            Navigator.of(context).pop(selectedPayment);
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width,
                            right: MediaQuery.of(context).size.width),
                        padding: EdgeInsets.only(
                            top:MediaQuery.of(context).size.height,
                            bottom: MediaQuery.of(context).size.height),
                        color: Colors.blue,
                        child: Text('recharge'
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width,
                            right: MediaQuery.of(context).size.width),
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height,
                            bottom: MediaQuery.of(context).size.height),
                        color: Colors.red,
                        child: Text('close'
                              .toUpperCase(),
                          style: TextStyle(
                            color:Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                      )),
                ),
              ],
            )
          ],
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2,
          right: MediaQuery.of(context).size.width * 0.2,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: MediaQuery.of(context).size.width* 0.10,
           */ /* child: Icon(
              Icons.monetization_on,
              color: Theme.of(context).hintColor,
              size: 70,
            ),*/ /*
            child:      Image(
              width: 45,
              height: 45,
              fit: BoxFit.fill,
              image: AssetImage('assets/icons/ic_mywallet.png'),
            ),
          ),
        ),
      ],
    );*/
  }
}

class RechargePaymentMethod {
  String type;
  String name;
  String amount;

  RechargePaymentMethod({this.type, this.name, this.amount});
}
