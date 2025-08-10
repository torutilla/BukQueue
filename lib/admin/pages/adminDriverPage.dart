import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_try_thesis/admin/pages/adminBookingHistory.dart';
import 'package:flutter_try_thesis/models/pdfTable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/newTextButton.dart';
import 'package:flutter_try_thesis/models/pdfUtility.dart';
import 'package:flutter_try_thesis/models/todagoPDFformat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printing/printing.dart';

import '../../constants/constants.dart';
import '../../constants/screenSizes.dart';
import '../../constants/utility_widgets/textFields.dart';
import '../databaseTable.dart';

class AdminDriverInfo extends StatefulWidget {
  final ScrollController? scrollController;
  const AdminDriverInfo({super.key, this.scrollController});

  @override
  State<AdminDriverInfo> createState() => _AdminDriverInfoState();
}

Timer? debounce;
bool enableSearch = false;
TextEditingController searchController = TextEditingController();

class _AdminDriverInfoState extends State<AdminDriverInfo> {
  final firestoreInstance = FirebaseFirestore.instance;

  String? status;
  String? type;
  String? zone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: adminGradientColor2,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Column(
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        color: softWhite,
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(color: softWhite),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    setState(() {});
                    final result = await showDialog<Map<String, dynamic>>(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                  height:
                                      ScreenUtil.parentHeight(context) * 0.6,
                                  width: ScreenUtil.parentWidth(context) * 0.9,
                                  child: const FilterDialog(
                                    driverFiltering: true,
                                  )),
                            ],
                          );
                        });

                    if (result != null) {
                      setState(() {
                        if (result['status'] != null) {
                          status = result['status'];
                        }
                        if (result['type'] != null) {
                          type = result['type'];
                        }
                        if (result['zone'] != null) {
                          zone = result['zone'];
                        }
                      });
                    }
                  },
                ),
                // IconButton(
                //   onPressed: () {
                //     showDialog(
                //         barrierColor: Colors.transparent,
                //         context: context,
                //         builder: (context) {
                //           return Stack(
                //             children: [
                //               Positioned(
                //                 left: 20,
                //                 top: 120,
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     boxShadow: [
                //                       BoxShadow(
                //                           offset: Offset(2, 4),
                //                           blurRadius: 8,
                //                           blurStyle: BlurStyle.outer,
                //                           color: Colors.black26)
                //                     ],
                //                     color: adminGradientColor1,
                //                   ),
                //                   width: ScreenUtil.parentWidth(context) * 0.90,
                //                   height: 120,
                //                   child: Column(
                //                     children: [
                //                       TextTitle(text: 'Filters'),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           );
                //         });
                //   },
                //   icon: Column(
                //     children: [
                //       Icon(
                //         Icons.filter_alt_outlined,
                //         color: softWhite,
                //       ),
                //       Text(
                //         'Filter',
                //         style: TextStyle(color: softWhite),
                //       ),
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFieldFormat(
                      enableCustomHeight: true,
                      onChanged: (value) {
                        if (debounce?.isActive ?? false) debounce?.cancel();
                        debounce = Timer(const Duration(seconds: 1), () {
                          setState(() {
                            enableSearch = false;
                          });
                        });
                      },
                      onFieldSubmit: (value) {
                        setState(() {
                          enableSearch = true;
                        });
                      },
                      hintText: 'Search',
                      controller: searchController,
                      fieldHeight: 48,
                      fieldWidth: ScreenUtil.parentWidth(context) * 0.60,
                      borderColor: accentColor,
                      focusedBorderColor: accentColor,
                      backgroundColor: softWhite,
                      customBorderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    Container(
                      height: 48,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: accentColor,
                      ),
                      child: SizedBox(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              enableSearch = true;
                            });
                            // if (debounce?.isActive ?? false) {
                            //   debounce?.cancel();
                            // }
                            // debounce = Timer(Duration(milliseconds: 500), () {
                            //   for (var element in userEntryValues) {
                            //     if (element.values.any((value) => value
                            //         .toString()
                            //         .toLowerCase()
                            //         .contains(
                            //             searchController.text.toLowerCase()))) {
                            //       print('w/ match: $element');
                            //       filteredValues.add(element);
                            //       setState(() {
                            //         userEntryValues = filteredValues;
                            //         //improve condition + add temporary list of values
                            //         // userEntryValues.remove(userEntryValues[i]);
                            //         // i = 0;
                            //       });
                            //     } else {
                            //       print('No match.');
                            //     }
                            //   }
                            // });
                          },
                          icon: const Icon(Icons.search),
                          color: softWhite,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SingleChildScrollView(
              child: DbTableStream(
                  useCustomWidget: true,
                  overlayActions: (snapshot) {
                    return [
                      PopupMenuItem(
                        child: const Text('Print Details'),
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: accentColor,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Please wait...',
                                          style: TextStyle(color: accentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });

                          TodagoPdfFormat pdfFormatTodago = TodagoPdfFormat();
                          PdfTable pdfTable = PdfTable();
                          GeneratePDF generatepdf = GeneratePDF(
                            childWidget: pdfFormatTodago.build(
                              await pdfTable.userInfo(
                                snapshot,
                                isDriver: true,
                              ),
                            ),
                          );
                          final pdf = await generatepdf.createPDF();
                          await Printing.layoutPdf(
                              onLayout: (format) async => pdf);
                          Navigator.of(context).pop();
                        },
                      ),
                      PopupMenuItem(
                        child: Text('View Driver\'s License'),
                        onTap: () async {
                          final licenseFront = await GetPhotoLinkOfUser()
                              .getPhotoLink(snapshot['UID'],
                                  photo: 'License Link 1');
                          final licenseBack = await GetPhotoLinkOfUser()
                              .getPhotoLink(snapshot['UID'],
                                  photo: 'License Link 2');
                          print(licenseBack);
                          if (licenseFront.isNotEmpty &&
                              licenseBack.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: ScreenUtil.parentWidth(context) *
                                            0.9,
                                        height:
                                            ScreenUtil.parentHeight(context) *
                                                0.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) {
                                            return ColoredBox(
                                                color: grayInputBox);
                                          },
                                          imageUrl: licenseFront,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Container(
                                        height:
                                            ScreenUtil.parentHeight(context) *
                                                0.4,
                                        width: ScreenUtil.parentWidth(context) *
                                            0.9,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) {
                                            return ColoredBox(
                                                color: grayInputBox);
                                          },
                                          imageUrl: licenseBack,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            Fluttertoast.showToast(
                              msg: 'No uploaded license',
                            );
                          }
                        },
                      ),
                      if (snapshot['Verification Status'] != 'Verified')
                        PopupMenuItem(
                          child: const Text('Verify Account'),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actionsAlignment: MainAxisAlignment.center,
                                    backgroundColor: adminGradientColor1,
                                    title: const TextTitle(
                                      text: 'Account Verification',
                                      fontSize: 24,
                                      textColor: accentColor,
                                    ),
                                    content: const Text(
                                      textAlign: TextAlign.center,
                                      'Approve or decline account verification requests to control user access.',
                                      style: TextStyle(color: softWhite),
                                    ),
                                    actions: [
                                      CustomTextButton(
                                        backgroundColor: accentColor,
                                        buttonText: 'Verify',
                                        textColor: softWhite,
                                        callback: () {
                                          _updateVerificationStatus(
                                              'Verified', snapshot);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CustomTextButton(
                                        backgroundColor: errorColor,
                                        buttonText: 'Decline',
                                        textColor: softWhite,
                                        callback: () async {
                                          _updateVerificationStatus(
                                              'Denied', snapshot);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      PopupMenuItem(
                        child: Text(
                          AccountUtils.getAccountActionText(snapshot),
                          style: TextStyle(
                            color: AccountUtils.getAccountActionColor(snapshot),
                          ),
                        ),
                        onTap: () => AccountUtils.showAccountActionDialog(
                            context, snapshot),
                      ),
                      if ((snapshot['Request Edit'] ?? '') == 'Pending')
                        PopupMenuItem(
                          child: Text(
                            "Authorize changes to vehicle info",
                            style: TextStyle(
                              color: secondaryColor,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  backgroundColor: adminGradientColor1,
                                  title: TextTitle(
                                    text: 'Authorize Changes',
                                    textColor: accentColor,
                                  ),
                                  content: Text(
                                    textAlign: TextAlign.center,
                                    'Do you want to authorize changes to the vehicle information?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actions: [
                                    CustomTextButton(
                                      backgroundColor: accentColor,
                                      buttonText: 'Yes',
                                      textColor: Colors.white,
                                      callback: () {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(snapshot['docID'])
                                            .update(
                                                {"Request Edit": "Accepted"});
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: 'Authorization successful');
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CustomTextButton(
                                      backgroundColor: errorColor,
                                      buttonText: 'No',
                                      textColor: Colors.white,
                                      callback: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ];
                  },
                  tableInfoTitle: 'Driver Details',
                  stream: _filteredUsers(
                    enableSearch: true,
                    searchQuery: searchController.text,
                    statusFilter: status,
                    vehicleType: type,
                    zoneFilter: zone,
                  ),
                  titles: const [
                    'Verification Status',
                    'Full Name',
                    ''
                  ],
                  columnHeader: const [
                    'Verification Status',
                    // 'UID',
                    'Operator Name',
                    // 'Ownership Type',
                    'Vehicle Type',
                    'Zone Number',
                    'Body Number',
                    'Plate Number',
                    'MTOP Number',
                    'Chassis Number',
                    'OR_CR Number',
                    'OR Expiry Date',
                    'License Expiry',
                    'Restrictions',
                    'License Type',
                    'License Number',
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _getDriverInfoFirestore() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore
        .collection('Users')
        .where('Role', isEqualTo: 'Driver')
        .snapshots()
        .asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        final driverData = doc.data();
        driverData['docID'] = doc.id;
        final vehicleSnapshot = await firestore
            .collection('Users')
            .doc(doc.id)
            .collection('Vehicle Info')
            .get();

        if (vehicleSnapshot.docs.isNotEmpty) {
          final vehicle = vehicleSnapshot.docs.first.data();
          driverData.addEntries(vehicle.entries);
        }

        return driverData;
      }).toList());
    });
  }

  Stream<List<Map<String, dynamic>>> _filteredUsers({
    String? zoneFilter,
    String? vehicleType,
    bool enableSearch = false,
    String? statusFilter,
    String searchQuery = '',
  }) {
    return _getDriverInfoFirestore().map((drivers) {
      return drivers.where((driver) {
        bool matchesZone = true;
        bool matchesType = true;
        bool matchesSearch = true;
        bool matchesStatus = true;

        if (zoneFilter != null && zoneFilter.isNotEmpty) {
          matchesZone = driver['Zone Number'] == zoneFilter;
        }

        if (vehicleType != null && vehicleType.isNotEmpty) {
          matchesType = driver['Vehicle Type'] == vehicleType;
        }

        if (enableSearch && searchQuery.isNotEmpty) {
          matchesSearch = driver.values.any((value) {
            return value
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          });
        }
        if (statusFilter != null && statusFilter.isNotEmpty) {
          matchesStatus = driver['Verification Status'] == statusFilter;
        }
        return matchesZone && matchesType && matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _updateVerificationStatus(String status, snapshot) async {
    final usersRef = firestoreInstance.collection('Users');
    final query =
        await usersRef.where('UID', isEqualTo: snapshot['UID']).limit(1).get();
    await usersRef
        .doc(query.docs.first.id)
        .update({'Verification Status': status}).onError(
      (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An error occured, please try again later.')));
      },
    ).whenComplete(() {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: 'Updated successfully.',
        gravity: ToastGravity.TOP,
      );
    });
  }
}

class AccountUtils {
  static String getAccountActionText(Map<String, dynamic> snapshot) {
    bool isAccountEnabled = snapshot['Account Enabled'] == false;
    return isAccountEnabled ? 'Enable Account' : 'Disable Account';
  }

  static Color getAccountActionColor(Map<String, dynamic> snapshot) {
    bool isAccountEnabled = snapshot['Account Enabled'] == false;
    return isAccountEnabled ? secondaryColor : errorColor;
  }

  static Future<void> showAccountActionDialog(
      BuildContext context, Map<String, dynamic> snapshot) async {
    bool isAccountEnabled = snapshot['Account Enabled'] == false;
    String title = isAccountEnabled ? 'Enable Account' : 'Disable Account';
    String content = isAccountEnabled
        ? 'Do you wish to enable this account?'
        : 'Do you wish to disable this account?';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: adminGradientColor1,
          title: TextTitle(
            text: title,
            textColor: accentColor,
          ),
          content: Text(
            textAlign: TextAlign.center,
            content,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            CustomTextButton(
              backgroundColor: accentColor,
              buttonText: 'Yes',
              textColor: Colors.white,
              callback: () {
                toggleAccountStatus(snapshot, context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            CustomTextButton(
              backgroundColor: errorColor,
              buttonText: 'No',
              textColor: Colors.white,
              callback: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  static Future<void> toggleAccountStatus(
      Map<String, dynamic> snapshot, BuildContext context) async {
    bool isAccountEnabled = snapshot['Account Enabled'] == false;
    bool newStatus = isAccountEnabled ? true : false;
    String successMessage =
        isAccountEnabled ? 'Account Enabled' : 'Account Disabled';

    await FirebaseFirestore.instance
        .collection('Users')
        .where('UID', isEqualTo: snapshot['UID'])
        .get()
        .then((doc) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(doc.docs.first.id)
          .update({"Account Enabled": newStatus});
    });
    await Fluttertoast.showToast(msg: successMessage);
  }
}
