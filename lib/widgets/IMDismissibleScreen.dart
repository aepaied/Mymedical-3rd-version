import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/controllers/notification_controller.dart';
import 'package:my_medical_app/data/remote/models/notificationModel.dart';
import 'package:my_medical_app/defaultTheme/screen/orders/my_order_details.dart';
import 'package:my_medical_app/defaultTheme/screen/support_tickets/ticket_details.dart';
import 'package:my_medical_app/defaultTheme/screen/wallet/wallet_screen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main.dart';
import 'package:my_medical_app/main/model/ListModels.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class IMDismissibleScreen extends StatefulWidget {
  static String tag = '/IMDismissibleScreen';

  @override
  _IMDismissibleScreenState createState() => _IMDismissibleScreenState();
}

class _IMDismissibleScreenState extends State<IMDismissibleScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<ListModel> example = [
    ListModel(name: 'Dismissible with Both Side'),
    ListModel(name: 'Dismissible with One Side'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: appStore.scaffoldBackground,
          appBar: appBar(context, 'Dismissible'),
          body: ListView.builder(
              itemCount: example.length == null ? 0 : example.length,
              itemBuilder: (BuildContext context, index) {
                return ExampleItemWidget(example[index], onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => example[index].widget));
                });
              })),
    );
  }
}

Widget mDismissibleList(NotificationData mNotificationModel) {
  DateTime createdDate = DateTime.parse(mNotificationModel.createdAt);
  NotificationController _notificationController = Get.find();
  return GestureDetector(
    onTap: () {
      _notificationController.markAsRead(mNotificationModel.id);
      print(mNotificationModel.notificationBody.type);
      if (mNotificationModel.notificationBody.type == "order") {
        Get.to(() => MyOrderDetails(
              orderID: mNotificationModel.notificationBody.orderId.toString(),
            ));
      } else if (mNotificationModel.notificationBody.type == "wallet") {
        Get.to(() => WalletScreen());
      } else if (mNotificationModel.notificationBody.type == "ticket_replay") {
        Get.to(() => (TicketDetails(
              ticketID: mNotificationModel.notificationBody.ticketId,
            )));
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        color: mNotificationModel.isRead == 1
            ? Colors.white
            : Colors.yellow.withOpacity(0.15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.notifications,
                  color: mNotificationModel.isRead == 1
                      ? Colors.white
                      : Colors.yellow,
                )),
            10.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mNotificationModel.notificationBody.title,
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      createdDate.timeAgo,
                      style: secondaryTextStyle(),
                    )
                  ],
                ),
                Html(
                  data: mNotificationModel.notificationBody.text,
                ),
                4.height,
                Divider(),
                // Text(
                //   lipsum.createParagraph(numSentences: 1),
                //   style: secondaryTextStyle(),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ).expand()
          ],
        ),
      ),
    ),
  );
}

class UserModel {
  String tag;
  String name;
  String duration;

  UserModel({
    this.tag,
    this.name,
    this.duration,
  });
}

List<UserModel> userList = [
  UserModel(
    tag: 'L',
    name: 'Lee',
    duration: '8:43 am',
  ),
  UserModel(
    tag: 'J',
    name: 'John Smith',
    duration: '2 min ago',
  ),
  UserModel(
    tag: 'P',
    name: 'Paul',
    duration: '2 min ago',
  ),
  UserModel(
    tag: 'D',
    name: 'Dribble',
    duration: '2 min ago',
  ),
  UserModel(
    tag: 'I',
    name: 'Indeed',
    duration: '2 min ago',
  ),
  UserModel(
    tag: 'A',
    name: 'Adward',
    duration: '2 min ago',
  ),
  UserModel(
    tag: 'B',
    name: 'Bella',
    duration: '2 min ago',
  ),
  UserModel(
    tag: 'L',
    name: 'Lee',
    duration: '8:43 am',
  ),
  UserModel(
    tag: 'J',
    name: 'John Smith',
    duration: '2 min ago',
  ),
];
