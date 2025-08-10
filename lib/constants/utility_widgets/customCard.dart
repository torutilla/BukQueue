import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_try_thesis/driver/account_management/rider_page/signupRider.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';

class CustomizedCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final Color cardColor;
  final double cardRadius;
  final double cardPadding;
  final Widget childWidget;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Color shadowColor;
  final double shadowOpacity;
  final bool enableDraggableScrollable;
  const CustomizedCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    this.cardColor = Colors.white,
    this.cardRadius = 10,
    this.cardPadding = 25.0,
    required this.childWidget,
    this.shadowBlurRadius = 30,
    this.shadowOpacity = 0.5,
    this.shadowSpreadRadius = 5,
    this.shadowColor = secondaryColor,
    this.enableDraggableScrollable = false,
  });

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends State<CustomizedCard> {
  @override
  void initState() {
    draggableController.addListener(() {
      if (draggableController.size == 1.0) {
        DriverSignUpFormState.removeIcon = true;
      } else {
        DriverSignUpFormState.removeIcon = false;
      }
    });
    super.initState();
  }

  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.enableDraggableScrollable
          ? ScreenUtil.parentHeight(context)
          : widget.cardHeight,
      width: widget.cardWidth,
      child: widget.enableDraggableScrollable
          ? DraggableScrollableSheet(
              controller: draggableController,
              snapSizes: const [0.83, 0.96],
              minChildSize: 0.83,
              initialChildSize:
                  ScreenUtil.parentHeight(context) < 800 ? 0.96 : 0.83,
              builder: (context, scrollController) {
                return LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: MainContainer(constraints.maxHeight),
                  );
                });
              },
            )
          : MainContainer(null),
    );
  }

  Widget MainContainer(double? maxHeight) {
    return Container(
      height: maxHeight,
      decoration: BoxDecoration(
        color: widget.cardColor,
        shape: BoxShape.rectangle,
        boxShadow: List.filled(
            2,
            BoxShadow(
              blurRadius: widget.shadowBlurRadius,
              spreadRadius: widget.shadowSpreadRadius,
              color: widget.shadowColor.withOpacity(widget.shadowOpacity),
            ),
            growable: false),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.cardRadius),
          topRight: Radius.circular(widget.cardRadius),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.cardPadding),
        child: widget.childWidget,
      ),
    );
  }
}
