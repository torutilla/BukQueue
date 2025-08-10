import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/callSnackbar.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/errorScreen.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/newTextButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/constants/zones.dart';
import 'package:flutter_try_thesis/drawer_pages/unsavedChangesNotifier.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/cachedDocumentId.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/dateTimeConverter.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:flutter_try_thesis/models/uploadImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final bool isDriver;
  const EditProfile({super.key, this.isDriver = false});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  final GlobalKey<_UserEditProfileState> _commuterEditProfileKey =
      GlobalKey<_UserEditProfileState>();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Consumer<UnsavedChangesNotifier>(builder: (context, provider, _) {
        return provider.unsavedChanges
            ? Container(
                margin: const EdgeInsets.only(top: 16),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (_debounce?.isActive ?? false) {
                      _debounce?.cancel();
                    }
                    _debounce = Timer(Duration(milliseconds: 500), () {
                      _commuterEditProfileKey.currentState?._saveChanges();
                      provider.unsaved(false);
                      provider.editState(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved.')));
                    });
                  },
                  child: const Icon(Icons.save),
                ),
              )
            : const SizedBox.shrink();
      }),
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          style:
              const ButtonStyle(backgroundColor: WidgetStateColor.transparent),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: softWhite,
              ),
        ),
      ),
      body: SingleChildScrollView(
          child: UserEditProfile(
        isDriver: widget.isDriver,
        key: _commuterEditProfileKey,
      )),
    );
  }
}

class UserEditProfile extends StatefulWidget {
  final bool isDriver;
  const UserEditProfile({super.key, required this.isDriver});

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  ImageUpload uploadImage = ImageUpload();
  List<bool> editingState = [false, false];
  String oldName = '';
  String oldContact = '';
  final ImagePicker photoPicker = ImagePicker();
  XFile? fetchedImage;
  String docID = '';
  String uid = '';
  String photoPath = '';
  final firestoreInstance = FirebaseFirestore.instance;
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  CachedDocument docCache = CachedDocument();
  String pastUID = '';

  String requestEditStatus = '';

  Map<String, dynamic> vehicleTypes = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCommuterData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(
              loadingText: 'Loading...',
            );
          }
          if (snapshot.hasData) {
            nameController.text = snapshot.data!['Full Name'];
            contactController.text = snapshot.data!['Contact Number'];
            oldName = nameController.text;
            oldContact = contactController.text;
            return Consumer<UnsavedChangesNotifier>(
                builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ScreenUtil.parentWidth(context),
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (photoPath.isNotEmpty && provider.image == null)
                          BackgroundWithColor(
                            child: Opacity(
                                opacity: 0.5,
                                child: CachedNetworkImage(
                                  imageUrl: photoPath,
                                  fit: BoxFit.cover,
                                )),
                          )
                        else
                          BackgroundWithColor(
                            child: Opacity(
                              opacity: 0.2,
                              child: provider.image != null && uid == pastUID
                                  ? Image.file(
                                      File(provider.image!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        Container(
                          child: Stack(
                            children: [
                              if (photoPath.isNotEmpty &&
                                  provider.image == null)
                                CircleAvatar(
                                  foregroundImage:
                                      CachedNetworkImageProvider(photoPath),
                                  radius: 54,
                                  child: const Icon(
                                    Icons.person,
                                    size: 48,
                                  ),
                                )
                              else
                                CircleAvatar(
                                  foregroundImage: provider.image != null
                                      ? FileImage(File(provider.image!.path))
                                      : null,
                                  radius: 54,
                                  child: const Icon(
                                    Icons.person,
                                    size: 48,
                                  ),
                                ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: IconButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  secondaryColor)),
                                      onPressed: () {
                                        _handleUpload(provider);
                                      },
                                      icon: const Icon(Icons.edit))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: TextTitle(
                              text: 'Personal Information',
                              textColor: primaryColor,
                            ),
                          ),
                          const Text('Full Name'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 80,
                                width: ScreenUtil.parentWidth(context) - 90,
                                child: TextFieldFormat(
                                  onChanged: (val) {
                                    provider.unsaved(true);
                                    nameController.text = val!;
                                  },
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    size: 24,
                                  ),
                                  enabled: provider.canEdit,
                                  controller: nameController,
                                  borderRadius: 8,
                                ),
                              ),
                              IconButton(
                                color: accentColor,
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStateColor.transparent),
                                onPressed: () {
                                  provider.editState(!provider.canEdit);
                                },
                                icon: Icon(provider.canEdit
                                    ? Icons.check
                                    : Icons.edit),
                              ),
                            ],
                          ),
                          const Text('Contact Number'),
                          SizedBox(
                            height: 80,
                            width: ScreenUtil.parentWidth(context) * .90,
                            child: TextFieldFormat(
                              prefixIcon: const Icon(
                                Icons.phone,
                                size: 24,
                              ),
                              enabled: editingState[1],
                              controller: contactController,
                              borderRadius: 8,
                            ),
                          ),
                          if (widget.isDriver)
                            SizedBox(
                              height: 500,
                              child: DriverProfileInformation(
                                  onRequestStateEdit: () => setState(() {}),
                                  onSavedChanges: () {
                                    setState(() {});
                                  },
                                  vehicleTypes: vehicleTypes,
                                  editRequestStatus: requestEditStatus,
                                  docID: docID,
                                  driverData: snapshot.data!),
                            ),
                        ],
                      )),
                ],
              );
            });
          }
          return const ErrorScreen();
        });
  }

  Future<Map<String, dynamic>> _getCommuterData() async {
    final provider = Provider.of<BookingProvider>(context, listen: false);
    uid = provider.bookingUserInfo['UID'];
    pastUID = await sharedPreferences.readCacheString('UID') ?? '';
    print(uid);
    docID = await docCache.getDocumentId() ?? '';

    final snapshot =
        await firestoreInstance.collection('Users').doc(docID).get();
    // final snapshot = await firestoreInstance
    //     .collection('Users')
    //     .where('UID', isEqualTo: uid)
    //     .limit(1)
    //     .get();
    // docID = snapshot.docs.first.id;
    // final data = snapshot.docs.first.data();
    final data = snapshot.data() ?? {};
    requestEditStatus = data['Request Edit'] ?? 'No Request';

    // if (data['Role'] == 'Driver') {
    //   final vehicles = await firestoreInstance
    //       .collection('Vehicle_Types')
    //       .doc('Vehicles')
    //       .get();
    // }
    vehicleTypes = data;
    if (data['Photo Link'] != null) {
      photoPath = data['Photo Link'];
      print(photoPath);
    }
    return data;
  }

  void _handleUpload(UnsavedChangesNotifier provider) async {
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
    XFile? image = await photoPicker.pickImage(source: ImageSource.gallery);

    provider.updateImage(image!);
    provider.unsavedChanges = true;

    Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pop();
  }

  Future<void> _saveChanges() async {
    final provider = _getChangesProvider();
    if (provider.image != null) {
      await uploadImage.uploadImageToFirebase(
          provider.image!, 'userUploads/$uid', (uploadTask, url) {
        firestoreInstance
            .collection('Users')
            .doc(docID)
            .update({"Photo Link": url});
        sharedPreferences.addToCache({'Photo Link': url});
      }, () {});
      setState(() {});
    }
    if (oldName.toLowerCase() != nameController.text.toLowerCase()) {
      firestoreInstance
          .collection('Users')
          .doc(docID)
          .update({"Full Name": nameController.text});
      await sharedPreferences.addToCache({"Full Name": nameController.text});
    }
  }

  UnsavedChangesNotifier _getChangesProvider() {
    return Provider.of<UnsavedChangesNotifier>(context, listen: false);
  }
}

class DriverEditProfile extends StatefulWidget {
  final String? uid;
  const DriverEditProfile({super.key, this.uid});

  @override
  State<DriverEditProfile> createState() => _DriverEditProfileState();
}

class _DriverEditProfileState extends State<DriverEditProfile> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: null,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenUtil.parentWidth(context),
                height: 240,
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    BackgroundWithColor(),
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 48,
                      ),
                      radius: 54,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextTitle(
                      text: 'Personal Information',
                      textColor: primaryColor,
                    ),
                    const Text('Full Name'),
                    SizedBox(
                      height: 80,
                      width: ScreenUtil.parentWidth(context),
                      child: TextFieldFormat(
                        enabled: false,
                        controller: nameController,
                        borderRadius: 8,
                      ),
                    ),
                    const Text('Contact Number'),
                    SizedBox(
                      height: 80,
                      width: ScreenUtil.parentWidth(context),
                      child: TextFieldFormat(
                        enabled: false,
                        controller: nameController,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class DriverProfileInformation extends StatefulWidget {
  final Map<String, dynamic> driverData;
  final String docID;
  final String editRequestStatus;
  final Map<String, dynamic> vehicleTypes;
  final void Function() onSavedChanges;
  final void Function() onRequestStateEdit;
  const DriverProfileInformation(
      {super.key,
      required this.driverData,
      required this.docID,
      required this.editRequestStatus,
      required this.vehicleTypes,
      required this.onSavedChanges,
      required this.onRequestStateEdit});

  @override
  State<DriverProfileInformation> createState() =>
      _DriverProfileInformationState();
}

class _DriverProfileInformationState extends State<DriverProfileInformation>
    with TickerProviderStateMixin {
  late TabController tabController;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  Map<String, String> newValues = {};
  bool requestSent = false;
  bool editingOngoing = true;
  Timer? debouncer;
  List<String> titles = [
    'Vehicle Type',
    'Operator Name',
    'Body Number',
    'Chassis Number',
    'MTOP Number',
    'Plate Number',
    'Zone Number',
    'OR_CR Number',
    'OR Expiry Date'
  ];
  Timer? editingDebounce;
  GlobalKey<FormState> editVehicleInfoKey = GlobalKey<FormState>();
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    controllers = List.generate(widget.driverData.length, (index) {
      return TextEditingController();
    });
    focusNodes = List.generate(widget.driverData.length, (index) {
      return FocusNode();
    });
    for (int i = 0; i < titles.length; i++) {
      String keys = titles[i];
      dynamic values = widget.driverData[keys];

      controllers[i].text = values.toString();
      newValues[keys] = values;
    }
    super.initState();
  }

  void updateFields(String field, int controllerIndex) {
    setState(() {
      String key = field;
      controllers[controllerIndex].text = newValues[key] ?? "";
    });
    print(controllers[controllerIndex].text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            TabBar(dividerHeight: 0.2, controller: tabController, tabs: [
              Tab(
                text: 'Vehicle',
              ),
              Tab(
                text: 'License',
              )
            ]),
            Container(
              padding: EdgeInsets.all(16),
              height: 450,
              child: TabBarView(controller: tabController, children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.editRequestStatus == "Accepted" &&
                              editingOngoing
                          ? PrimaryButton(
                              onPressed: () {
                                print('Pressed');
                                validateChanges();
                              },
                              buttonText: 'Save Changes',
                              backgroundColor: accentColor,
                            )
                          : PrimaryButton(
                              backgroundColor:
                                  widget.editRequestStatus == "Pending" ||
                                          requestSent
                                      ? errorColor
                                      : primaryColor,
                              onPressed: () {
                                if (editingDebounce?.isActive ?? false) {
                                  editingDebounce?.cancel();
                                }
                                editingDebounce =
                                    Timer(Duration(milliseconds: 500), () {
                                  if (widget.editRequestStatus ==
                                      "No Request") {
                                    addRequestoToDatabase();
                                  } else {
                                    cancelRequest();
                                  }
                                  setState(() {
                                    requestSent = !requestSent;
                                  });
                                  widget.onRequestStateEdit();
                                });
                              },
                              buttonText:
                                  widget.editRequestStatus == "Pending" ||
                                          requestSent
                                      ? 'Cancel Request'
                                      : 'Request Edit',
                            ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              widget.editRequestStatus == "Accepted" &&
                                      editingOngoing
                                  ? 1
                                  : 8, (index) {
                            // var value = widget.driverData[titles[index]];

                            return widget.editRequestStatus == "Accepted" &&
                                    editingOngoing
                                ? textEditingBox(context)
                                : infoBox(titles[index],
                                    widget.driverData[titles[index]], context);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: List.generate(4, (index) {
                      List<String> titles = [
                        'License Number',
                        'License Expiry',
                        'License Type',
                        'Restrictions',
                      ];
                      var value = widget.driverData[titles[index]];

                      return infoBox(
                          titles[index],
                          value is Timestamp
                              ? DateTimeConvert().convertTimeStampToDate(value)
                              : value,
                          context);
                    }),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget textEditingBox(BuildContext context) {
    double containerWidth = ScreenUtil.parentWidth(context);
    return Form(
      key: editVehicleInfoKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   title,
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleSmall!
          //       .copyWith(color: accentColor),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: DropdownMenu(
                initialSelection: controllers[0].text,
                onSelected: (value) => focusNodes[1].requestFocus(),
                focusNode: focusNodes[0],
                controller: controllers[0],
                menuHeight: 150,
                width: containerWidth * 0.8,
                enableSearch: true,
                label: const Text('Vehicle Type'),
                dropdownMenuEntries:
                    List.generate(widget.vehicleTypes.length, (index) {
                  return DropdownMenuEntry(
                      value: '${widget.vehicleTypes.values.elementAt(index)}',
                      label: '${widget.vehicleTypes.values.elementAt(index)}');
                })),
          ),
          TextFieldFormat(
            onChanged: (value) {
              if (debouncer?.isActive ?? false) {
                debouncer?.cancel();
              }
              debouncer = Timer(
                Duration(milliseconds: 500),
                () {
                  setState(() {
                    controllers[1].text = value!;
                  });
                  // print(controllers[1].text);
                },
              );
            },
            onFieldSubmit: (value) => focusNodes[2].requestFocus(),
            focusNode: focusNodes[1],
            textCapitalization: TextCapitalization.characters,
            controller: controllers[1],
            borderRadius: 8,
            fieldWidth: containerWidth * 0.8,
            fieldHeight: 64,
            formText: 'Operator Name',
          ),
          TextFieldFormat(
            onChanged: (value) {
              if (debouncer?.isActive ?? false) {
                debouncer?.cancel();
              }
              debouncer = Timer(
                Duration(milliseconds: 500),
                () {
                  setState(() {
                    controllers[2].text = value!;
                  });
                  // print(controllers[1].text);
                },
              );
            },
            textInputType: TextInputType.number,
            onFieldSubmit: (value) => focusNodes[3].requestFocus(),
            focusNode: focusNodes[2],
            textCapitalization: TextCapitalization.characters,
            controller: controllers[2],
            borderRadius: 8,
            fieldWidth: containerWidth * 0.8,
            fieldHeight: 64,
            formText: 'Body Number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field can\'t be empty';
              }
              final regex = RegExp(r'^[0-9]{4}$');

              if (!regex.hasMatch(value)) {
                return 'Invalid Body Number';
              }
              return null;
            },
          ),
          TextFieldFormat(
            onChanged: (value) {
              if (debouncer?.isActive ?? false) {
                debouncer?.cancel();
              }
              debouncer = Timer(
                Duration(milliseconds: 500),
                () {
                  setState(() {
                    controllers[3].text = value!;
                  });
                  // print(controllers[1].text);
                },
              );
            },
            onFieldSubmit: (value) => focusNodes[4].requestFocus(),
            focusNode: focusNodes[3],
            textCapitalization: TextCapitalization.characters,
            controller: controllers[3],
            borderRadius: 8,
            fieldWidth: containerWidth * 0.8,
            fieldHeight: 64,
            formText: 'Chassis Number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field can\'t be empty';
              }
              final regex = RegExp(r'^[A-Z0-9]{1,}$');
              if (!regex.hasMatch(value)) {
                return 'Invalid Chassis Number';
              }
              return null;
            },
          ),
          TextFieldFormat(
            onChanged: (value) {
              if (debouncer?.isActive ?? false) {
                debouncer?.cancel();
              }
              debouncer = Timer(
                Duration(milliseconds: 500),
                () {
                  setState(() {
                    controllers[4].text = value!;
                  });
                  // print(controllers[1].text);
                },
              );
            },
            onFieldSubmit: (value) => focusNodes[5].requestFocus(),
            focusNode: focusNodes[4],
            textCapitalization: TextCapitalization.characters,
            controller: controllers[4],
            borderRadius: 8,
            fieldWidth: containerWidth * 0.8,
            fieldHeight: 64,
            formText: 'MTOP Number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field can\'t be empty';
              }
              final regex = RegExp(r'^[A-Z0-9]');
              if (!regex.hasMatch(value)) {
                return 'Invalid MTOP Number';
              }
              return null;
            },
          ),
          TextFieldFormat(
            onChanged: (value) {
              if (debouncer?.isActive ?? false) {
                debouncer?.cancel();
              }
              debouncer = Timer(
                Duration(milliseconds: 500),
                () {
                  setState(() {
                    controllers[5].text = value!;
                  });
                  // print(controllers[1].text);
                },
              );
            },
            onFieldSubmit: (value) => focusNodes[6].requestFocus(),
            focusNode: focusNodes[5],
            textCapitalization: TextCapitalization.characters,
            controller: controllers[5],
            borderRadius: 8,
            fieldWidth: containerWidth * 0.8,
            fieldHeight: 64,
            formText: 'Plate Number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field can\'t be empty';
              }
              final regex = RegExp(r'^[A-Z0-9]{3}[0-9]*$');
              if (!regex.hasMatch(value)) {
                return 'Invalid Plate Number';
              }

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: DropdownMenu(
              initialSelection: controllers[6].text,
              onSelected: (value) => focusNodes[7].requestFocus(),
              focusNode: focusNodes[6],
              controller: controllers[6],
              menuHeight: 160,
              width: containerWidth * 0.8,
              enableSearch: true,
              label: const Text('Zone'),
              dropdownMenuEntries: List.generate(
                zoneList.length,
                (index) {
                  return DropdownMenuEntry(
                      value: zoneList.keys.elementAt(index),
                      label: zoneList.keys.elementAt(index));
                },
              ),
            ),
          ),
          TextFieldFormat(
            onChanged: (value) {
              if (debouncer?.isActive ?? false) {
                debouncer?.cancel();
              }
              debouncer = Timer(
                Duration(milliseconds: 500),
                () {
                  setState(() {
                    controllers[7].text = value!;
                  });
                  // print(controllers[1].text);
                },
              );
            },
            textCapitalization: TextCapitalization.characters,
            focusNode: focusNodes[7],
            controller: controllers[7],
            borderRadius: 8,
            fieldWidth: containerWidth * 0.8,
            fieldHeight: 64,
            formText: 'OR/CR Number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field can\'t be empty';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget infoBox(
    String title,
    String value,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: accentColor),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 60,
            width: ScreenUtil.parentWidth(context) * .90,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: grayInputBox,
                ),
              ),
              child: Text(value),
            )),
      ],
    );
  }

  Future<void> addRequestoToDatabase() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.docID)
        .update({"Request Edit": "Pending"});
  }

  // void onSubmit() {
  //   for (int i = 0; i < controllers.length; i++) {
  //     focusNodes[i].requestFocus();
  //   }
  // }

  void validateChanges() {
    if (controllers[0].text != 'Tricycle' && controllers[0].text != 'Bukyo') {
      CallSnackbar().callSnackbar(context,
          'Invalid vehicle type. Ensure that your input is within the selection');
      return;
    }

    if (!zoneList.keys.contains(controllers[6].text)) {
      CallSnackbar().callSnackbar(context,
          'Invalid zone. Ensure that your input is within the selection');

      return;
    }
    if (editVehicleInfoKey.currentState?.validate() ?? false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: softWhite,
              title: const TextTitle(
                text: 'Save Changes',
                fontSize: 24,
                textColor: primaryColor,
              ),
              content: const Text(
                textAlign: TextAlign.center,
                'Are you sure you want to apply these changes?',
                style: TextStyle(color: blackColor),
              ),
              actions: [
                CustomTextButton(
                  backgroundColor: primaryColor,
                  buttonText: 'Yes',
                  textColor: softWhite,
                  callback: () {
                    updateVehicleInfo();
                    Navigator.of(context).pop();
                    setState(() {
                      requestSent = false;
                      editingOngoing = false;
                    });
                    if (editingOngoing == false) {
                      Future.delayed(
                        Duration(milliseconds: 500),
                        () {
                          widget.onSavedChanges();
                        },
                      );
                    }
                  },
                ),
                CustomTextButton(
                  backgroundColor: errorColor,
                  buttonText: 'No',
                  textColor: softWhite,
                  callback: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      print('Not Valid');
    }
  }

  Future<void> updateVehicleInfo() async {
    final docRef =
        FirebaseFirestore.instance.collection('Users').doc(widget.docID);
    await docRef.collection('Vehicle Info').limit(1).get().then((query) async {
      String firstDoc = query.docs.first.id;
      if (query.docs.isEmpty) {
        print("No vehicle info documents found.");
        return;
      }
      Map<String, dynamic> updatedData = {};
      for (int i = 0; i < titles.length; i++) {
        updatedData[titles[i]] = controllers[i].text;
      }
      await docRef
          .collection('Vehicle Info')
          .doc(firstDoc)
          .update(updatedData)
          .then(
        (value) {
          docRef.update({"Request Edit": "No Request"});
          print(updatedData);
        },
      );

      await UserSharedPreferences().addToCache({
        "Zone Number": updatedData["Zone Number"],
        "Vehicle Type": updatedData["Vehicle Type"]
      });
    });
  }

  Future<void> cancelRequest() async {
    print('cancelled');
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.docID)
        .update({"Request Edit": "No Request"});
  }
}
