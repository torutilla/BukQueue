import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../constants/screenSizes.dart';
import '../../constants/utility_widgets/textFields.dart';
import '../databaseTable.dart';

class AdminDriverFeedbacks extends StatefulWidget {
  final ScrollController? scrollController;
  const AdminDriverFeedbacks({super.key, this.scrollController});

  @override
  State<AdminDriverFeedbacks> createState() => _AdminDriverFeedbacksState();
}

Timer? debounce;
bool enableSearch = false;
TextEditingController searchController = TextEditingController();

class _AdminDriverFeedbacksState extends State<AdminDriverFeedbacks> {
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
                  tableInfoTitle: 'Driver Details',
                  stream: _filteredUsers(),
                  titles: [
                    'Feedback',
                    'Rating',
                    'Driver UID',
                    ''
                  ],
                  columnHeader: const [
                    'Feedback',
                    'Feedback ID',
                    'Rating',
                    'Driver UID',
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
        .collection('Feedback')
        .snapshots()
        .asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        Map<String, dynamic> map = {};
        map = doc.data();
        map['Feedback ID'] = doc.id;
        return map;
      }).toList());
    });
  }

  Stream<List<Map<String, dynamic>>> _filteredUsers() {
    if (searchController.text.isEmpty && !enableSearch) {
      return _getDriverInfoFirestore();
    } else {
      return _getDriverInfoFirestore().map((user) {
        return user.where((e) {
          return e.values.any((value) {
            return value
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
          });
        }).toList();
      });
    }
  }
}
