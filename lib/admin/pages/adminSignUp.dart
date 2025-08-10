import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/admin/pages/adminPage.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/argon2.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class AdminSignUp extends StatefulWidget {
  const AdminSignUp({super.key});

  @override
  State<AdminSignUp> createState() => _AdminSignUpState();
}

class _AdminSignUpState extends State<AdminSignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  PasswordHashArgon2 argon2 = PasswordHashArgon2();
  FirestoreOperations firestoreOperations = FirestoreOperations();
  Timer? debounce;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
            onPressed: () {
              MyRouter.navigateToNextPermanent(context, LoginForm());
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BackgroundWithColor(
            color1: adminGradientColor1,
            color2: adminGradientColor2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    MainLogo(logoHeight: 90, logoWidth: 90),
                    const TextTitle(
                      text: 'System Administrator',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextTitle(
                      text: 'Username',
                      fontSize: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFieldFormat(
                        backgroundColor: Colors.white,
                        borderRadius: 8,
                        borderColor: accentColor,
                        focusedBorderColor: accentColor.withOpacity(0.5),
                        fieldHeight: 50,
                        fieldWidth: ScreenUtil.parentWidth(context) * 0.80,
                        controller: usernameController,
                        hintText: 'Username',
                      ),
                    ),
                    const TextTitle(
                      text: 'Password',
                      fontSize: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFieldFormat(
                          enableObscure: true,
                          backgroundColor: Colors.white,
                          borderRadius: 8,
                          borderColor: accentColor,
                          focusedBorderColor: accentColor.withOpacity(0.5),
                          fieldHeight: 50,
                          fieldWidth: ScreenUtil.parentWidth(context) * 0.80,
                          controller: passwordController,
                          hintText: 'Password',
                        ),
                        // TextLink(
                        //   onPressed: () {},
                        //   linktext: 'Forgot Password',
                        // ),
                      ],
                    ),
                  ],
                ),
                PrimaryButton(
                  onPressedColor: accentColor.withRed(255),
                  onPressed: () async {
                    if (usernameController.text.isEmpty &&
                        passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please fill in all empty fields.')));
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          barrierColor: Colors.black12,
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            );
                          });
                      if (debounce?.isActive ?? false) {
                        debounce?.cancel();
                      }
                      debounce =
                          Timer(const Duration(milliseconds: 500), () async {
                        try {
                          final user = await firestoreOperations
                              .retrieveCollectionSnapshots('Users',
                                  where: 'Role', equalTo: 'Admin', limit: 1);
                          for (int i = 0; i < user.docs.length; i++) {
                            final userData =
                                user.docs.first.data() as Map<String, dynamic>;
                            final username = userData['Username'];
                            final hash = userData['Hash'];
                            // final salt = userData['Salt'];
                            if (username == usernameController.text &&
                                hash == passwordController.text) {
                              // await UserSharedPreferences()
                              //     .addToCache({"Admin UID": userData['UID']});
                              await UserSharedPreferences().addToCache(
                                  {"Admin Doc": user.docs.first.id});
                              // if (username == usernameController.text &&
                              //     hash ==
                              //         argon2.generateHashedPassword(
                              //             passwordController.text, salt)) {
                              Navigator.of(context).pop();
                              MyRouter.navigateAndRemoveAllStackBehind(
                                  context, const AdminMainScreen());

                              return;
                            }
                          }
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Username or password do not match.')));
                        } on FirebaseException catch (e) {
                          if (e.code == 'unavailable') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'No internet connection. Please try again later.')));
                            print(e);
                          }
                        }
                      });
                    }
                  },
                  backgroundColor: accentColor,
                  buttonText: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
