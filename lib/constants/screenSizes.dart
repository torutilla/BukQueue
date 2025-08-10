import 'package:flutter/material.dart';

class ScreenUtil {
  static double parentWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double parentHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class ButtonSizes {
  static double buttonWidthResponsive(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.70;
  }

  static const double buttonWidth = 250;
  static const double buttonHeight = 40;

  static double buttonHeightResponsive(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.10;
  }
}
