import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/TicketDataModel.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/my_message.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/supportTicketsPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/support_message.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/theme3/utils/T3widgets.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';

class TicketDetails extends StatefulWidget {
  final int ticketID;

  TicketDetails({@required this.ticketID});

  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails>
    implements OpenTicketCallBack {
  SupportTicketsPresenter presenter;
  SingleTicketData currentTicket;
  bool isLoading = false;
  TextEditingController replayController = TextEditingController();
  User currentUser;

  String ticketStatus;

  @override
  void initState() {
    if (presenter == null) {
      presenter =
          SupportTicketsPresenter(context: context, openTicketCallBack: this);
      presenter.getSingleTicketsData(widget.ticketID);
    }
    Helpers.getUserData().then((value) {
      currentUser = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${translator.translate("support_ticket")}",
        isHome: false,
      ),
      body: isLoading
          ? SpinKitChasingDots(
              color: primaryColor,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${currentTicket.subject}",
                        style: TextStyle(fontSize: 22),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ListView(
                    children: currentTicket.ticketreplies.map((e) {
                      return Row(
                        mainAxisAlignment:
                            currentTicket.userId.toString() == currentUser.id
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: e.user_id.toString() == currentUser.id
                                ? MyMessage(
                                    text: '${e.reply}',
                                  )
                                : SupportMessage(
                                    text: '${e.reply}',
                                  ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )),
                ticketStatus != "solved"
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: [
                              TextField(
                                controller: replayController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintText:
                                        "${translator.translate("replay")}"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              T3AppButton(
                                  textContent:
                                      "${translator.translate("send_replay")}",
                                  onPressed: () {
                                    presenter.replayTicket(
                                        currentTicket.id.toString(),
                                        replayController.text,
                                        null);
                                  })
                            ],
                          ),
                        ),
                      )
                    : SizedBox(height: 50)
              ],
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
    currentTicket = ticket;
    ticketStatus = ticket.status;
    setState(() {});
  }

  @override
  void onOpenTicketDataSuccess(String message) {
    presenter.getSingleTicketsData(currentTicket.id);
  }
}
