import 'dart:math';

import 'package:my_medical_app/ui/models/user.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class Review {
  String id = UniqueKey().toString();
  String userName;
  String review;
  String rate;
  // DateTime dateTime = DateTime.now().subtract(Duration(days: Random().nextInt(20)));
  String dateTime;

  Review({this.userName, this.review, this.rate, this.dateTime});

  /*getDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this.dateTime);
  }*/
}

/*class ReviewsList {
  List<Review> _reviewsList;

  List<Review> get reviewsList => _reviewsList;

  ReviewsList() {
    this._reviewsList = [
      new Review(
          new User.basic('Maria R. Garza', 'img/user0.jpg', UserState.available),
          'There are a few foods that predate colonization, and the European colonization of the Americas brought about the introduction of a large number of new ingredients',
          3.2),
      new Review(
          new User.basic('George T. Larkin', 'img/user1.jpg', UserState.available),
          'There are a few foods that predate colonization, and the European colonization of the Americas brought about the introduction of a large number of new ingredients',
          3.2),

    ];
  }
}*/
