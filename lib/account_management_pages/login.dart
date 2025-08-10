import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/account_management_pages/accountChoice.dart';
import 'package:flutter_try_thesis/account_management_pages/forgotPassword.dart';
import 'package:flutter_try_thesis/account_management_pages/otpAuth.dart';
import 'package:flutter_try_thesis/admin/pages/adminSignUp.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/enums.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linkText.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
// import 'package:flutter_try_thesis/constants/utility_widgets/roleCheck.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/riderMainScreen.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/cachedDocumentId.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
// import 'package:flutter_try_thesis/models/navigatorKey.dart';
import 'package:flutter_try_thesis/models/providers/argon2.dart';
import 'package:flutter_try_thesis/models/providers/userProvider.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  double containerWidth = 0;
  double containerHeight = 0;
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirestoreOperations firestoreOperations = FirestoreOperations();
  PasswordHashArgon2 argon2 = PasswordHashArgon2();
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  final contactNode = FocusNode();
  final passwordNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCheckingCredentials = false;
  Timer? _debounce;
  CachedDocument docCache = CachedDocument();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: IconButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(secondaryColor)),
                onPressed: () {
                  MyRouter.navigateToNextPermanent(
                      context, const AdminSignUp());
                },
                icon: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                )),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                const BackgroundWithColor(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: ScreenUtil.parentHeight(context) * .30,
                      alignment: Alignment.center,
                      // child: MainLogo(logoHeight: 70, logoWidth: 200),
                      child: MainLogo(logoHeight: 160, logoWidth: 160),
                    ),
                    CustomizedCard(
                        cardWidth: ScreenUtil.parentWidth(context),
                        cardHeight: ScreenUtil.parentHeight(context) * 0.70,
                        cardRadius: 50.0,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Column(
                              children: [
                                TextTitle(
                                  text: 'Welcome back!',
                                  textColor: primaryColor,
                                ),
                                Text(
                                  'Login to your account',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300,
                                      color: accentColor),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              width: containerWidth =
                                  ScreenUtil.parentWidth(context),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextFieldFormat(
                                    onFieldSubmit: (value) {
                                      passwordNode.requestFocus();
                                    },
                                    focusNode: contactNode,
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
                                    controller: _contactNumberController,
                                    borderRadius: 8,
                                    fieldWidth: containerWidth * 0.70,
                                    fieldHeight: 75,
                                    formText: 'Contact Number',
                                    prefixIcon: const Icon(Icons.phone),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextFieldFormat(
                                        onFieldSubmit: (value) {
                                          if (_contactNumberController
                                              .text.isNotEmpty) {
                                            tryLogin();
                                          } else {
                                            contactNode.requestFocus();
                                          }
                                        },
                                        focusNode: passwordNode,
                                        controller: _passwordController,
                                        borderRadius: 8,
                                        fieldWidth: containerWidth * 0.70,
                                        fieldHeight: 75,
                                        formText: 'Password',
                                        enableObscure: true,
                                        prefixIcon: const Icon(Icons.key),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.centerRight,
                              child: TextLink(
                                onPressed: () {
                                  MyRouter.navigateToNext(context,
                                      const EnterNumbertoForgotPassword());
                                },
                                linktext: 'Forgot Password?',
                              ),
                            ),
                            Column(
                              children: [
                                PrimaryButton(
                                  onPressed: () async {
                                    tryLogin();
                                  },
                                  buttonText: 'Login',
                                  textColor: Colors.white,
                                  borderRadius: 8,
                                  backgroundColor: primaryColor,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Don\'t have an account?'),
                                    TextLink(
                                      onPressed: () {
                                        MyRouter.navigateToNextPermanent(
                                            context, const AccountOptions());
                                      },
                                      linktext: 'Sign Up',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tryLogin() {
    showDialog(
        barrierColor: Colors.black12,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: accentColor,
          ));
        });
    if (formKey.currentState?.validate() ?? false) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      } else {
        _debounce = Timer(const Duration(milliseconds: 500), () {
          _validateCredentials();
        });
      }
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: const Text(
              'Some fields are invalid. Please check your entries and try again.')));
    }
  }

  Future<void> _validateCredentials() async {
    if (isCheckingCredentials) return;
    isCheckingCredentials = true;

    try {
      //Convert number into ph format
      String contactNumber = _contactNumberController.text.trim();

      String formattedContactNumber = contactNumber.startsWith('09')
          ? contactNumber.replaceRange(0, 1, '+63')
          : contactNumber;

      //query if document exist with the numbe
      final querySnapshots =
          await firestoreOperations.retrieveCollectionSnapshots(
        'Users',
        where: 'Contact Number',
        equalTo: formattedContactNumber,
        limit: 1,
      );

      if (querySnapshots.docs.isEmpty) {
        // await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account not found. Please sign up to continue.'),
        ));
        return;
      }

      //get data from doc
      final entry = querySnapshots.docs.first;
      final data = entry.data() as Map<String, dynamic>;

      final fullName = data['Full Name'] ?? '';
      final contact = data['Contact Number'] ?? '';
      final password = data['Hash'] ?? '';
      final salt = data['Salt'] ?? '';
      final uid = data['UID'] ?? '';
      final role = data['Role'];
      final accountStatus = data['Account Enabled'] ?? true;

      if (accountStatus == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account disabled by administrator.'),
        ));
        Navigator.of(context).pop();
        return;
      }

      if (_passwordController.text.isEmpty ||
          password.isEmpty ||
          salt.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Missing or invalid credentials.'),
        ));
        Navigator.of(context).pop();
        return;
      }

      final isPasswordValid = argon2.verifyPassword(
        _passwordController.text,
        salt,
        password,
      );

      if (!isPasswordValid) {
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Contact Number/Password do not match.'),
        ));
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.userInfo = data;

      User? currentUser = firebaseAuth.currentUser;
      // String cachedUID = await sharedPreferences.readCacheString("UID") ?? "";

      // Map<String, dynamic>? vehicleData;
      // if (role == 'Driver') {
      //   try {
      //     final vehicleRef =
      //         await firestoreOperations.retrieveCollectionSnapshots(
      //       'Users',
      //       documentPath: entry.id,
      //       subCollectionPath: 'Vehicle Info',
      //     );

      //     if (vehicleRef.docs.isNotEmpty) {
      //       final vehicleDoc = vehicleRef.docs.first;
      //       vehicleData = vehicleDoc.data() as Map<String, dynamic>;
      //     }
      //   } catch (e) {
      //     print("Failed to fetch vehicle info: $e");
      //   }
      // }

      await Future.delayed(const Duration(seconds: 2));
      await userProvider.updateUserInfo(fullName, contact);
      await sharedPreferences.addToCache({"UID": uid});
      Navigator.of(context).pop();

      //check if auth is in phone, if not verify using otp
      if (currentUser != null) {
        // if (currentUser != null || cachedUID == uid) {
        await docCache.storeId(entry.id);
        if (role == 'Driver') {
          //if driver, store vehicle and license info to cache
          userProvider.storeLicenseInfoToCache(
            data['License Number'],
            data['Restrictions'],
            data['License Type'],
            data['License Expiry'],
          );
          userProvider.updateVehicleInfo(
            data['OR_CR Number'],
            data['Operator Name'],
            data['OR Expiry Date'],
            data['Body Number'],
            data['MTOP Number'],
            data['Plate Number'],
            data['Vehicle Type'],
            data['Chassis Number'],
            data['Zone Number'],
          );

          MyRouter.navigateAndRemoveAllStackBehind(
              context, const RiderScreenMap());
        } else {
          MyRouter.navigateAndRemoveAllStackBehind(
              context, const MainScreenWithMap());
        }
      } else {
        MyRouter.navigateToNextPermanent(
          context,
          OtpPage(
            route: role == 'Driver'
                ? ScreenRoutes.driverMain
                : ScreenRoutes.commuterMain,
            isRider: role == 'Driver',
            contactNumber: formattedContactNumber,
            userInfo: data,
            vehicleData: role == 'Driver' ? data : null,
            docId: entry.id,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    } finally {
      isCheckingCredentials = false;
    }
  }

  // Future<void> _validateCredentials() async {
  //   if (isCheckingCredentials) return;
  //   isCheckingCredentials = true;
  //   String contactNumber = _contactNumberController.text.trim();

  //   String formattedContactNumber = contactNumber.startsWith('09')
  //       ? contactNumber.replaceRange(0, 1, '+63')
  //       : contactNumber;
  //   UserProvider userProvider =
  //       Provider.of<UserProvider>(context, listen: false);
  //   User? currentUser = firebaseAuth.currentUser;
  //   final querySnapshots =
  //       await firestoreOperations.retrieveCollectionSnapshots('Users',
  //           where: 'Contact Number', equalTo: formattedContactNumber);
  //   if (querySnapshots.docs.isNotEmpty) {
  //     for (var entry in querySnapshots.docs) {
  //       final data = entry.data() as Map<String, dynamic>;
  //       String fullName = data['Full Name'];
  //       String contact = data['Contact Number'];
  //       String password = data['Hash'];
  //       String salt = data['Salt'];
  //       String uid = data['UID'];
  //       dynamic role = data['Role'];
  //       bool accountStatus = data['Account Enabled'] ?? true;
  //       if (accountStatus == false) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Account disabled by administrator.')));
  //         Navigator.of(context).pop();
  //         return;
  //       }
  //       userProvider.userInfo = data;
  //       String cacheUID = await sharedPreferences.readCacheString("UID") ?? "";
  //       Map<String, dynamic>? vehicleData;
  //       if (role == 'Driver') {
  //         final vehicleRef =
  //             await firestoreOperations.retrieveCollectionSnapshots('Users',
  //                 documentPath: entry.id, subCollectionPath: 'Vehicle Info');
  //         final vehicleDoc = vehicleRef.docs.first;
  //         vehicleData = vehicleDoc.data() as Map<String, dynamic>;
  //       }
  //       if (argon2.verifyPassword(_passwordController.text, salt, password)) {
  //         if (currentUser != null || cacheUID == uid) {
  //           //remove nalang yung cachedUID condition para makapagsign in uli sa Auth
  //           await Future.delayed(const Duration(seconds: 2), () async {
  //             await userProvider.updateUserInfo(fullName, contact);
  //             await sharedPreferences.addToCache({
  //               "UID": uid,
  //             });
  //             // await sharedPreferences.addToCache({
  //             //   "Full Name": fullName,
  //             //   "Contact Number": contact,
  //             // }); //add account info to cache
  //             Navigator.of(context).pop();
  //           });
  //           if (role == 'Driver') {
  //             // final vehicleRef =
  //             //     await firestoreOperations.retrieveCollectionSnapshots('Users',
  //             //         documentPath: entry.id,
  //             //         subCollectionPath: 'Vehicle Info');
  //             // final vehicleDoc = vehicleRef.docs.first;
  //             // final vehicleData = vehicleDoc.data() as Map<String, dynamic>;
  //             if (vehicleData != null) {
  //               userProvider.storeLicenseInfoToCache(
  //                 vehicleData['License Number'],
  //                 vehicleData['Restrictions'],
  //                 vehicleData['License Type'],
  //                 vehicleData['License Expiry'],
  //               );
  //               userProvider.updateVehicleInfo(
  //                   vehicleData['Operator Name'],
  //                   vehicleData['OR_CR Number'],
  //                   vehicleData['OR Expiry Date'],
  //                   vehicleData['Body Number'],
  //                   vehicleData["MTOP Number"],
  //                   vehicleData['Plate Number'],
  //                   vehicleData['Vehicle Type'],
  //                   vehicleData['Chassis Number'],
  //                   vehicleData['Zone Number']);
  //               // await sharedPreferences.addToCache({
  //               //   "Vehicle Type": vehicleData['Vehicle Type'],
  //               //   "Operator Name": vehicleData['Operator Name'],
  //               //   "Ownership Type": vehicleData['Ownership Type'],
  //               //   "Zone Number": vehicleData['Zone Number'],
  //               //   "Body Number": vehicleData['Body Number'],
  //               //   "Plate Number": vehicleData['Plate Number'],
  //               //   "License Number": vehicleData['License Number'],
  //               //   "Chassis Number": vehicleData['Chassis Number'],
  //               //   "MTOP Number": vehicleData["MTOP Number"],
  //               // });
  //             }
  //             MyRouter.navigateAndRemoveAllStackBehind(
  //                 context, const RiderScreenMap());
  //           } else {
  //             MyRouter.navigateAndRemoveAllStackBehind(
  //                 context, const MainScreenWithMap());
  //           }

  //           //   _checkRole(role);
  //           // } else {
  //           // FirebaseAuth.instance.signInWithPhoneNumber(contact);
  //         } else {
  //           MyRouter.navigateToNextPermanent(
  //               context,
  //               OtpPage(
  //                 isRider: role == 'Driver' ? true : false,
  //                 contactNumber: formattedContactNumber,
  //                 userInfo: data,
  //                 vehicleData: role == 'Driver' ? vehicleData : null,
  //               ));
  //         }
  //       } else {
  //         await Future.delayed(const Duration(seconds: 2), () {
  //           Navigator.of(context).pop();
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             content: Text('Contact Number/Password do not match.')));
  //       }
  //     }
  //   } else {
  //     await Future.delayed(const Duration(seconds: 2), () {
  //       Navigator.of(context).pop();
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Account not found. Please sign up to continue.')));
  //   }
  // }

  // void _checkRole(dynamic role) {
  //   RoleCheck userRoleCheck = RoleCheck(
  //     userRoles: role,
  //   );
  //   userRoleCheck.showRoleCheckDialog(context);
  // }
}
