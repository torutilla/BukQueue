import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/account_management_pages/otpAuth.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/enums.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
// import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/providers/argon2.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  final String? contactNumber;
  const ForgotPassword({super.key, this.contactNumber});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PasswordHashArgon2 argon2 = PasswordHashArgon2();
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [FocusNode(), FocusNode()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllers = [passwordController, confirmPasswordController];
  }

  void onSubmit() {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        focusNodes[i].requestFocus();
        return;
      }
    }
    changePassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const BackgroundWithColor(),
                CustomizedCard(
                    cardRadius: 24,
                    cardWidth: ScreenUtil.parentWidth(context),
                    cardHeight: ScreenUtil.parentHeight(context) * 0.9,
                    childWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          children: [
                            Icon(
                              Icons.lock_reset_rounded,
                              color: primaryColor,
                              size: 140,
                            ),
                            TextTitle(
                              text: 'Create new password',
                              textColor: accentColor,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Enter a new password to regain access to your account. Make it secure and easy to remember.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextFieldFormat(
                              focusNode: focusNodes[0],
                              onFieldSubmit: (value) {
                                onSubmit();
                              },
                              borderRadius: 8,
                              fieldHeight: 90,
                              fieldWidth: ScreenUtil.parentWidth(context) * 0.8,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field can\'t be empty';
                                }
                                if ((value.length < 8 || value.length > 16)) {
                                  return 'Password must be 8-16 characters long';
                                }
                                return null;
                              },
                              controller: passwordController,
                              formText: 'Password',
                            ),
                            TextFieldFormat(
                              focusNode: focusNodes[1],
                              onFieldSubmit: (value) {
                                onSubmit();
                              },
                              borderRadius: 8,
                              fieldHeight: 90,
                              fieldWidth: ScreenUtil.parentWidth(context) * 0.8,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field can\'t be empty';
                                }
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  return 'Password do not match.';
                                }
                                return null;
                              },
                              controller: confirmPasswordController,
                              formText: 'Confirm Password',
                            ),
                          ],
                        ),
                        PrimaryButton(
                          onPressed: () async {
                            changePassword();
                          },
                          buttonText: 'Confirm',
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    if (formKey.currentState?.validate() ?? false) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: accentColor,
              ),
            );
          });
      //password

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final user = await firestore
          .collection('Users')
          .where('Contact Number', isEqualTo: widget.contactNumber)
          .limit(1)
          .get();
      final salt = argon2.generateRandomSalt();
      final password =
          argon2.generateHashedPassword(passwordController.text, salt);
      await firestore
          .collection('Users')
          .doc(user.docs[0].id)
          .update({"Hash": password, "Salt": salt}).whenComplete(() {
        Navigator.of(context).pop();
        MyRouter.navigateAndRemoveAllStackBehind(context, LoginForm());
        Fluttertoast.showToast(msg: 'Password updated successfully.');
      }).onError((e, stack) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong. Please try again later.')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Some inputs are invalid. Please check your entries and try again.')));
    }
  }
}

class EnterNumbertoForgotPassword extends StatefulWidget {
  const EnterNumbertoForgotPassword({super.key});

  @override
  State<EnterNumbertoForgotPassword> createState() =>
      _EnterNumbertoForgotPasswordState();
}

class _EnterNumbertoForgotPasswordState
    extends State<EnterNumbertoForgotPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController contactNumberController = TextEditingController();

  String contactNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              )),
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const BackgroundWithColor(),
                  CustomizedCard(
                      cardRadius: 24,
                      cardWidth: ScreenUtil.parentWidth(context),
                      cardHeight: ScreenUtil.parentHeight(context) * 0.8,
                      childWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.phone_android_outlined,
                            color: primaryColor,
                            size: 140,
                          ),
                          TextTitle(
                            text: 'Enter Contact Number',
                            textColor: accentColor,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Enter your contact number to receive a verification code.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TextFieldFormat(
                            onFieldSubmit: (value) {
                              validateNumber();
                            },
                            borderRadius: 8,
                            fieldHeight: 90,
                            fieldWidth: ScreenUtil.parentWidth(context) * 0.8,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field can\'t be empty';
                              }
                              if (!RegExp(r'^(09\d{9}|\+63\d{10})$')
                                  .hasMatch(value)) {
                                return 'Invalid Contact Number';
                              }

                              return null;
                            },
                            controller: contactNumberController,
                            formText: 'Enter Contact Number',
                          ),
                          PrimaryButton(
                            onPressed: () async {
                              validateNumber();
                            },
                            buttonText: 'Confirm',
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  void validateNumber() {
    if (formKey.currentState?.validate() ?? false) {
      //password
      contactNumber = contactNumberController.text.trim();
      String formattedContactNumber = contactNumber.startsWith('09')
          ? contactNumber.replaceRange(0, 1, '+63')
          : contactNumber;
      MyRouter.navigateToNextNoTransition(
          context,
          OtpPage(
            contactNumber: formattedContactNumber,
            // forgotPasswordRoute: true,
            route: ScreenRoutes.forgotPassword,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Some inputs are invalid. Please check your entries and try again.')));
    }
  }
}
