import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/account_management_pages/forgotPassword.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/constants/enums.dart';
// import 'package:flutter_try_thesis/constants/utility_widgets/roleCheck.dart';
// import 'package:flutter_try_thesis/driver/account_management/rider_page/vehicleRegistration.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/riderMainScreen.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linkText.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/cachedDocumentId.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/otpProvider.dart';
import 'package:flutter_try_thesis/models/providers/userProvider.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final String contactNumber;
  final bool isRider;
  final Map<String, dynamic>? userInfo;
  final Map<String, dynamic>? vehicleData;
  // final bool forgotPasswordRoute;
  final ScreenRoutes route;
  final String? docId;
  const OtpPage({
    super.key,
    required this.contactNumber,
    this.isRider = false,
    this.userInfo,
    this.vehicleData,
    // this.forgotPasswordRoute = false,
    required this.route,
    this.docId,
  });

  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  late OtpProvider provider;
  // bool isReCaptchaInProgress = false;
  final firebaseAuth = FirebaseAuth.instance;
  // String _verificationID = '';
  // bool isResendEnable = true;
  late int countdownCount;
  Timer? globalTimer;
  TextEditingController otpController = TextEditingController();
  Timer? debounce;
  // int? _resendToken;
  CachedDocument docCache = CachedDocument();
  UserSharedPreferences sharedPreferences = UserSharedPreferences();

  String userUID = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = _getOtpProvider();
      _accountAuthenticated();
    });
    countdownCount = 60;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = _getOtpProvider();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // otpController.dispose();
    debounce?.cancel();
    countdownCount = 60;
    globalTimer?.cancel();
    globalTimer = null;
    print("DISPOSE CALLED - Canceling Timer");

    super.dispose();
  }

  OtpProvider _getOtpProvider() {
    return Provider.of<OtpProvider>(context, listen: false);
  }

  void resetProviderToDefault() {
    debugPrint("Resetting provider to default");
    provider.updateCount(60);
    provider.updateRecaptchaState(false);
    provider.enableResend(true);
    countdownCount = 60;
    globalTimer?.cancel();
    globalTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              child: Stack(
                children: [
                  const BackgroundWithColor(),
                  Positioned(
                    top: 24,
                    left: 8,
                    child: BackbuttoninForm(
                      onPressed: () {
                        resetProviderToDefault();
                        MyRouter.navigateToPrevious(context);
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: ScreenUtil.parentHeight(context) * 0.20,
                        alignment: Alignment.center,
                        child: MainLogo(logoHeight: 70, logoWidth: 200),
                      ),
                      CustomizedCard(
                        cardWidth: ScreenUtil.parentWidth(context),
                        cardHeight: ScreenUtil.parentHeight(context) * 0.80,
                        cardRadius: 50,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.lock_clock_outlined,
                                  size: ScreenUtil.parentHeight(context) * 0.20,
                                  color: primaryColor,
                                ),
                                const TextTitle(
                                  text: 'Enter Code',
                                  textColor: primaryColor,
                                ),
                                Text(
                                  'Enter the 6-digit code that we sent to ${_filteredNumber()}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width:
                                          ScreenUtil.parentWidth(context) * 0.8,
                                      child: PinCodeTextField(
                                        cursorColor: primaryColor,
                                        keyboardType: TextInputType.number,
                                        pinTheme: PinTheme(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          inactiveBorderWidth: 0.5,
                                          activeBorderWidth: 0.5,
                                          selectedBorderWidth: 0.5,
                                          inactiveColor: grayColor,
                                          activeColor: secondaryColor,
                                          selectedColor: accentColor,
                                          shape: PinCodeFieldShape.box,
                                        ),
                                        appContext: context,
                                        length: 6,
                                        controller: otpController,
                                      ),
                                    )
                                    // FieldOTPUtil(
                                    //     callBack: (input) {
                                    //       otpInput = input!;
                                    //     },
                                    //     fieldHeight: 60,
                                    //     fieldWidth:
                                    //         ScreenUtil.parentWidth(context) *
                                    //             0.11),
                                  ],
                                ),
                                Consumer<OtpProvider>(
                                    builder: (context, otpProvider, _) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Didn\'t receive the code?'),
                                      otpProvider.isResendEnable
                                          ? TextLink(
                                              onPressed: () {
                                                _accountAuthenticated(
                                                    resend: true);
                                              },
                                              linktext: 'Resend Code',
                                              textDecoration:
                                                  TextDecoration.underline,
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Resend in $countdownCount seconds.',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                            PrimaryButton(
                              onPressed: () async {
                                if (debounce?.isActive ?? false) {
                                  debounce?.cancel();
                                }
                                debounce = Timer(Duration(seconds: 1), () {
                                  if (otpController.text.isNotEmpty) {
                                    showDialog(
                                        barrierDismissible: false,
                                        barrierColor: const Color.fromARGB(
                                            31, 77, 51, 51),
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: accentColor,
                                            ),
                                          );
                                        });
                                    verifyOTP(otpController.text);
                                  }
                                });
                              },
                              buttonText: 'Verify',
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor: otpController.text.isNotEmpty
                                  ? primaryColor
                                  : grayColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resendCooldown() {
    if (globalTimer?.isActive ?? false) {
      globalTimer?.cancel();
    }
    // setState(() {
    countdownCount = 60;
    // });
    provider.updateCount(60);
    print(provider.countdownCount);

    provider.updateRecaptchaState(true);
    print('Provider state: ${provider.isRecaptchaOngoing}');
    // final endTime =
    //     DateTime.now().add(Duration(seconds: provider.countdownCount));
    provider.enableResend(false);

    // globalTimer = Timer.periodic(const Duration(seconds: 1), (time) {
    //   final remainingTime = endTime.difference(DateTime.now()).inSeconds;

    //   if (remainingTime <= 0) {
    //     time.cancel();
    //     //  globaltimer.cancel();
    //     if (mounted) {
    //       provider.enableResend(true);
    //       provider.updateCount(60);
    //     }
    //   } else {
    //     if (mounted) {
    //       provider.updateCount(remainingTime);
    //     }
    //   }
    // });
    if (globalTimer == null || !globalTimer!.isActive) {
      globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (provider.countdownCount <= 0) {
          timer.cancel();
          if (mounted) {
            provider.enableResend(true);
            provider.updateCount(60);
            provider.updateRecaptchaState(false);
            print('Recaptcha state: ${provider.isRecaptchaOngoing}');
          }
        } else {
          if (mounted) {
            countdownCount--;
            provider.updateCount(countdownCount);
          }
        }
      });
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (provider.verificationID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Session expired. Please request a new OTP.'),
      ));
      Navigator.of(context).pop();
      return;
    }

    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: provider.verificationID,
      smsCode: otp,
    );

    try {
      // if (provider.isRecaptchaOngoing) {
      //   print('reCAPTCHA is already in progress');
      //   return;
      // }
      // provider.updateRecaptchaState(true);
      final userCredential =
          await firebaseAuth.signInWithCredential(authCredential);

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        //add user to firestore if user info is null
        if (widget.userInfo == null) {
          await addUser(uid);
        }
        await Future.delayed(Duration(seconds: 5));

        Navigator.of(context).pop();
        resetProviderToDefault();
        _navigateToNextScreen();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Sign-in failed. Please try again later.'),
        ));
        Navigator.of(context).pop();
      }
      // _checkRole();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid OTP. Please try again later.'),
        ));
        Navigator.of(context).pop();
      } else if (e.code == 'session-expired') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Session expired. Please try again later.'),
        ));
        Navigator.of(context).pop();
      } else if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please check your internet connection and try again.'),
        ));
        Navigator.of(context).pop();
      } else if (e.code == 'channel-error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Error connecting to the server. Please try again later'),
        ));
        print(e.code);
        print(e.message);
        Navigator.of(context).pop();
      } else {
        print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The sms code has expired. Please try again later.'),
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please check your internet connection and try again.'),
      ));
      Navigator.of(context).pop();
    }
  }

  Future<void> _accountAuthenticated({bool resend = false}) async {
    if (provider.isRecaptchaOngoing) {
      print('A resend is already in progress or cooldown not complete.');
      return;
    }

    String contactNumber = widget.contactNumber;

    try {
      await Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please wait...'),
          ));
        }
        resendCooldown();
      });

      await firebaseAuth.verifyPhoneNumber(
        forceResendingToken: resend ? provider.resendToken : null,
        phoneNumber: contactNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credentials) async {
          final cred = await firebaseAuth.signInWithCredential(credentials);
          final uid = cred.user?.uid;
          if (uid != null && widget.userInfo == null) {
            await addUser(uid);
          }
          // _checkRole();
        },
        verificationFailed: (authException) {
          print('VERIFICATION FAILED');
          print('Code: ${authException.code}');
          print('Message: ${authException.message}');
          print('Details: ${authException.toString()}');

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${authException.message ?? 'Unknown error'}'),
          ));

          // print(authException.code);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text('Verification Failed. ${authException.message}')));
        },
        codeSent: (id, token) {
          provider.verificationID = id;
          provider.resendToken = token;

          // resendCooldown();
        },
        codeAutoRetrievalTimeout: (id) {
          // Fluttertoast.showToast(
          //     msg: 'Timed out waiting for SMS. Try again later');
          provider.verificationID = id;
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error verifying OTP. Please try again.'),
        ));
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Please check your internet connection and try again.'),
      // ));
      Fluttertoast.showToast(msg: 'An error occured: $e');
    }
    // } finally {
    //   // if (countdownCount <= 0) {
    //   provider.updateRecaptchaState(true);
    //   // }
    //   // setState(() {
    //   //   isReCaptchaInProgress = false;
    //   // });
    // }
  }

  Future<void> addUser(String uid) async {
    final userProvider = getUserProvider();
    userUID = uid;
    if (widget.vehicleData != null) {
      userProvider.storeLicenseInfoToCache(
        widget.vehicleData!['License Number'],
        widget.vehicleData!['Restrictions'],
        widget.vehicleData!['License Type'],
        widget.vehicleData!['License Expiry'],
      );
      // userProvider.addLicenseInfo(
      //     widget.vehicleData!['License Number'],
      //     widget.vehicleData!['Restrictions'],
      //     widget.vehicleData!['License Type'],
      //     widget.vehicleData!['License Expiry']);
      userProvider.updateVehicleInfo(
          widget.vehicleData!['Operator Name'],
          widget.vehicleData!['OR_CR Number'],
          widget.vehicleData!['OR Expiry Date'],
          widget.vehicleData!['Body Number'],
          widget.vehicleData!["MTOP Number"],
          widget.vehicleData!['Plate Number'],
          widget.vehicleData!['Vehicle Type'],
          widget.vehicleData!['Chassis Number'],
          widget.vehicleData!['Zone Number']);
    }
    await userProvider.addUserToDatabase(uid, isDriver: widget.isRider);
  }

  // void _checkRole() {
  //   final userProvider = getUserProvider();
  //   final role = userProvider.userInfo['Role'];
  //   RoleCheck userRoleCheck = RoleCheck(
  //     userRoles: role,
  //   );
  //   userRoleCheck.showRoleCheckDialog(context);
  // }

  UserProvider getUserProvider() {
    return Provider.of<UserProvider>(context, listen: false);
  }

  // Future<void> _navigateToNextScreen() async {
  //   final userProvider = getUserProvider();
  //   if (widget.userInfo != null) {
  //     await userProvider.updateUserInfo(
  //         widget.userInfo!['Full Name'], widget.userInfo!['Contact Number']);
  //     await sharedPreferences.addToCache({
  //       "UID": widget.userInfo!['UID'],
  //     });
  //     if (widget.vehicleData != null) {
  //       await userProvider.updateVehicleInfo(
  //           widget.vehicleData!['Operator Name'],
  //           widget.vehicleData!['Ownership Type'],
  //           widget.vehicleData!['Body Number'],
  //           widget.vehicleData!["MTOP Number"],
  //           widget.vehicleData!['License Number'],
  //           widget.vehicleData!['Plate Number'],
  //           widget.vehicleData!['Vehicle Type'],
  //           widget.vehicleData!['Chassis Number'],
  //           widget.vehicleData!['Zone Number']);
  //     }
  //     if (widget.isRider) {
  //       MyRouter.navigateAndRemoveAllStackBehind(
  //           context, const RiderScreenMap());
  //     } else {
  //       MyRouter.navigateAndRemoveAllStackBehind(
  //           context, const MainScreenWithMap());
  //     }
  //   } else {
  //     MyRouter.navigateAndRemoveAllStackBehind(context, const LoginForm());
  //   }
  // }

  Future<void> _navigateToNextScreen() async {
    FocusScope.of(context).unfocus();
    final userProvider = getUserProvider();
    if (widget.userInfo != null) {
      await userProvider.updateUserInfo(
          widget.userInfo!['Full Name'], widget.userInfo!['Contact Number']);
      await sharedPreferences.addToCache({
        "UID": widget.userInfo!['UID'],
      });
    }

    if (userProvider.vehicleInfo.isNotEmpty) {
      await userProvider.addVehicleInfoToCache();
    }
    if (widget.docId != null) {
      await docCache.storeId(widget.docId!);
    }
    // if (widget.vehicleData != null) {
    //   userProvider.storeLicenseInfoToCache(
    //     widget.vehicleData!['License Number'],
    //     widget.vehicleData!['Restrictions'],
    //     widget.vehicleData!['License Type'],
    //     widget.vehicleData!['License Expiry'],
    //   );
    //   // userProvider.addLicenseInfo(
    //   //     widget.vehicleData!['License Number'],
    //   //     widget.vehicleData!['Restrictions'],
    //   //     widget.vehicleData!['License Type'],
    //   //     widget.vehicleData!['License Expiry']);
    //   await userProvider.updateVehicleInfo(
    //       widget.vehicleData!['Operator Name'],
    //       widget.vehicleData!['OR_CR Number'],
    //       widget.vehicleData!['OR Expiry Date'],
    //       widget.vehicleData!['Body Number'],
    //       widget.vehicleData!["MTOP Number"],
    //       widget.vehicleData!['Plate Number'],
    //       widget.vehicleData!['Vehicle Type'],
    //       widget.vehicleData!['Chassis Number'],
    //       widget.vehicleData!['Zone Number']);
    // }
    globalTimer?.cancel();
    resetProviderToDefault();
    switch (widget.route) {
      case ScreenRoutes.forgotPassword:
        MyRouter.navigateAndRemoveAllStackBehind(
            context,
            ForgotPassword(
              contactNumber: widget.contactNumber,
            ));
        return;
      case ScreenRoutes.commuterSignup:
        MyRouter.navigateAndRemoveAllStackBehind(context, const LoginForm());
        return;
      case ScreenRoutes.commuterMain:
        MyRouter.navigateAndRemoveAllStackBehind(
            context, const MainScreenWithMap());
        return;
      case ScreenRoutes.driverMain:
        MyRouter.navigateAndRemoveAllStackBehind(
            context, const RiderScreenMap());
        return;
      default:
    }
    // if (widget.forgotPasswordRoute) {
    //   MyRouter.navigateAndRemoveAllStackBehind(
    //       context,
    //       ForgotPassword(
    //         contactNumber: widget.contactNumber,
    //       ));
    //   return;
    // }
    // if (widget.isRider && widget.userInfo == null) {
    //   MyRouter.navigateAndRemoveAllStackBehind(
    //       context,
    //       VehicleRegistration(
    //         uid: userUID,
    //       ));
    //   return;
    // }
    // if (widget.userInfo != null) {
    //   await userProvider.updateUserInfo(
    //       widget.userInfo!['Full Name'], widget.userInfo!['Contact Number']);
    //   await sharedPreferences.addToCache({
    //     "UID": widget.userInfo!['UID'],
    //   });
    //   if (widget.vehicleData != null) {
    //     userProvider.storeLicenseInfoToCache(
    //       widget.vehicleData!['License Number'],
    //       widget.vehicleData!['Restrictions'],
    //       widget.vehicleData!['License Type'],
    //       widget.vehicleData!['License Expiry'],
    //     );
    //     // userProvider.addLicenseInfo(
    //     //     widget.vehicleData!['License Number'],
    //     //     widget.vehicleData!['Restrictions'],
    //     //     widget.vehicleData!['License Type'],
    //     //     widget.vehicleData!['License Expiry']);
    //     await userProvider.updateVehicleInfo(
    //         widget.vehicleData!['Operator Name'],
    //         widget.vehicleData!['OR_CR Number'],
    //         widget.vehicleData!['OR Expiry Date'],
    //         widget.vehicleData!['Body Number'],
    //         widget.vehicleData!["MTOP Number"],
    //         widget.vehicleData!['Plate Number'],
    //         widget.vehicleData!['Vehicle Type'],
    //         widget.vehicleData!['Chassis Number'],
    //         widget.vehicleData!['Zone Number']);
    //   }
    //   globalTimer?.cancel();
    //   resetProviderToDefault();
    //   if (widget.isRider) {
    //     MyRouter.navigateAndRemoveAllStackBehind(
    //         context, const RiderScreenMap());
    //   } else {
    //     MyRouter.navigateAndRemoveAllStackBehind(
    //         context, const MainScreenWithMap());
    //   }
    // } else {
    //   MyRouter.navigateAndRemoveAllStackBehind(context, const LoginForm());
    // }
  }

  String _filteredNumber() {
    return '${widget.contactNumber.substring(0, 4)}*****${widget.contactNumber.substring(9)}';
  }
}
