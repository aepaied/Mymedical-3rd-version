import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';

class MyMessage extends StatefulWidget {
  final String text;
  MyMessage({Key key, @required this.text}) : super(key: key);

  @override
  _MyMessageState createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.wUnit * 70,
      child: Card(
        color: primaryColor,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Html(data: "${widget.text}"),
        ),
      ),
    );
  }
}
