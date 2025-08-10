import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';

class OverlaySnackbar {
  OverlayEntry? _overlayEntry;

  void showCustomSnackBar(BuildContext context, String content) {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: ScreenUtil.parentHeight(context) * 0.5,
        left: ScreenUtil.parentWidth(context) / 2 - 100,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${content}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}
