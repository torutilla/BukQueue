import 'package:flutter/material.dart';

class RiderStateProvider extends ChangeNotifier {
  bool isBookingAccepted = false;

  void acceptBooking() {
    isBookingAccepted = true;
    notifyListeners();
  }
}
