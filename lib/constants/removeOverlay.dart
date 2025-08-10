import 'package:flutter/material.dart';

void removeOverlay(OverlayEntry? overlayEntry,
    {AnimationController? animationController}) {
  if (overlayEntry?.mounted ?? false) {
    if (animationController != null) {
      animationController.reverse().then((_) {
        overlayEntry?.remove();
        overlayEntry = null;
      });
    } else {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
}
