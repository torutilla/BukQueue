import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/driver/account_management/rider_page/signupRider.dart';
import 'package:flutter_try_thesis/commuter/commuter_account_management/signup.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';

import 'package:flutter_try_thesis/constants/utility_widgets/custominkwell.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class AccountOptions extends StatefulWidget {
  const AccountOptions({super.key});

  @override
  AccountOptionsState createState() => AccountOptionsState();
}

class AccountOptionsState extends State<AccountOptions> {
  static int selectedInkWellIndex = -1;
  static bool optionSelected = false;
  late CustomInkWellForAccount passengerInkWell;
  late CustomInkWellForAccount riderInkWell;

  @override
  void initState() {
    selectedInkWellIndex = -1;
    super.initState();
  }

  void _handleOnTap(index) {
    setState(() {
      selectedInkWellIndex = index;
      optionSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          child: Stack(
            children: [
              const BackgroundWithColor(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomizedCard(
                    cardColor: Colors.white,
                    cardRadius: 50,
                    cardWidth: ScreenUtil.parentWidth(context),
                    cardHeight: ScreenUtil.parentHeight(context) * 0.85,
                    childWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          children: [
                            TextTitle(
                              text: 'Select Account Type',
                              textColor: primaryColor,
                            ),
                            Text('What type of user are you?',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                    color: accentColor))
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomInkWellForAccount(
                                onTap: () {
                                  _handleOnTap(0);
                                },
                                inkWellIconLocation:
                                    'assets/images/Passenger.svg',
                                inkWellHeight:
                                    ScreenUtil.parentHeight(context) * 0.20,
                                inkWellWidth:
                                    ScreenUtil.parentWidth(context) * 0.70,
                                isAlreadyPressed: selectedInkWellIndex == 0,
                                textTitle: 'Commuter',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomInkWellForAccount(
                                onTap: () {
                                  _handleOnTap(1);
                                },
                                inkWellIconLocation: 'assets/images/Bukyo.svg',
                                inkWellHeight:
                                    ScreenUtil.parentHeight(context) * 0.20,
                                inkWellWidth:
                                    ScreenUtil.parentWidth(context) * 0.70,
                                isAlreadyPressed: selectedInkWellIndex == 1,
                                textTitle: 'Driver',
                              ),
                            ),
                          ],
                        ),
                        PrimaryButton(
                          buttonText: 'Confirm',
                          onPressed: () {
                            if (optionSelected) {
                              MyRouter.navigateToNextPermanent(
                                  context,
                                  selectedInkWellIndex == 0
                                      ? const SignUpForm()
                                      : const DriverSignUpForm());
                            }
                            selectedInkWellIndex == -1;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
