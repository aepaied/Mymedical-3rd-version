import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:my_medical_app/data/remote/apiCallBack.dart';
import 'package:my_medical_app/data/remote/models/TicketDataModel.dart';
import 'package:my_medical_app/data/remote/models/openTicketModel.dart';
import 'package:my_medical_app/data/remote/models/ticketsModel.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';

class SupportTicketsPresenter {
  final BuildContext context;
  SupportTicketsCallBack callBack;
  OpenTicketCallBack openTicketCallBack;

  SupportTicketsPresenter(
      {this.context, this.callBack, this.openTicketCallBack});

  getSupportTicketsData() {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'tickets';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            TicketsModel data = TicketsModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              callBack.onDataSuccess(data.data);
            } else {
              callBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            callBack.onDataError(error.toString());
          },
          onLoading: (show) {
            callBack.onDataLoading(show);
          }).makeRequest();
    });
  }

  openTicket(String subject, String details, File file) {
    Helpers.getUserData().then((user) async {
      // var url = Constants.BASE_URL + 'getUserOrders?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'tickets/store';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);
      if (file != null) {
        final mimeTypeData =
            lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');

        req.files.add(await http.MultipartFile.fromPath(
            'attachments', file.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      req.fields['subject'] = subject;
      req.fields['details'] = details;

      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            print(response);
            OpenTicketModel data = OpenTicketModel.fromJson(response);
            if (data.success) {
              openTicketCallBack.onOpenTicketDataSuccess(data.message);
            } else {
              openTicketCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            openTicketCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            openTicketCallBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }

  replayTicket(String ticket_id, String reply, File file) {
    Helpers.getUserData().then((user) async {
      // var url = Constants.BASE_URL + 'getUserOrders?lang=' + Constants.API_LANG;
      var url = Constants.BASE_URL + 'tickets/replay';

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };

      var req = http.MultipartRequest("POST", Uri.parse(url));
      req.headers.addAll(headers);

      if (file != null) {
        final mimeTypeData =
            lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');

        req.files.add(await http.MultipartFile.fromPath(
            'attachments', file.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      }

      req.fields['ticket_id'] = ticket_id;
      req.fields['reply'] = reply;

      ApiCallBack(
          context: context,
          call: req,
          onResponse: (response) {
            OpenTicketModel data = OpenTicketModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              openTicketCallBack.onOpenTicketDataSuccess(data.message);
            } else {
              openTicketCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            openTicketCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            openTicketCallBack.onDataLoading(show);
          }).makeMultiPartRequest();
    });
  }

  getSingleTicketsData(int ticketId) {
    Helpers.getUserData().then((user) {
      var url = Constants.BASE_URL + 'tickets/getTicket/' + ticketId.toString();

      Map<String, String> headers = {
        'Authorization': user.tokenType + " " + user.accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        'lang': Constants.LANG
      };
      ApiCallBack(
          context: context,
          call: http.get(Uri.parse(url), headers: headers),
          onResponse: (response) {
            TicketDataModel data = TicketDataModel.fromJson(response);
            print(data.toString());
            if (data.success) {
              openTicketCallBack.onGetTicketData(data.data);
            } else {
              openTicketCallBack.onDataError("Error");
            }
          },
          onFailure: (error) {
            openTicketCallBack.onDataError(error.toString());
          },
          onLoading: (show) {
            openTicketCallBack.onDataLoading(show);
          }).makeRequest();
    });
  }
}

abstract class SupportTicketsCallBack {
  void onDataSuccess(List<TicketData> data);

  void onDataLoading(bool show);

  void onDataError(String message);
}

abstract class OpenTicketCallBack {
  void onGetTicketData(SingleTicketData ticket);

  void onOpenTicketDataSuccess(String message);

  void onDataLoading(bool show);

  void onDataError(String message);
}
