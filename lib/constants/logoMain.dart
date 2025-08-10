import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLogo extends StatelessWidget {
  final double logoWidth;
  final double logoHeight;
  final Color logoColor;
  MainLogo({
    super.key,
    required this.logoHeight,
    required this.logoWidth,
    this.logoColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // return Image.asset(
    //   'assets/images/try-logo.svg',
    //   height: logoHeight,
    //   width: logoWidth,
    //   fit: BoxFit.contain,
    // );

    return Image.asset(
      'assets/images/BUKYOU.png',
      height: logoHeight,
      width: logoWidth,
      fit: BoxFit.contain,
    );
  }
}
