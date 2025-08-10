import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final FontStyle fontStyle;
  final int maxLines;
  final TextOverflow overflow;
  const TextTitle({
    super.key,
    required this.text,
    this.fontSize = 26.0,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w900,
    this.textAlign = TextAlign.center,
    this.fontStyle = FontStyle.normal,
    this.maxLines = 1,
    this.overflow = TextOverflow.fade,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: overflow,
      textAlign: textAlign,
      text,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: 'Futura',
            fontSize: fontSize,
            color: textColor,
            fontWeight: fontWeight,
          ),
    );
  }
}
