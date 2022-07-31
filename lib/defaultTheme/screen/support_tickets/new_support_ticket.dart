import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/TicketDataModel.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/supportTicketsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/support_tickets.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class NewSupportTicket extends StatefulWidget {
  @override
  _NewSupportTicketState createState() => _NewSupportTicketState();
}

class _NewSupportTicketState extends State<NewSupportTicket>
    implements OpenTicketCallBack {
  SupportTicketsPresenter presenter;
  bool isLoading = false;
  TextEditingController subjectController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  String fileName = "";
  File attachmentFile;

  bool isLogged = false;
  User user;
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  @override
  void initState() {
    if (presenter == null) {
      presenter =
          SupportTicketsPresenter(context: context, openTicketCallBack: this);
    }

    Helpers.getUserData().then((_user) {
      setState(() {
        isLogged = _user.isLoggedIn;
        user = _user;
      });
    });
    super.initState();
  }

  Future<File> getAttachmentFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    File file = null;
    if (result != null) {
      file = File(result.files.single.path);
      // path = result.files.single.path;
      setState(() {
        fileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }

    return file;
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "${translator.translate("add_support_ticket")}",
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Container(
              // padding: EdgeInsets.all(wUnit * 5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(),
                    TextFormField(
                      // textInputAction: TextInputAction.none,
                      keyboardType: TextInputType.text,
                      controller: subjectController,
                      onFieldSubmitted: (String value) {},
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        labelText: "${translator.translate('subject')}",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      // minLines: 1,//Normal textInputField will be displayed
                      maxLines: 5,
                      // when user presses enter it will adapt to it
                      controller: detailsController,

                      onFieldSubmitted: (String value) {},
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        labelText: "${translator.translate('details')}",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(wUnit * 3),
                            decoration: BoxDecoration(
                                // color: OColors.colorGreen,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              attachmentFile == null
                                  ? "${translator.translate("attachments")}"
                                  : fileName,
                              textAlign: TextAlign.start,
                              style: TextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: wUnit * 4,
                        ),
                        FlatButton(
                          onPressed: () {
                            getAttachmentFile().then((file) {
                              if (file != null) {
                                attachmentFile = file;
                              }
                            });
                          },
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Icon(
                            // UiIcons.planet_earth,
                            Icons.upload_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*  Visibility(
                  visible: _loadingRequest,
                  child: Center(
                    child: CircularProgressIndicator(
                        ),
                  )),*/
                    Spacer(),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  presenter.openTicket(
                                      subjectController.text.trim(),
                                      detailsController.text.trim(),
                                      attachmentFile);
                                },
                                child: Text(
                                  '${translator.translate("add")}',
                                  style: TextStyle(fontSize: 30),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(primaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18)))),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  '${translator.translate("cancel")}',
                                  style: TextStyle(fontSize: 30),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(primaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18)))),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(errorText: message));
  }

  @override
  void onDataLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  @override
  void onGetTicketData(SingleTicketData ticket) {
    // TODO: implement onGetTicketData
  }

  @override
  void onOpenTicketDataSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            )).then((value) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return SupportTickets();
        }));
      });
    });
  }
}
