import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/data/remote/models/VerifiedPhonesModel.dart';
import 'package:my_medical_app/data/remote/models/myAddressesModel.dart';
import 'package:my_medical_app/ui/dialogs/phoneDialog/phonePresenter.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class PhoneDialog extends Dialog {
   PhoneDialog(
      {Key key,
      this.elevation,
      this.insetAnimationDuration = const Duration(milliseconds: 100),
      this.insetAnimationCurve = Curves.decelerate,
      this.context,
      this.title,
      this.checkThisPhone})
      : super(key: key);

  final Color backgroundColor = Colors.transparent;
  final double elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final BuildContext context;
  final String title;
   String checkThisPhone;


  @override
  // TODO: implement child
  ShapeBorder get shape {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0));
  }

  @override
  // TODO: implement child
  Widget get child {
    return PhoneDialogWidget(checkThisPhone: checkThisPhone,);
  }
}

class PhoneDialogWidget extends StatefulWidget {

  String checkThisPhone;

  PhoneDialogWidget({this.checkThisPhone});
  @override
  State<StatefulWidget> createState() {
    return PhoneDialogWidgetState();
  }
}

class PhoneDialogWidgetState extends State<PhoneDialogWidget>
    implements PhoneCallBack {
  bool isLoadingData = false;
  bool isActiveMode = false;

  // String phone = "";

  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String content;

  PhonePresenter presenter;

  bool _canSend = false;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              _start = 60;
              _canSend = true;
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    if (presenter == null) {
      presenter = PhonePresenter(context: context, callBack: this);

      if(widget.checkThisPhone != null){
        phoneController.text = widget.checkThisPhone;
        presenter.sendOtpCode(widget.checkThisPhone);
        isActiveMode = true;
        startTimer();
      }
    }
  }

  @override
  void dispose() {
    if(_timer!= null){
      _timer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: wUnit * 14,
            bottom: wUnit * 4,
            left: wUnit * 2,
            right: wUnit * 2,
          ),
          margin: EdgeInsets.only(top: wUnit * 10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(wUnit * 2),
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
                padding: EdgeInsets.only(bottom: vUnit * 2),
                child: Text('verify_your_phone',
                  style: TextStyle(
                    fontSize: wUnit * 5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              (content != null)? Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: wUnit * 5,
                      color: OColors.colorDark,
                    ),
                  )     : new Container(width: 0, height: 0),
              isActiveMode
                  ? TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: codeController,
                      onFieldSubmitted: (String value) {
                        setState(() {
                          /*      _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;*/
                        });
                      },
                      style: TextStyle(
                        color: OColors.colorGray2,
                      ),
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: OColors.colorGray2)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: OColors.colorGray2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: OColors.colorGray2),
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        labelText:'code',
                      ),
                    )
                  : TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      onFieldSubmitted: (String value) {
                        setState(() {
                          /*      _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;*/
                        });
                      },
                      style: TextStyle(
                        color: OColors.colorGray2,
                      ),
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: OColors.colorGray2)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: OColors.colorGray2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: OColors.colorGray2),
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        labelText:'phone',
                      ),
                    ),
              SizedBox(height: vUnit * 4),
              (isActiveMode)?FlatButton(
                onPressed: () {
                  if (_canSend) {
                    setState(() {
                      presenter.sendOtpCode(widget.checkThisPhone);
                      _canSend = false;
                      _timer = null;
                      startTimer();
                    });
                  }
                },
                child: Text(
                  _canSend
                      ? 'resend'
                      : 'resend' +
                          " (" +
                          _start.toString() +
                          ")",
                  style: _canSend
                      ? TextStyle(
                          fontSize: wUnit * 5,
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).accentColor,
                        )
                      : TextStyle(
                          fontSize: wUnit * 5,
                          decoration: TextDecoration.underline,
                          color: OColors.colorGray2,
                        ),
                ),
              ): new Container(width: 0, height: 0),
              SizedBox(height: vUnit * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: isLoadingData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (isActiveMode) {
                                presenter.activePhone(widget.checkThisPhone, codeController.text.toString().trim());
                              } else {
                                widget.checkThisPhone = phoneController.text.toString().trim();
                                presenter.getMyVerifiedPhones();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: wUnit,
                                  right: wUnit),
                              padding: EdgeInsets.only(
                                  top: vUnit,
                                  bottom: vUnit),
                              color: OColors.colorAccent,
                              child: Text(
                                isActiveMode
                                    ? 'active'
                                        .toUpperCase()
                                    : 'verify'
                                        .toUpperCase(),
                                style: TextStyle(
                                  color: OColors.colorWhite,
                                  decoration: TextDecoration.none,
                                  fontSize: wUnit * 5,
                                ),
                              ),
                            )),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: wUnit * 2,
          right: wUnit * 2,
          child: CircleAvatar(
            backgroundColor: OColors.colorWhite,
            radius: wUnit * 10,
            child: SvgPicture.asset("assets/icons/ic_phone.svg",
                semanticsLabel: "icphone",
//                color: EgColor().defaultText,
                width: wUnit * 18,
                height: wUnit * 18),
          ),
        ),
      ],
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onLoadVerifiedPhonesSuccess(List<PhonesData> data) {
    if (data != null) {
      bool check = false;
      if (data.length > 0) {
        for (PhonesData p in data) {
          if (widget.checkThisPhone == p.phone) {
            Navigator.of(context).pop(widget.checkThisPhone);
            check = true;
            break;
          }
        }

        if(!check){
          presenter.sendOtpCode(widget.checkThisPhone);
          isActiveMode = true;
          startTimer();
        }
      } else {
        setState(() {
          presenter.sendOtpCode(widget.checkThisPhone);
          isActiveMode = true;
          startTimer();
        });
      }
    }
  }

  @override
  void onOtpError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onOtpSuccess(String message) {
    setState(() {
      content = message;
    });
  }

  @override
  void onActivePhoneSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
          errorText: message,
        )).then((value) {
      Navigator.of(context).pop(widget.checkThisPhone);
    });
  }
}
