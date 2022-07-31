import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_medical_app/integrations/app_localizations.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class PaymentFromWalletDialog extends Dialog {
  PaymentFromWalletDialog(
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
    return PaymentFromWalletWidget();
  }
}

class PaymentFromWalletWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentFromWalletWidgetState();
  }
}

class PaymentFromWalletWidgetState extends State<PaymentFromWalletWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: SizeConfig.wUnit * 14,
                bottom: SizeConfig.wUnit * 4,
                left: SizeConfig.wUnit * 2,
                right: SizeConfig.wUnit * 2,
              ),
              margin: EdgeInsets.only(top: SizeConfig.wUnit * 10),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(SizeConfig.wUnit * 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.vUnit),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('wallet_balance_now_valid'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.wUnit * 5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  /* Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.vUnit),
                    child: Text(
                      AppLocalizations.of(context).translate('want_pay_from_wallet'),
                      style: TextStyle(
                        fontSize: SizeConfig.wUnit * 5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),*/

                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.wUnit,
                                  right: SizeConfig.wUnit),
                              padding: EdgeInsets.only(
                                  top: SizeConfig.vUnit,
                                  bottom: SizeConfig.vUnit),
                              color: Colors.blue,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('close')
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: SizeConfig.wUnit * 5,
                                ),
                              ),
                            )),
                      ),
                      /*   Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.wUnit,
                                  right: SizeConfig.wUnit),
                              padding: EdgeInsets.only(
                                  top: SizeConfig.vUnit,
                                  bottom: SizeConfig.vUnit),
                              color: OColors.colorRed,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('cancel')
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: OColors.colorWhite,
                                  decoration: TextDecoration.none,
                                  fontSize: SizeConfig.wUnit * 5,
                                ),
                              ),
                            )),
                      ),*/
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              left: SizeConfig.wUnit * 2,
              right: SizeConfig.wUnit * 2,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: SizeConfig.wUnit * 10,
                /* child: image == null
                ? SvgPicture.asset("assets/icons/ic_info.svg",
                    semanticsLabel: "info",
//                color: EgColor().defaultText,
                    width: SizeConfig.wUnit * 18,
                    height: SizeConfig.wUnit * 18)
                : SvgPicture.asset(image,
                    semanticsLabel: "info",
               color: OColors.colorAccent,
                    width: SizeConfig.wUnit * 8,
                    height: SizeConfig.wUnit * 8),*/
                // child: Image.asset('assets/images/logo.png'),
             /*   child: Icon(
                  Icons.monetization_on,
                  color: Theme.of(context).hintColor,
                  size: 70,
                ),*/
                child:      Image(
                  width: 45,
                  height: 45,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/icons/ic_mywallet.png'),
                ),
              ),
            ),
          ],
        ));
  }
}
