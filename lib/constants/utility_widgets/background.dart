import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';

class BackgroundWithColor extends StatelessWidget {
  final Widget? child;
  final Color color1;
  final Color color2;
  const BackgroundWithColor(
      {super.key,
      this.child,
      this.color1 = primaryColor,
      this.color2 = secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.parentHeight(context),
      width: ScreenUtil.parentWidth(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
      ),
      child: child,
    );
  }
}
