import 'package:flutter/foundation.dart';

class BookingHistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> cancelledBookingHistory = [];
  List<Map<String, dynamic>> completedBookingHistory = [];

  Map<String, dynamic> ongoingBooking = {};

  void addToHistory(Map<String, dynamic> values) {
    if (values['Status'] == 'Cancelled') {
      cancelledBookingHistory.add(values);
    } else {
      completedBookingHistory.add(values);
    }
    notifyListeners();
  }

  void onGoingBooking(Map<String, dynamic> value) {
    ongoingBooking = value;
  }
}
