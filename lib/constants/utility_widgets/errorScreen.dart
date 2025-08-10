import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWithColor(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MainLogo(logoHeight: 80, logoWidth: 80),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextTitle(
              text: 'No data found.',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final Color color1;
  final Color color2;
  final Color progressColor;
  final String? loadingText;
  final Color loadingTextColor;
  const LoadingScreen({
    super.key,
    this.color1 = primaryColor,
    this.color2 = secondaryColor,
    this.progressColor = Colors.white,
    this.loadingText,
    this.loadingTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundWithColor(
      color1: primaryColor,
      color2: secondaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: progressColor,
            ),
            if (loadingText != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loadingText!,
                  style: TextStyle(
                    color: loadingTextColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
