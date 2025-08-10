import 'dart:io';
import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_try_thesis/account_management_pages/otpAuth.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linkText.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/driver/account_management/rider_page/vehicleRegistration.dart';
// import 'package:flutter_try_thesis/driver/rider_main_screen/riderMainScreen.dart';
import 'package:flutter_try_thesis/models/providers/userProvider.dart';
import 'package:flutter_try_thesis/models/uploadImage.dart';
import 'package:flutter_try_thesis/routing/router.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadIDCard extends StatefulWidget {
  final String? uid;
  const UploadIDCard({super.key, this.uid});

  @override
  UploadIDCardState createState() => UploadIDCardState();
}

class UploadIDCardState extends State<UploadIDCard> {
  int currIndex = 0;
  final ImagePicker photoPicker = ImagePicker();
  XFile? uploadedImage;
  List<Map<String, dynamic>> uploadedImageList = [];
  ImageUpload imageUpload = ImageUpload();
  ScrollController controller = ScrollController();
  String storagePath = '';
  String pfpStoragePath = '';
  Uint8List? croppedImage;
  File? profilePicture;

  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController restrictionController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController licenseTypeController = TextEditingController();
  GlobalKey<FormState> uploadFormKey = GlobalKey<FormState>();
  Map<String, bool> restrictionCodes = {
    "DL Code A": false,
    "DL Code C": false,
    "DL Code A1": false,
    "DL Code D": false,
    "DL Code B": false,
    "DL Code BE": false,
    "DL Code B1": false,
    "DL Code CE": false,
    "DL Code B2": false,
  };
  @override
  void initState() {
    super.initState();
  }

  void _handleUpload() async {
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

    if (image != null) {
      final size = await image.length();
      final sizeInMB = size / (1024 * 1024);
      setState(() {
        uploadedImageList.add({
          "File": image,
          "Size": '${sizeInMB.toStringAsFixed(2)} MB',
        });
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: uploadFormKey,
            child: Stack(
              children: [
                BackgroundWithColor(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      MainLogo(
                        logoHeight: 120,
                        logoWidth: 120,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 24,
                  left: 8,
                  child: BackbuttoninForm(
                    onPressed: () {
                      MyRouter.navigateToPrevious(context);
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   height: ScreenUtil.parentHeight(context) * 0.20,
                    //   alignment: Alignment.center,
                    //   child: MainLogo(logoHeight: 70, logoWidth: 200),
                    // ),
                    CustomizedCard(
                      enableDraggableScrollable: true,
                      cardWidth: ScreenUtil.parentWidth(context),
                      cardHeight: ScreenUtil.parentHeight(context) * 0.85,
                      cardRadius: 50,
                      childWidget: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const TextTitle(
                                text: 'Profile Picture',
                                textColor: primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (profilePicture == null) {
                                          final photo =
                                              await imageUpload.selectImage();
                                          if (photo != null) {
                                            setState(() {
                                              profilePicture = File(photo.path);
                                            });
                                            // final croppedImage = Crop
                                            // if (croppedImage != null) {
                                            //   profilePicture =
                                            //       File(croppedImage.path);
                                            // }
                                          }
                                        } else {
                                          if (profilePicture != null) {
                                            showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (context) {
                                                  return Image.file(
                                                      profilePicture!);
                                                });
                                          }
                                        }
                                      },
                                      child: CircleAvatar(
                                        foregroundImage: profilePicture != null
                                            ? FileImage(profilePicture!)
                                            : null,
                                        radius: 48,
                                        child: const Icon(Icons.person),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 2,
                                        child: IconButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        accentColor)),
                                            onPressed: () async {
                                              final photo = await imageUpload
                                                  .selectImage();
                                              if (photo != null) {
                                                setState(() {
                                                  profilePicture =
                                                      File(photo.path);
                                                });
                                                // final croppedImage = Crop
                                                // if (croppedImage != null) {
                                                //   profilePicture =
                                                //       File(croppedImage.path);
                                                // }
                                              }
                                            },
                                            icon: const Icon(Icons.edit))),
                                  ],
                                ),
                              ),
                              const Divider(),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextTitle(
                                  text: 'Upload License',
                                  textColor: primaryColor,
                                ),
                              ),

                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(vertical: 8.0),
                              //   child: DropdownMenu(
                              //       onSelected: (value) {
                              //         setState(() {
                              //           restrictionController.text = value!;
                              //         });
                              //       },
                              //       controller: restrictionController,
                              //       menuHeight: 160,
                              //       width:
                              //           ScreenUtil.parentWidth(context) * 0.85,
                              //       enableSearch: true,
                              //       label: const Text('Restriction Code'),
                              //       dropdownMenuEntries: const [
                              //         DropdownMenuEntry(
                              //             value: 'DL Code A: Motorcycle',
                              //             label: 'DL Code A: Motorcycle'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code A1: Tricycle',
                              //             label: 'DL Code A1: Tricycle'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code B: Passenger Car',
                              //             label: 'DL Code B: Passenger Car'),
                              //         DropdownMenuEntry(
                              //             value:
                              //                 'DL Code B1: Passenger Van / Jeepney',
                              //             label:
                              //                 'DL Code B1: Passenger Van / Jeepney'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code B2: Light Commercial',
                              //             label:
                              //                 'DL Code B2: Light Commercial'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code C: Heavy Commercial',
                              //             label: 'DL Code C: Heavy Commercial'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code D: Passenger Bus',
                              //             label: 'DL Code D: Passenger Bus'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code BE: Light Articulated',
                              //             label:
                              //                 'DL Code BE: Light Articulated'),
                              //         DropdownMenuEntry(
                              //             value: 'DL Code CE: Heavy Articulated',
                              //             label:
                              //                 'DL Code CE: Heavy Articulated'),
                              //       ]),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownMenu(
                                    enableFilter: true,
                                    onSelected: (value) {
                                      setState(() {
                                        licenseTypeController.text = value!;
                                      });
                                    },
                                    controller: licenseTypeController,
                                    menuHeight: 160,
                                    width:
                                        ScreenUtil.parentWidth(context) * 0.85,
                                    enableSearch: true,
                                    label: const Text('License Type'),
                                    dropdownMenuEntries: const [
                                      DropdownMenuEntry(
                                          value: 'Professional',
                                          label: 'Professional'),
                                      DropdownMenuEntry(
                                          value: 'Non-Professional',
                                          label: 'Non-Professional'),
                                    ]),
                              ),
                              TextFieldFormat(
                                textCapitalization:
                                    TextCapitalization.characters,
                                controller: licenseNumberController,
                                borderRadius: 8,
                                fieldWidth:
                                    ScreenUtil.parentWidth(context) * 0.85,
                                fieldHeight: 75,
                                formText: 'License Number',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Field can\'t be empty';
                                  }

                                  return null;
                                },
                              ),
                              TextFieldFormat(
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Date cannot be empty';
                                  }

                                  if (!isValidDateYYYYMMDD(input)) {
                                    return 'Invalid date. Try using the date picker instead';
                                  }
                                  return null;
                                },
                                textInputType: TextInputType.datetime,
                                borderRadius: 8,
                                formText: 'Exp. Date (YYYY-MM-DD)',
                                fieldHeight: 70,
                                fieldWidth:
                                    ScreenUtil.parentWidth(context) * 0.85,
                                controller: dateController,
                                suffixIcon: IconButton(
                                  color: primaryColor,
                                  onPressed: () {
                                    _pickDate(context);
                                  },
                                  icon: const Icon(Icons.date_range_rounded),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Driver\'s License Restriction Codes (select all that applies)'),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      children: List.generate(
                                          restrictionCodes.length, (index) {
                                        String keys = restrictionCodes.keys
                                            .elementAt(index);
                                        return SizedBox(
                                          width: 145,
                                          height: 40,
                                          child: CheckboxListTile(
                                            dense: true,
                                            visualDensity:
                                                VisualDensity.compact,
                                            contentPadding: EdgeInsets.all(0),
                                            checkboxShape:
                                                RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 0.5,
                                                        color: secondaryColor)),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: restrictionCodes.values
                                                .elementAt(index),
                                            onChanged: (val) {
                                              setState(() {
                                                restrictionCodes[keys] = val!;
                                              });
                                            },
                                            checkColor: primaryColor,
                                            title: Text(
                                              keys,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      }),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                width: ScreenUtil.parentWidth(context) * 0.80,
                                height: ScreenUtil.parentWidth(context) * 0.50,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: secondaryColor.withOpacity(0.2),
                                ),
                                child: DottedBorder(
                                  color: secondaryColor,
                                  dashPattern: const [6, 3, 6, 3],
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: _handleUpload,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.cloud_upload_rounded,
                                            size: 70,
                                            color: primaryColor,
                                          ),
                                          const TextTitle(
                                            text: 'Upload your files here',
                                            textColor: primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          TextLink(
                                            onPressed: _handleUpload,
                                            linktext: 'Browse',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                'Upload front and back side of license',
                                style: TextStyle(color: accentColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.5, color: secondaryColor),
                                  ),
                                  height:
                                      ScreenUtil.parentHeight(context) * 0.20,
                                  width: ScreenUtil.parentWidth(context) * 0.80,
                                  child: uploadedImageList.isEmpty
                                      ? const Center(
                                          child: Text(
                                          'No uploaded image yet.',
                                          style:
                                              TextStyle(color: secondaryColor),
                                        ))
                                      : Scrollbar(
                                          interactive: true,
                                          thickness: 2,
                                          controller: controller,
                                          child: ListView.builder(
                                            controller: controller,
                                            itemCount: uploadedImageList.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 235, 235, 235),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ListTile(
                                                  trailing: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          uploadedImageList
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.close)),
                                                  title: Text(
                                                    uploadedImageList[index]
                                                            ['File']
                                                        .name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  subtitle: Text(
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                    '${uploadedImageList[index]['Size']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  leading:
                                                      const Icon(Icons.image),
                                                  onTap: () {
                                                    XFile file =
                                                        uploadedImageList[index]
                                                            ['File'];
                                                    showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          content: Image.file(
                                                            File(file.path),
                                                            fit: BoxFit.contain,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                              PrimaryButton(
                                onPressed: () {
                                  if (licenseTypeController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please include your license type')));
                                    return;
                                  }
                                  if (dateController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please include expiration date of your license')));
                                    return;
                                  }
                                  if (licenseNumberController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please include your license number')));
                                    return;
                                  }
                                  if (profilePicture == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please set your profile picture')));
                                    return;
                                  }

                                  if (uploadedImageList.length != 2 ||
                                      uploadedImageList.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please upload front and back side of your license')));
                                    return;
                                  }
                                  if (restrictionCodes['DL Code A'] == false &&
                                      restrictionCodes['DL Code A1'] == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'DL codes need to be either A or A1')));
                                    return;
                                  }
                                  if (uploadFormKey.currentState?.validate() ??
                                      false) {
                                    navigateToNextPage();
                                  }
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return Center(
                                  //         child: CircularProgressIndicator(),
                                  //       );
                                  //     });
                                  // pfpStoragePath = 'userUploads/${widget.uid}';
                                  // imageUpload.uploadImageToFirebase(
                                  //     XFile(profilePicture!.path),
                                  //     pfpStoragePath,
                                  //     (upload) {},
                                  //     _onErrorUpload);

                                  // for (int i = 0;
                                  //     i < uploadedImageList.length;
                                  //     i++) {
                                  //   storagePath =
                                  //       'driverUploads/userDriverLicense_${widget.uid}_${i + 1}';
                                  //   print(storagePath);
                                  //   imageUpload.uploadImageToFirebase(
                                  //     uploadedImageList[i]['File'],
                                  //     storagePath,
                                  //     _handleSuccessfulUpload,
                                  //     _onErrorUpload,
                                  //   );
                                  // }
                                },
                                buttonText: 'Continue',
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _handleSuccessfulUpload(UploadTask uploadTask) async {
  //   final collectionRef = FirebaseFirestore.instance.collection('Users');
  //   await collectionRef
  //       .where('UID', isEqualTo: widget.uid)
  //       .get()
  //       .then((snapshot) async {
  //     for (int i = 0; i < uploadedImageList.length; i++) {
  //       await collectionRef.doc(snapshot.docs.first.id).update({
  //         "License Link ${i + 1}": storagePath,
  //       });
  //     }
  //     await collectionRef
  //         .doc(snapshot.docs.first.id)
  //         .update({"Photo Link": pfpStoragePath});
  //   });

  //   //
  //   Navigator.of(context).pop();
  // }

  // void _onErrorUpload() {
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text(
  //           'An error occured on uploading the file. Please try again later.')));
  // }

  void navigateToNextPage() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.addProfilePhoto(XFile(profilePicture!.path));

    for (int i = 0; i < uploadedImageList.length; i++) {
      XFile file = uploadedImageList[i]['File'];
      provider.addLicensePhotos(file);
    }
    List<String> codesList = [];
    for (int i = 0; i < restrictionCodes.length; i++) {
      if (restrictionCodes.values.elementAt(i)) {
        String code = restrictionCodes.keys.elementAt(i);
        List<String> splittedCode = code.split(' ');
        codesList.add(splittedCode[2]);
      }
    }
    provider.addLicenseInfo(licenseNumberController.text, codesList,
        licenseTypeController.text, dateController.text);
    // print(codesList);

    MyRouter.navigateToNext(context, VehicleRegistration());
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            iconButtonTheme: const IconButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.transparent))),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  surface: Theme.of(context).colorScheme.surface,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
            datePickerTheme: Theme.of(context).datePickerTheme,
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      fieldLabelText: 'Date in MM/DD/YY',
      fieldHintText: 'Select Date',
      errorFormatText: 'Select Date',
      context: context,
      firstDate: DateTime.utc(2023, 01, 01),
      lastDate: DateTime.utc(2040, 12, 31),
    );

    if (picker != null) {
      dateController.text = picker.toString().split(" ")[0];
    }
  }

  bool isValidDateYYYYMMDD(String input) {
    RegExp dateRegex =
        RegExp(r'^(?:\d{4})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$');

    if (!dateRegex.hasMatch(input)) return false;

    // Split input and check valid days per month
    List<String> parts = input.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    List<int> daysInMonth = [
      31,
      _isLeapYear(year) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return day <= daysInMonth[month - 1];
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
