import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final double borderRadius;
  final Color onPressedColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Icon? prefixIcon;
  final Color? borderColor;
  const PrimaryButton({
    super.key,
    this.buttonText = '',
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.backgroundColor = primaryColor,
    required this.onPressed,
    this.onPressedColor = secondaryColor,
    this.prefixIcon,
    this.borderColor,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ButtonSizes.buttonWidthResponsive(context) <= 350
          ? ButtonSizes.buttonWidthResponsive(context)
          : 350,
      height: ButtonSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> state) {
              if (state.contains(WidgetState.pressed)) {
                return onPressedColor.withOpacity(0.4);
              }
              return null;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: borderColor != null
                  ? BorderSide(
                      color: borderColor!,
                      width: 0.5,
                    )
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(backgroundColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) prefixIcon!,
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
