import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_try_thesis/constants/constants.dart';

class CustomInkWellForAccount extends StatefulWidget {
  final String inkWellIconLocation;
  final String textTitle;
  final String textParagraph;
  final VoidCallback onTap;
  final double inkWellHeight;
  final double inkWellWidth;
  final bool isAlreadyPressed;

  CustomInkWellForAccount({
    super.key,
    required this.inkWellHeight,
    required this.onTap,
    required this.inkWellWidth,
    required this.inkWellIconLocation,
    this.textTitle = 'Learn More',
    this.textParagraph = 'Lorem Ipsum',
    this.isAlreadyPressed = false,
  });

  @override
  CustomInkWellState createState() => CustomInkWellState();
}

class CustomInkWellState extends State<CustomInkWellForAccount> {
  @override
  Widget build(BuildContext context) {
    print(widget.inkWellWidth);
    return SizedBox(
      width: widget.inkWellWidth <= 350 ? widget.inkWellWidth : 350,
      height: widget.inkWellHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        return Material(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: widget.isAlreadyPressed ? accentColor : primaryColor,
                  width: 1)),
          color: widget.isAlreadyPressed ? primaryColor : Colors.white,
          child: InkWell(
            canRequestFocus: true,
            borderRadius: BorderRadius.circular(10),
            splashColor: secondaryColor,
            highlightColor: primaryColor,
            onTap: widget.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: SvgPicture.asset(
                    widget.inkWellIconLocation,
                    width: constraints.maxWidth * 0.20,
                    height: constraints.maxWidth * 0.20,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                        widget.isAlreadyPressed ? Colors.white : primaryColor,
                        BlendMode.srcIn),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.textTitle,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.isAlreadyPressed
                              ? Colors.white
                              : primaryColor),
                    ),
                    // Text(
                    //   widget.textParagraph,
                    //   style: TextStyle(
                    //       color: widget.isAlreadyPressed
                    //           ? Colors.white
                    //           : primaryColor),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
