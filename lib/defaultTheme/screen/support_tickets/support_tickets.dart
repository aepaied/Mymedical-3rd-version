import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/fetched_constans.dart';
import 'package:my_medical_app/data/remote/models/ticketsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/new_support_ticket.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/supportTicketsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/ticket_details.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';

class SupportTickets extends StatefulWidget {
  @override
  _SupportTicketsState createState() => _SupportTicketsState();
}

class _SupportTicketsState extends State<SupportTickets>
    implements SupportTicketsCallBack {
  SupportTicketsPresenter presenter;
  bool isLoading = false;
  List<TicketData> ticketList = [];

  @override
  void initState() {
    presenter = SupportTicketsPresenter(context: context, callBack: this);
    presenter.getSupportTicketsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "${translator.translate("support_tickets")}", isHome: true),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height,
        child: DrawerWidget(
          categoriesList: categoriesList,
        ),
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: ticketList.map((e) {
                      DateTime theDate = DateTime.parse(e.sendingDate);
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: primaryColor,
                                        radius: 25,
                                        child: Image.asset(
                                            'assets/images/support_ticket.png'),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${theDate.day} / ${theDate.month} / ${theDate.year}'),
                                          Text(
                                            '${e.subject}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(64, 0, 0, 0),
                                    child: Text(
                                      '${e.details}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return isLoading
                                                    ? Container()
                                                    : TicketDetails(
                                                        ticketID: e.id,
                                                      );
                                              }));
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18))),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        primaryColor)),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Text(
                                                  '${e.status}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                                CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: primaryColor,
                                                    size: 14,
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                          /*Card(
                      elevation: 5,
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child:
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${e.subject}",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${e.ticketId}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width:MediaQuery.of(context).size.width * 0.6,
                                      child: Text("${e.details}",maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),)),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${e.sendingDate}'),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("${translator.translate("status")} : ${e.status}"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),*/
                          );
                    }).toList(),
                  )),
                  T3AppButton(
                      textContent: "${translator.translate("add_ticket")}",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return NewSupportTicket();
                        }));
                      })
                ],
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
  void onDataSuccess(List<TicketData> data) {
    ticketList = data;
    setState(() {});
  }
}
