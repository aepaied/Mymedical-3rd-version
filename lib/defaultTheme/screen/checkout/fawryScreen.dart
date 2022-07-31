import 'package:flutter/material.dart';
import 'package:my_medical_app/utils/ui_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FawryScreen extends StatefulWidget {
  String title;
  final String url;

  FawryScreen({this.title, this.url});

  @override
  State<StatefulWidget> createState() {
    return FawryScreenState();
  }
}

class FawryScreenState extends State<FawryScreen> {
  WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _back() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  _forward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  _loadPage() async {
    var url = await _controller.currentUrl();
    _controller.loadUrl(widget.url);

    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "",
            // AppLocalizations.of(context).translate('checkout'),
            // widget.title,
            style: Theme.of(context).textTheme.headline4,
          ),
          actions: <Widget>[],
        ),
        body: SafeArea(
          child: WebView(
            key: Key("webview"),
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              /*  if (webViewController.currentUrl() ==
                  "https://mymedicalshope.com/checkout/payment_select?fawry=true") {
                Navigator.of(context).pop(true);
              }*/
            },
          ),
        ));
  }
}
