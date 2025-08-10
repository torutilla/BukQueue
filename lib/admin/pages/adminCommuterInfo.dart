import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/admin/databaseTable.dart';
import 'package:flutter_try_thesis/admin/pages/adminDriverPage.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/textFields.dart';
import 'package:flutter_try_thesis/models/pdfTable.dart';
import 'package:flutter_try_thesis/models/pdfUtility.dart';
import 'package:flutter_try_thesis/models/todagoPDFformat.dart';
import 'package:printing/printing.dart';

class AdminCommuterInfo extends StatefulWidget {
  final ScrollController? scrollController;
  const AdminCommuterInfo({super.key, this.scrollController});

  @override
  State<AdminCommuterInfo> createState() => _AdminCommuterInfoState();
}

class _AdminCommuterInfoState extends State<AdminCommuterInfo> {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String?> label = [];
  List<dynamic> values = [];
  List<String> userEntries = [];
  List<Map<String, dynamic>> userEntryValues = [];
  List<Map<String, dynamic>> filteredValues = [];
  Map<String, List<dynamic>> databaseValues = {};
  OverlayEntry? filterOverlay;
  Timer? debounce;
  TextEditingController dropDownController = TextEditingController();
  bool enableSearch = false;
  List<Map<String, dynamic>> _commuterCache = [];
  // late StreamController<List<Map<String, dynamic>>> _filteredStreamController;

  @override
  void initState() {
    super.initState();
    // _filteredStreamController = StreamController<List<Map<String, dynamic>>>();
    // _initializeData();
    // _initializeDatabaseValues();
  }

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
                      enableCustomHeight: true,
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
                        child: Text('Print Details'),
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
                        child: Text(
                          AccountUtils.getAccountActionText(snapshot),
                          style: TextStyle(
                            color: AccountUtils.getAccountActionColor(snapshot),
                          ),
                        ),
                        onTap: () => AccountUtils.showAccountActionDialog(
                            context, snapshot),
                      ),
                    ];
                  },
                  tableInfoTitle: 'Commuter Details',
                  stream: _filteredUsers(),
                  titles: [
                    'UID',
                    'Full Name',
                    ''
                  ],
                  columnHeader: const [
                    'UID',
                    'Full Name',
                    'Contact Number',
                    'Role'
                  ]),
            ),
            // SingleChildScrollView(
            //     child: Container(
            //         color: adminGradientColor1,
            //         child: SingleChildScrollView(
            //           child: Container(
            //             alignment: userEntryValues.isNotEmpty
            //                 ? null
            //                 : Alignment.center,
            //             height: ScreenUtil.parentHeight(context) * 0.80,
            //             color: adminGradientColor4,
            //             child: userEntryValues.isNotEmpty
            //                 ? DataTable(
            //                     clipBehavior: Clip.antiAlias,
            //                     columnSpacing: 10,
            //                     columns: List.generate(2, (labelIndex) {
            //                       return DataColumn(
            //                         label: Text(
            //                           '${userEntryValues[0].keys.elementAt(labelIndex)}',
            //                           style: TextStyle(color: softWhite),
            //                         ),
            //                       );
            //                     }),
            //                     rows: List.generate(userEntryValues.length,
            //                         (rowIndex) {
            //                       return DataRow(
            //                         cells: List.generate(2, (cellIndex) {
            //                           var value =
            //                               userEntryValues[rowIndex].values;
            //                           return DataCell(
            //                             Row(
            //                               children: [
            //                                 Container(
            //                                   width: ScreenUtil.parentWidth(
            //                                           context) *
            //                                       0.34,
            //                                   child: Text(
            //                                     '${value.elementAt(cellIndex)}',
            //                                     style: TextStyle(
            //                                         color: softWhite,
            //                                         overflow:
            //                                             TextOverflow.ellipsis),
            //                                   ),
            //                                 ),
            //                                 Spacer(),
            //                                 cellIndex == 1
            //                                     ? Padding(
            //                                         padding:
            //                                             const EdgeInsets.only(
            //                                                 left: 16.0),
            //                                         child: IconButton(
            //                                           onPressed: () {
            //                                             showOverlayDialog(
            //                                                 rowIndex);
            //                                           },
            //                                           icon: Icon(
            //                                               Icons.open_in_new),
            //                                         ),
            //                                       )
            //                                     : SizedBox.shrink()
            //                               ],
            //                             ),
            //                           );
            //                         }),
            //                       );
            //                     }),
            //                   )
            //                 : CircularProgressIndicator(
            //                     color: accentColor,
            //                   ),
            //           ),
            //         )))
          ],
        ),
      ),
    );
  }

  // Future<void> _initializeDatabaseValues() async {
  //   CollectionReference collectionReference =
  //       firestore.collection('User_Commuter');

  //   var loadUserIDs = await collectionReference.get();
  //   userEntries = loadUserIDs.docs.map((doc) => doc.id).toList();

  //   collectionReference.snapshots().listen((event) {
  //     userEntries.clear();
  //     for (int i = 0; i < event.docs.length; i++) {
  //       if (!userEntries.contains(event.docs[i].id)) {
  //         setState(() {
  //           userEntries.add(event.docs[i].id);
  //           userEntryValues.clear();
  //           for (var doc in event.docs) {
  //             var changedDoc = doc.data() as Map<String, dynamic>;
  //             userEntryValues.add(changedDoc);
  //           }
  //         });
  //       }
  //     }

  //     for (var change in event.docChanges) {
  //       if (change.type == DocumentChangeType.modified) {
  //         var document = change.doc.data() as Map<String, dynamic>;
  //         for (var docEntry in document.entries) {
  //           setState(() {
  //             userEntryValues[change.oldIndex][docEntry.key] = docEntry.value;
  //             // databaseValues[docEntry.key]?[change.oldIndex] = docEntry.value;
  //           });
  //         }
  //       }
  //     }
  //   });

  //   List<DocumentSnapshot> snapshots = await Future.wait(
  //       userEntries.map((id) => collectionReference.doc(id).get()));

  //   for (var snapshot in snapshots) {
  //     if (snapshot.exists && snapshot.data() != null) {
  //       var data = snapshot.data() as Map<String, dynamic>;

  //       // for (var entry in data.entries) {
  //       //   if (databaseValues.containsKey(entry.key)) {
  //       //     setState(() {
  //       //       databaseValues[entry.key]!.add(entry.value);
  //       //     });
  //       //   } else {
  //       //     setState(() {
  //       //       databaseValues[entry.key] = [entry.value];
  //       //     });
  //       //   }
  //       // }
  //       setState(() {
  //         if (userEntryValues.isEmpty) {
  //           userEntryValues.add(data);
  //         }
  //       });
  //     } else {
  //       print('Document does not exist or data is null.');
  //     }
  //   }
  // }

  // void showOverlayDialog(int userIndex) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Container(
  //             decoration: BoxDecoration(
  //                 color: adminGradientColor2,
  //                 borderRadius: BorderRadius.circular(8)),
  //             height: ScreenUtil.parentHeight(context) * 0.70,
  //             width: ScreenUtil.parentWidth(context) * 0.90,
  //             child: LayoutBuilder(builder: (context, constraints) {
  //               return Column(
  //                 children: [
  //                   AppBar(
  //                     backgroundColor: adminGradientColor1,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(8),
  //                       topRight: Radius.circular(8),
  //                     )),
  //                     leading:
  //                         IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
  //                     actions: [
  //                       IconButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         icon: SvgPicture.asset(
  //                           'assets/images/Icons/quit-pip-svgrepo-com.svg',
  //                           colorFilter:
  //                               ColorFilter.mode(accentColor, BlendMode.srcIn),
  //                         ),
  //                       ),
  //                     ],
  //                     centerTitle: true,
  //                     title: TextTitle(
  //                       text: 'Commuter Details',
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                   Divider(
  //                     color: adminGradientColor1,
  //                     thickness: 0.5,
  //                   ),
  //                   SizedBox(
  //                     width: constraints.maxWidth * 0.90,
  //                     height: constraints.maxHeight * 0.80,
  //                     child: LayoutBuilder(builder: (context, constraints) {
  //                       return GridView.count(
  //                           childAspectRatio:
  //                               (constraints.maxHeight / constraints.maxWidth),
  //                           crossAxisSpacing: 8,
  //                           crossAxisCount: 2,
  //                           mainAxisSpacing: 8,
  //                           children: List.generate(4, (valueIndex) {
  //                             final filteredValues =
  //                                 userEntryValues.map((entry) {
  //                               return {
  //                                 "ID": entry['ID'],
  //                                 "Full Name": entry['Full Name'],
  //                                 "Contact Number": entry['Contact Number'],
  //                                 "Role": entry['Role'],
  //                               };
  //                             }).toList();
  //                             return Column(
  //                               children: [
  //                                 Container(
  //                                   decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(4),
  //                                       border: Border.all(
  //                                           color: adminGradientColor1,
  //                                           width: 0.5)),
  //                                   height: 80,
  //                                   width: 140,
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           '${filteredValues[userIndex].keys.elementAt(valueIndex)}',
  //                                           style: TextStyle(
  //                                             color: accentColor,
  //                                             fontSize: 14,
  //                                             fontWeight: FontWeight.w500,
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           '${filteredValues[userIndex].values.elementAt(valueIndex)}',
  //                                           style: TextStyle(
  //                                             color: softWhite,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             );
  //                           }));
  //                     }),
  //                   ),
  //                 ],
  //               );
  //             })),
  //       );
  //     },
  //   );
  // }

  Stream<List<Map<String, dynamic>>> _getCommuterInfoInFirestore() {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('Role', isEqualTo: 'Commuter')
        .snapshots()
        .map((snapshot) {
      _commuterCache = snapshot.docs.map((doc) => doc.data()).toList();
      return _commuterCache;
    });
  }

  Stream<List<Map<String, dynamic>>> _filteredUsers() {
    return _getCommuterInfoInFirestore().map((users) {
      if (searchController.text.isEmpty && !enableSearch) {
        return users;
      } else {
        return _commuterCache.where((e) {
          return e.values.any((value) {
            return value
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
          });
        }).toList();
      }
    });
  }
}
