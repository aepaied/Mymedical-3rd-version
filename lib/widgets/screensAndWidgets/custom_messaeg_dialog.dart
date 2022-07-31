import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';


class CustomMessageDialog extends StatefulWidget {
  final String errorText;
  CustomMessageDialog({Key key, @required this.errorText}):super(key: key);
  @override
  _CustomMessageDialogState createState() => _CustomMessageDialogState();
}

class _CustomMessageDialogState extends State<CustomMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appStore.scaffoldBackground,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${translator.translate("success")}", style: boldTextStyle(color: appStore.textPrimaryColor)),
          16.height,
          Text(
            "${widget.errorText}",
            style: secondaryTextStyle(color: appStore.textSecondaryColor),
          ),
          16.height,
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: boxDecoration(bgColor: primaryColor, radius: 10),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: text("Ok", textColor: white, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
    );



    /*AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 120, color: Colors.green),
                Column(
                  children: [
                    Icon(Icons.done, color: Colors.white, size: 32),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(" ${widget.errorText} "),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(color: sh_colorPrimary),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text("OK", style: TextStyle(color:Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(0),
    );*/
  }
}
