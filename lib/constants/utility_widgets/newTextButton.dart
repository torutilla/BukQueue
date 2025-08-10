import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String? buttonText;
  final void Function()? callback;
  final double borderRadius;
  const CustomTextButton(
      {super.key,
      this.backgroundColor,
      this.textColor,
      this.buttonText,
      this.callback,
      this.borderRadius = 8});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
            foregroundColor: WidgetStatePropertyAll(textColor)),
        onPressed: callback,
        child: Text(buttonText!));
  }
}
