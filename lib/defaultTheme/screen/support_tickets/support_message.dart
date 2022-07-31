import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SupportMessage extends StatefulWidget {
  final String text;
  SupportMessage({Key key,@required this.text}):super(key: key);

  @override
  _SupportMessageState createState() => _SupportMessageState();
}

class _SupportMessageState extends State<SupportMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Html(data: "${widget.text}"),
        ),
      ),
    );
  }
}
