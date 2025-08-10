import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';

import '../../constants/constants.dart';
import '../../constants/screenSizes.dart';
import '../../constants/utility_widgets/textFields.dart';
import '../databaseTable.dart';

class AdminBookingHistory extends StatefulWidget {
  final ScrollController? scrollController;
  const AdminBookingHistory({super.key, this.scrollController});

  @override
  State<AdminBookingHistory> createState() => _AdminBookingHistoryState();
}

Timer? debounce;
bool enableSearch = false;
TextEditingController searchController = TextEditingController();

class _AdminBookingHistoryState extends State<AdminBookingHistory> {
  String status = '';
  DateTimeRange? dateRange;
  String zone = '';

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
                                  child: const FilterDialog()),
                            ],
                          );
                        });

                    if (result != null) {
                      setState(() {
                        if (result['status'] != null) {
                          status = result['status'];
                        }
                        if (result['dateRange'] != null) {
                          DateTimeRange range = result['dateRange'];
                          dateRange = range;
                        }
                        if (result['zone'] != null) {
                          zone = result['zone'];
                        }
                      });
                    }
                  },
                ),
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
                  tableInfoTitle: 'Booking History Details',
                  stream: _filteredBookings(
                    statusFilter: status,
                    enableSearch: true,
                    dateRangeFilter: dateRange,
                    searchQuery: searchController.text,
                    zoneFilter: zone,
                  ),
                  titles: const [
                    'Zone',
                    'Pickup Location',
                    'Dropoff Location',
                    ''
                  ],
                  columnHeader: const [
                    'Booking Status',
                    'Booking ID',
                    'Pickup Location',
                    'Dropoff Location',
                    'Commuter UID',
                    'Commuter Name',
                    'Zone',
                    'Terminal',
                    'Driver UID',
                    'Driver Name',
                    'Time Stamp',
                    'Elapsed',
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _getBookings() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection('Booking_Details').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final bookingData = doc.data();
        return bookingData;
      }).toList();
    });
  }

  // Stream<List<Map<String, dynamic>>> _filteredBookings() {
  //   if (searchController.text.isEmpty && !enableSearch) {
  //     return _getBookings();
  //   } else {
  //     return _getBookings().map((booking) {
  //       return booking.where((e) {
  //         return e.values.any((value) {
  //           return value
  //               .toString()
  //               .toLowerCase()
  //               .contains(searchController.text.toLowerCase());
  //         });
  //       }).toList();
  //     });
  //   }
  // }
  Stream<List<Map<String, dynamic>>> _filteredBookings({
    String? zoneFilter,
    DateTimeRange? dateRangeFilter,
    bool enableSearch = false,
    String? statusFilter,
    String searchQuery = '',
  }) {
    return _getBookings().map((bookings) {
      return bookings.where((booking) {
        bool matchesZone = true;
        bool matchesDateRange = true;
        bool matchesSearch = true;
        bool matchesStatus = true;

        if (zoneFilter != null && zoneFilter.isNotEmpty) {
          matchesZone = booking['Zone'] == zoneFilter;
        }

        if (dateRangeFilter != null) {
          final timestamp = booking['Time Stamp'];
          DateTime? bookingDate;

          if (timestamp is Timestamp) {
            bookingDate = timestamp.toDate();
          }

          if (bookingDate != null) {
            matchesDateRange = bookingDate.isAfter(dateRangeFilter.start
                    .subtract(const Duration(milliseconds: 1))) &&
                bookingDate.isBefore(
                    dateRangeFilter.end.add(const Duration(milliseconds: 1)));
          } else {
            matchesDateRange = false;
          }
        }

        if (enableSearch && searchQuery.isNotEmpty) {
          matchesSearch = booking.values.any((value) {
            return value
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          });
        }
        if (statusFilter != null && statusFilter.isNotEmpty) {
          matchesStatus = booking['Booking Status'] == statusFilter;
        }
        return matchesZone &&
            matchesDateRange &&
            matchesSearch &&
            matchesStatus;
      }).toList();
    });
  }
}

class FilterDialog extends StatefulWidget {
  final bool driverFiltering;
  const FilterDialog({super.key, this.driverFiltering = false});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTimeRange? selectedDateRange;
  String? selectedStatus;
  DateTime? selectedDate;
  String? selectedZone;
  String? vehicleType;
  final List<String> verificationStatuses = ['Pending', 'Verified', 'Denied'];
  final List<String> bookingStatuses = ['Pending', 'Cancelled', 'Completed'];
  final List<String> vehicletypes = [
    'Bukyo',
    'Tricycle',
  ];
  final List<String> zones = [
    'Zone 1',
    'Zone 1-A',
    'Zone 1-B',
    'Zone 1-C',
    'Zone 1-D',
    'Zone 2',
    'Zone 2-A',
    'Zone 3',
    'Zone 3-A',
    'Zone 4',
    'Zone 4-A',
  ];
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: accentColor,
            onPrimary: softWhite,
            secondary: adminGradientColor1,
            onSecondary: Colors.white,
            error: errorColor,
            onError: Colors.white,
            surface: softWhite,
            onSurface: blackColor),
      ),
      child: Card(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextTitle(
                text: 'Filters',
                textColor: accentColor,
              ),
            ),
            const Divider(
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: widget.driverFiltering
                      ? 'Verification Status'
                      : 'Booking Status',
                  border: OutlineInputBorder(),
                ),
                value: selectedStatus,
                items: widget.driverFiltering
                    ? verificationStatuses.map((status) {
                        return DropdownMenuItem(
                            value: status, child: Text(status));
                      }).toList()
                    : bookingStatuses.map((status) {
                        return DropdownMenuItem(
                            value: status, child: Text(status));
                      }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
            ),
            widget.driverFiltering
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Type',
                        border: OutlineInputBorder(),
                      ),
                      value: vehicleType,
                      items: vehicletypes.map((zone) {
                        return DropdownMenuItem(value: zone, child: Text(zone));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          vehicleType = value;
                        });
                      },
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () async {
                        final pickedRange = await showDateRangePicker(
                          context: context,
                          initialDateRange: selectedDateRange,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedRange != null) {
                          setState(() {
                            selectedDateRange = pickedRange;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date Range',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          selectedDateRange != null
                              ? '${selectedDateRange!.start.year}-${selectedDateRange!.start.month.toString().padLeft(2, '0')}-${selectedDateRange!.start.day.toString().padLeft(2, '0')}'
                                  ' to '
                                  '${selectedDateRange!.end.year}-${selectedDateRange!.end.month.toString().padLeft(2, '0')}-${selectedDateRange!.end.day.toString().padLeft(2, '0')}'
                              : 'Select a date range',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Zone',
                  border: OutlineInputBorder(),
                ),
                value: selectedZone,
                items: zones.map((zone) {
                  return DropdownMenuItem(value: zone, child: Text(zone));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedZone = value;
                  });
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                backgroundColor: accentColor,
                onPressedColor: accentColor.withRed(10),
                buttonText: 'Confirm',
                onPressed: () {
                  if (widget.driverFiltering) {
                    Navigator.of(context).pop({
                      'status': selectedStatus,
                      'type': vehicleType,
                      'zone': selectedZone,
                    });
                  } else {
                    Navigator.of(context).pop({
                      'status': selectedStatus,
                      'date': selectedDate,
                      'zone': selectedZone,
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
