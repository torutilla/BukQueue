import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeConvert {
  String convertTimeStampToDate(Timestamp timestamp) {
    return DateFormat.yMd('en_US').format(timestamp.toDate());
  }

  String convertTimeStampToTime(Timestamp timestamp) {
    return DateFormat.jm().format(timestamp.toDate());
  }
}
