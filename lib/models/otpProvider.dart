import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  bool isRecaptchaOngoing = false;
  bool isResendEnable = true;
  int countdownCount = 60;
  String verificationID = '';
  int? resendToken;

  void updateRecaptchaState(bool state) {
    isRecaptchaOngoing = state;
    notifyListeners();
  }

  void enableResend(bool state) {
    isResendEnable = state;
    notifyListeners();
  }

  void updateCount(int count) {
    countdownCount = count;
    notifyListeners();
  }
}
