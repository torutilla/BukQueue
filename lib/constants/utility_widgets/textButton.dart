import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class TextButtonUtility extends StatelessWidget {
  final VoidCallback onpressed;
  final String text;
  final double elevation;
  final Icon? icon;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  const TextButtonUtility({
    super.key,
    required this.onpressed,
    required this.text,
    this.icon,
    this.elevation = 0,
    this.backgroundColor = softWhite,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        elevation: WidgetStatePropertyAll(elevation),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (state) {
            if (state.contains(WidgetState.pressed)) {
              return primaryColor.withOpacity(0.2);
            }
            return null;
          },
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: padding,
            child: icon,
          ),
          Text(
            text,
            style: TextStyle(color: primaryColor),
          ),
        ],
      ),
    );
  }
}
