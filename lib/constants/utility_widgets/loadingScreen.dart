import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';

import '../logoMain.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BackgroundWithColor(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MainLogo(logoHeight: 70, logoWidth: 70),
            MainLogo(logoHeight: 160, logoWidth: 160),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
