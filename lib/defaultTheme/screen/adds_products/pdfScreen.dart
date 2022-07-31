/*
import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfScreen extends StatefulWidget {
  String title;
  final String url;

  PdfScreen({this.title, this.url});

  @override
  State<StatefulWidget> createState() {
    return PdfScreenState();
  }
}

class PdfScreenState extends State<PdfScreen> {
  bool isLoadingData = true;
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadDocument();
  }

  loadDocument() async {
    // document = await PDFDocument.fromAsset('assets/sample.pdf');

    // File file = new File.fromUri(Uri.parse(widget.url));
    // document = await PDFDocument.fromFile(file);

    document = await PDFDocument.fromURL(
      // "http://conorlastowka.com/book/CitationNeededBook-Sample.pdf",
      widget.url,
       cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ),
    );

    setState(() => isLoadingData = false);
  }

  changePDF(value) async {
    setState(() => isLoadingData = true);
    if (value == 1) {
      document = await PDFDocument.fromAsset('assets/sample2.pdf');
    } else if (value == 2) {
      document = await PDFDocument.fromURL(
        "http://conorlastowka.com/book/CitationNeededBook-Sample.pdf",
        */
/* cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ), *//*

      );
    } else {
      document = await PDFDocument.fromAsset('assets/sample.pdf');
    }
    setState(() => isLoadingData = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon,
                color: Theme.of(context).hintColor),
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
        body: isLoadingData
            ? ProgressWidget(
                width: SizeConfig.wUnit * 30,
                height: SizeConfig.wUnit * 30,
              )
            : PDFViewer(
                document: document,
                zoomSteps: 1,
              ));
  }
}
*/
