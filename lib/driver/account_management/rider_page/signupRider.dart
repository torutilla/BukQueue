// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_try_thesis/account_management_pages/accountChoice.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
// import 'package:flutter_try_thesis/account_management_pages/otpAuth.dart';
import 'package:flutter_try_thesis/account_management_pages/uploadID.dart';
// import 'package:flutter_try_thesis/constants/utility_widgets/alert.dart';
// import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/callSnackbar.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linkText.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
// import 'package:flutter_try_thesis/constants/utility_widgets/roleCheck.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
// import 'package:flutter_try_thesis/driver/account_management/rider_page/vehicleRegistration.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/userProvider.dart';
import 'package:flutter_try_thesis/routing/router.dart';
// import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:provider/provider.dart';
// import 'package:string_validator/string_validator.dart';

class DriverSignUpForm extends StatefulWidget {
  const DriverSignUpForm({super.key});

  @override
  DriverSignUpFormState createState() {
    return DriverSignUpFormState();
  }
}

class DriverSignUpFormState extends State<DriverSignUpForm> {
  static bool removeIcon = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();
  final TextEditingController _suffixNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  FirestoreOperations firestoreOperations = FirestoreOperations();
  String formattedContactNumber = '';
  final ScrollController _formScroller = ScrollController();
  late ValueNotifier<bool> iconNotifier;
  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  late List<TextEditingController> controllers;

  bool isCheckingUser = false;
  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _surNameController.dispose();
    _suffixNameController.dispose();
    _contactNumberController.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    iconNotifier = ValueNotifier(removeIcon);
    controllers = [
      _firstNameController,
      _middleNameController,
      _surNameController,
      _contactNumberController,
      _passwordController,
      _confirmpasswordController,
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
          controller: _formScroller,
          child: Form(
            key: _formKey,
            child: BackgroundWithColor(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: ScreenUtil.parentHeight(context) * 0.20,
                        alignment: Alignment.center,
                        child: MainLogo(logoHeight: 70, logoWidth: 200),
                      ),
                    ],
                  ),
                  CustomizedCard(
                    cardWidth: ScreenUtil.parentWidth(context),
                    cardHeight: ScreenUtil.parentHeight(context) * 0.80,
                    cardRadius: 50.0,
                    enableDraggableScrollable: true,
                    childWidget: LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: iconNotifier,
                            builder: (context, value, child) {
                              return removeIcon
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .keyboard_double_arrow_down_rounded,
                                            size: 32,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .keyboard_double_arrow_up_rounded,
                                            size: 32,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                          const Column(
                            children: [
                              TextTitle(
                                text: 'SIGN UP',
                                textColor: primaryColor,
                              ),
                              Text(
                                'Create your own Driver Account',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                    color: accentColor),
                              ),
                            ],
                          ),
                          ClipRect(
                            child: Container(
                              width: containerWidth =
                                  ScreenUtil.parentWidth(context),
                              height: constraints.maxHeight * 0.7,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFieldFormat(
                                      onFieldSubmit: (value) => onSubmit(),
                                      focusNode: focusNodes[0],
                                      controller: _firstNameController,
                                      borderRadius: 8,
                                      fieldWidth: containerWidth * 0.70,
                                      fieldHeight: 64,
                                      formText: 'First Name',
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
                                      controller: _middleNameController,
                                      borderRadius: 8,
                                      fieldWidth: containerWidth * 0.70,
                                      fieldHeight: 64,
                                      formText: 'Middle Name',
                                      prefixIcon: const Icon(Icons.person),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFieldFormat(
                                          onFieldSubmit: (value) => onSubmit(),
                                          focusNode: focusNodes[2],
                                          controller: _surNameController,
                                          borderRadius: 8,
                                          fieldWidth: containerWidth * 0.50,
                                          fieldHeight: 64,
                                          formText: 'Last Name',
                                          prefixIcon: const Icon(Icons.person),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Field can\'t be empty';
                                            }
                                            return null;
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: TextFieldFormat(
                                            onFieldSubmit: (value) =>
                                                onSubmit(),
                                            key: const ValueKey('suffix'),
                                            controller: _suffixNameController,
                                            borderRadius: 8,
                                            fieldWidth: containerWidth * 0.20,
                                            fieldHeight: 64,
                                            formText: 'Suffix',
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextFieldFormat(
                                      onFieldSubmit: (value) => onSubmit(),
                                      focusNode: focusNodes[3],
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
                                      focusNode: focusNodes[4],
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
                                      focusNode: focusNodes[5],
                                      controller: _confirmpasswordController,
                                      borderRadius: 8,
                                      fieldWidth: containerWidth * 0.70,
                                      fieldHeight: 64,
                                      formText: 'Confirm Password',
                                      enableObscure: true,
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
                            ),
                          ),
                          Column(
                            children: [
                              PrimaryButton(
                                onPressed: () async {
                                  trySignUp();
                                },
                                buttonText: 'Next',
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
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateUserInfo(
    String fullName,
    String contactNumber,
  ) {
    contactNumber = _contactNumberController.text.trim();
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

  void _showSnackbar(String s, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  Future<bool> _userExists() async {
    String contactNumber = _contactNumberController.text.trim();
    String formattedContactNumber = contactNumber.startsWith('09')
        ? contactNumber.replaceRange(0, 1, '+63')
        : contactNumber;
    final userExists = await firestoreOperations.retrieveCollectionSnapshots(
        'Users',
        where: 'Contact Number',
        equalTo: formattedContactNumber);
    return userExists.docs.isNotEmpty;
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

  Future<void> trySignUp() async {
    if (_firstNameController.text.isEmpty &&
        _surNameController.text.isEmpty &&
        _contactNumberController.text.isEmpty &&
        _passwordController.text.isEmpty) {
      _showSnackbar('Please fill in all required fields.', context);
      return;
    }

    if (_passwordController.text != _confirmpasswordController.text) {
      _showSnackbar('Passwords do not match.', context);
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(Duration(seconds: 2), () {
        _updateUserInfo(
          '${_firstNameController.text} ${_middleNameController.text} ${_surNameController.text} ${_suffixNameController.text}',
          _contactNumberController.text,
        );
      });

      Navigator.of(context).pop();

      MyRouter.navigateToNext(context, UploadIDCard());
    } finally {
      isCheckingUser = false;
    }
  }
}
