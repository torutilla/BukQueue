import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/account_management_pages/accountChoice.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';

import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linkText.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class StartUpApp extends StatelessWidget {
  const StartUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //background picture at background overlay

          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Image.asset(
                  'assets/images/bajaj-re-front-angle-low-view-229993-white.jpg',
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.85,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor.withOpacity(0.2)],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),

          //logo at texts
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MainLogo(
                          logoHeight: 100.0,
                          logoWidth: 200.0,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Mobile Booking App',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                  color: accentColor,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                            ),
                            Container(
                              width: 250.0,
                              child: const Text(
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  'Mobile Booking Application for Bukyo Transportation in Tagaytay City',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            PrimaryButton(
                              onPressed: () {
                                MyRouter.navigateToNextNoTransition(
                                    context, const AccountOptions());
                              },
                              backgroundColor: Colors.white,
                              buttonText: 'Get Started',
                              textColor: Colors.black,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100),
                                ),
                                TextLink(
                                    onPressed: () {
                                      MyRouter.navigateToNextNoTransition(
                                          context, LoginForm());
                                    },
                                    linktext: 'Login')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          //buttons
        ],
      ),
    );
  }
}
