import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class BackbuttoninForm extends StatelessWidget {
  final VoidCallback onPressed;
  const BackbuttoninForm({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: const Icon(Icons.arrow_back_ios_rounded),
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (state) {
            if (state.contains(WidgetState.hovered)) {
              return Colors.transparent;
            }
            return null;
          },
        ),
        iconColor: WidgetStateProperty.resolveWith<Color?>(
          (state) {
            return state.contains(WidgetState.pressed)
                ? secondaryColor
                : Colors.white;
          },
        ),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStateColor.transparent,
        animationDuration: const Duration(microseconds: 2500),
      ),
    );
  }
}
