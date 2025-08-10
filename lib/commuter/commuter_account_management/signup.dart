import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/account_management_pages/otpAuth.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/enums.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/alert.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/callSnackbar.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linkText.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/userProvider.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final databaseFirestore = FirebaseFirestore.instance;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  FirestoreOperations firestoreOperations = FirestoreOperations();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String formattedContactNumber = '';
  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  late List<TextEditingController> controllers;

  bool isCheckingUser = false;
  @override
  void dispose() {
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controllers = [
      _fullNameController,
      _contactNumberController,
      _passwordController,
      _confirmpasswordController
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                const BackgroundWithColor(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: ScreenUtil.parentHeight(context) * 0.20,
                      alignment: Alignment.center,
                      child: MainLogo(logoHeight: 70, logoWidth: 200),
                    ),
                    CustomizedCard(
                      cardWidth: ScreenUtil.parentWidth(context),
                      cardHeight: ScreenUtil.parentHeight(context) * 0.80,
                      cardRadius: 50.0,
                      childWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Column(
                            children: [
                              TextTitle(
                                text: 'SIGN UP',
                                textColor: primaryColor,
                              ),
                              Text(
                                'Create your own Commuter Account',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                    color: accentColor),
                              ),
                            ],
                          ),
                          Container(
                            width: containerWidth =
                                ScreenUtil.parentWidth(context),
                            height: ScreenUtil.parentHeight(context) * 0.5,
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFieldFormat(
                                  onFieldSubmit: (value) => onSubmit(),
                                  focusNode: focusNodes[0],
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: _fullNameController,
                                  borderRadius: 8,
                                  fieldWidth: containerWidth * 0.70,
                                  fieldHeight: 64,
                                  formText: 'Full Name',
                                  prefixIcon: const Icon(Icons.person),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field can\'t be empty';
                                    }
                                    return null;
                                  },
                                ),
                                TextFieldFormat(
                                  onFieldSubmit: (value) => onSubmit(),
                                  focusNode: focusNodes[1],
                                  textInputType: TextInputType.phone,
                                  controller: _contactNumberController,
                                  borderRadius: 8,
                                  fieldWidth: containerWidth * 0.70,
                                  fieldHeight: 64,
                                  formText: 'Contact Number',
                                  prefixIcon: const Icon(Icons.phone),
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
                                ),
                                TextFieldFormat(
                                  onFieldSubmit: (value) => onSubmit(),
                                  focusNode: focusNodes[2],
                                  controller: _passwordController,
                                  borderRadius: 8,
                                  fieldWidth: containerWidth * 0.70,
                                  fieldHeight: 64,
                                  formText: 'Password',
                                  enableObscure: true,
                                  prefixIcon: const Icon(Icons.key),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field can\'t be empty';
                                    }
                                    if ((value.length < 8 ||
                                        value.length > 16)) {
                                      return 'Password must be 8-16 characters long';
                                    }
                                    return null;
                                  },
                                ),
                                TextFieldFormat(
                                  onFieldSubmit: (value) => onSubmit(),
                                  focusNode: focusNodes[3],
                                  controller: _confirmpasswordController,
                                  borderRadius: 8,
                                  fieldWidth: containerWidth * 0.70,
                                  fieldHeight: 64,
                                  enableObscure: true,
                                  formText: 'Confirm Password',
                                  prefixIcon: const Icon(Icons.key),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field can\'t be empty';
                                    }
                                    if (_passwordController.text !=
                                        _confirmpasswordController.text) {
                                      return 'Password do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              PrimaryButton(
                                onPressed: () {
                                  trySignUp();
                                },
                                buttonText: 'Continue',
                                textColor: Colors.white,
                                borderRadius: 8,
                                backgroundColor: primaryColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account?'),
                                  TextLink(
                                    onPressed: () {
                                      MyRouter.navigateToNextPermanent(
                                        context,
                                        const LoginForm(),
                                      );
                                    },
                                    linktext: 'Login',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> trySignUp() async {
    if (_fullNameController.text.isEmpty &&
        _contactNumberController.text.isEmpty &&
        _passwordController.text.isEmpty) {
      _showSnackbar('Please fill in all required fields.', context);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      _showSnackbar(
        'Some inputs are invalid. Please check your entries and try again.',
        context,
      );
      return;
    }

    if (isCheckingUser) return;
    isCheckingUser = true;

    try {
      if (await _userExists()) {
        _showSnackbar(
          'An account with this contact number already exists',
          context,
        );
        return;
      }

      showDialog(
        barrierColor: Colors.black12,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: accentColor,
            ),
          );
        },
      );

      await Future.delayed(Duration(seconds: 2), () {
        _updateUserInfo(
          _fullNameController.text,
          _contactNumberController.text,
        );
      });

      Navigator.of(context).pop();
      MyRouter.navigateToNext(
        context,
        OtpPage(
          route: ScreenRoutes.commuterSignup,
          contactNumber: formattedContactNumber,
        ),
      );
    } finally {
      isCheckingUser = false;
    }
  }

  void _updateUserInfo(
    String fullName,
    String contactNumber,
  ) {
    String contactNumber = _contactNumberController.text.trim();

    formattedContactNumber = contactNumber.startsWith('09')
        ? contactNumber.replaceRange(0, 1, '+63')
        : contactNumber;
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    provider.password = _passwordController.text;
    try {
      provider.updateUserInfo(
        fullName,
        formattedContactNumber,
      );
    } catch (e) {
      CallSnackbar().callSnackbar(context,
          "An error occurred. Please recheck your inputs and try again.");
    }
  }

  Future<bool> _userExists() async {
    String contactNumber = _contactNumberController.text.trim();

    formattedContactNumber = contactNumber.startsWith('09')
        ? contactNumber.replaceRange(0, 1, '+63')
        : contactNumber;
    final userExists = await firestoreOperations.retrieveCollectionSnapshots(
        'Users',
        where: 'Contact Number',
        equalTo: formattedContactNumber);
    // final userExists = await databaseFirestore
    //     .collection('Users')
    //     .where('Contact Number', isEqualTo: formattedContactNumber)
    //     .get();
    return userExists.docs.isNotEmpty;
  }

  void _showSnackbar(String s, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  void onSubmit() {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        focusNodes[i].requestFocus();
        return;
      }
    }
    trySignUp();
  }
}
