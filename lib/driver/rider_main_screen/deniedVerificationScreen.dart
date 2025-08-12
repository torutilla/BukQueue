import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/driver/account_management/rider_page/signupRider.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class DeniedVerificationScreen extends StatelessWidget {
  final String currentUID;
  DeniedVerificationScreen({super.key, required this.currentUID});

  final firestoreOperations = FirestoreOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_rounded,
              color: errorColor,
              size: 80,
            ),
            const TextTitle(
              text: 'Verification Denied',
              textColor: errorColor,
            ),
            const Text('Your verification has been denied'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: PrimaryButton(
                backgroundColor: errorColor,
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  await firestoreOperations.deleteCurrentAccount(currentUID);

                  if (context.mounted) Navigator.of(context).pop();

                  MyRouter.navigateAndRemoveAllStackBehind(
                      context, const DriverSignUpForm());
                },
                buttonText: 'Retry Verification',
              ),
            )
          ],
        ),
      ),
    );
  }
}
