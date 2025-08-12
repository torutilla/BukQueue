import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.hourglass_bottom_rounded,
              color: primaryColor,
              size: 80,
            ),
            const TextTitle(
              text: 'Verification Ongoing',
              textColor: primaryColor,
            ),
            const Text('Your verification is under review'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: PrimaryButton(
                onPressed: () {
                  MyRouter.navigateAndRemoveAllStackBehind(
                      context, const LoginForm());
                },
                buttonText: 'Back to login',
              ),
            )
          ],
        ),
      ),
    );
  }
}
