import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';

class CustomAlertDialog extends StatefulWidget {
  final String errorText;

  CustomAlertDialog({Key key, @required this.errorText}) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 100, color: primaryColor),
                Column(
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 32),
                    Text('Error...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18)),
                  ],
                )
              ],
            ),
            Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Text("${widget.errorText}"),
              ),
            ),
            Container(
              width: 130,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    )
                  )

                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ok".tr()),
              ),
            )
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
