import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/bookingDetailsContent.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/providers/historyProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RiderBookingHistory extends StatefulWidget {
  final String uid;
  const RiderBookingHistory({super.key, required this.uid});

  @override
  State<RiderBookingHistory> createState() => _RiderBookingHistoryState();
}

class _RiderBookingHistoryState extends State<RiderBookingHistory>
    with TickerProviderStateMixin {
  late TabController mainTabController;

  @override
  void initState() {
    super.initState();
    mainTabController = TabController(length: 2, vsync: this);
  }

// need to add localstorage or sqlite to save history locally. hays
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(ScreenUtil.parentWidth(context), 80),
        child: TabBar(
          dividerColor: primaryColor,
          controller: mainTabController,
          tabs: [
            Tab(
              text: 'Cancelled',
            ),
            Tab(
              text: 'Completed',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: mainTabController,
        children: [
          CancelledBookings(),
          CompletedBookings(),
        ],
      ),
    );
  }
}

class StreamBookings {
  Stream<List<Map<String, dynamic>>> getBookingHistoryStream(
      String status, uid) {
    print("Stream Booking current UID: $uid");
    print(uid);
    return FirebaseFirestore.instance
        .collection('Booking_Details')
        .where('Driver UID', isEqualTo: uid)
        .where('Booking Status', isEqualTo: status)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => doc.data()).toList());
  }
}

class CancelledBookings extends StatefulWidget {
  const CancelledBookings({super.key});

  @override
  State<CancelledBookings> createState() => _CancelledBookingsState();
}

class _CancelledBookingsState extends State<CancelledBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryStreamWidget(bookingStatus: 'Cancelled'),
    );
  }
}

class HistoryStreamWidget extends StatefulWidget {
  final String bookingStatus;
  HistoryStreamWidget({super.key, required this.bookingStatus});

  @override
  State<HistoryStreamWidget> createState() => _HistoryStreamWidgetState();
}

class _HistoryStreamWidgetState extends State<HistoryStreamWidget> {
  final FormattedDateAndTime formatDatetime = FormattedDateAndTime();

  final StreamBookings streamBookings = StreamBookings();
  @override
  void initState() {
    initializeSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSharedPrefs(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: streamBookings.getBookingHistoryStream(
                  widget.bookingStatus, snapshot.data),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  print(snapshot.data);
                  final cancelledBookings = snapshot.data!;
                  return ListView.builder(
                      itemCount: cancelledBookings.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: widget.bookingStatus == 'Completed'
                                      ? secondaryColor
                                      : errorColor,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          width:
                                              ScreenUtil.parentWidth(context) *
                                                  0.95,
                                          height:
                                              ScreenUtil.parentHeight(context) *
                                                  0.8,
                                          decoration: BoxDecoration(
                                              color: softWhite,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: BookingInformationContent(
                                              notes: cancelledBookings[index]
                                                  ['Note'],
                                              pickupLocation:
                                                  cancelledBookings[index]
                                                      ['Pickup Location'],
                                              dropoffLocation:
                                                  cancelledBookings[index]
                                                      ['Dropoff Location'],
                                              bookingID: cancelledBookings[index]
                                                  ['Booking ID'],
                                              date: formatDatetime.getDateStamp(
                                                  cancelledBookings[index]
                                                      ['Time Stamp']),
                                              time: formatDatetime.getTimeStamp(
                                                  cancelledBookings[index]
                                                      ['Time Stamp']),
                                              price:
                                                  '${cancelledBookings[index]['Price']}'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.my_location_rounded,
                                      color: accentColor,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8),
                                      width: ScreenUtil.parentWidth(context) *
                                          0.75,
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          '${cancelledBookings[index]['Pickup Location']}'),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: secondaryColor,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8),
                                      width: ScreenUtil.parentWidth(context) *
                                          0.75,
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          '${cancelledBookings[index]['Dropoff Location']}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
                return Center(
                  child: Text('No transactions.'),
                );
              });
        });
  }

  Future<String> initializeSharedPrefs() async {
    return await UserSharedPreferences().readCacheString("UID") ?? '';
  }
}

class FormattedDateAndTime {
  String getDateStamp(Timestamp dateTime) {
    var timestamp = dateTime;
    var timestampToDate = DateFormat.yMMMMd('en_US').format(timestamp.toDate());
    return '$timestampToDate';
  }

  String getTimeStamp(Timestamp dateTime) {
    var timestamp = dateTime;
    var timeStamptoTime = DateFormat.jm().format(timestamp.toDate());
    return '$timeStamptoTime';
  }
}

class CompletedBookings extends StatelessWidget {
  const CompletedBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryStreamWidget(
        bookingStatus: 'Completed',
      ),
    );
  }
}
