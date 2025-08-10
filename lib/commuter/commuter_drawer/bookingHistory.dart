import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/backButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/logoMain.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/bookingDetailsContent.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/riderMainScreen.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/dateTimeConverter.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class BookingHistoryCommuter extends StatefulWidget {
  const BookingHistoryCommuter({super.key});

  @override
  _BookingHistoryCommuterState createState() => _BookingHistoryCommuterState();
}

class _BookingHistoryCommuterState extends State<BookingHistoryCommuter> {
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  DateTimeConvert dateTimeConvert = DateTimeConvert();
  String uid = '';
  bool uidReady = false;
  @override
  void initState() {
    super.initState();
    _initializeUID();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 10,
            toolbarHeight: 80,
            leading: BackbuttoninForm(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const TextTitle(
              text: 'History',
              fontWeight: FontWeight.w700,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size(ScreenUtil.parentWidth(context), 60),
              child: ColoredBox(
                color: primaryColor,
                child: TabBar(
                  dividerColor: primaryColor,
                  dividerHeight: 0,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  tabs: const [
                    Tab(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.playlist_add_check),
                          Text('Completed')
                        ],
                      ),
                    ),
                    Tab(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.wrong_location_outlined),
                          Text('Cancelled')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: BackgroundWithColor(
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: SvgPicture.asset(
                      height: 100,
                      'assets/images/Bukyo.svg',
                      colorFilter: ColorFilter.mode(
                          primaryColor.withOpacity(0.5), BlendMode.srcIn),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 241, 241, 241),
                    height: constraints.maxHeight - 116,
                    child: TabBarView(
                      children: [
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: _getBookingHistory('Completed'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty &&
                                  uidReady) {
                                return ListView.builder(
                                  padding: const EdgeInsets.only(top: 32),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 8, left: 16, right: 16),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: secondaryColor,
                                          )),
                                      child: ListTile(
                                        trailing: Icon(
                                            Icons.keyboard_arrow_right_rounded),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                final date = DateTimeConvert()
                                                    .convertTimeStampToDate(
                                                        snapshot.data![index]
                                                            ['Time Stamp']);
                                                final time = DateTimeConvert()
                                                    .convertTimeStampToTime(
                                                        snapshot.data![index]
                                                            ['Time Stamp']);
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: ScreenUtil
                                                              .parentWidth(
                                                                  context) *
                                                          0.9,
                                                      height: ScreenUtil
                                                              .parentHeight(
                                                                  context) *
                                                          0.8,
                                                      child: Card(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16),
                                                          child: BookingInformationContent(
                                                              notes:
                                                                  '${snapshot.data![index]['Note'] ?? ''}',
                                                              pickupLocation:
                                                                  '${snapshot.data![index]['Pickup Location']}',
                                                              dropoffLocation:
                                                                  '${snapshot.data![index]['Dropoff Location']}',
                                                              bookingID:
                                                                  '${snapshot.data![index]['Booking ID']}',
                                                              date: date,
                                                              time: time,
                                                              price:
                                                                  '${snapshot.data![index]['Price']}'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                          // MyRouter.navigateToNext(
                                          //     context, Placeholder());
                                        },
                                        title: Text(
                                          'Driver Name: ${snapshot.data![index]['Driver Name'] != null ? snapshot.data![index]['Driver Name'] : 'No Driver'}',
                                        ),
                                        titleTextStyle: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Time: ${dateTimeConvert.convertTimeStampToTime(snapshot.data![index]['Time Stamp'])}',
                                            ),
                                            Text(
                                              'Date: ${dateTimeConvert.convertTimeStampToDate(snapshot.data![index]['Time Stamp'])}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data!.length,
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Bukyo.svg',
                                    colorFilter: ColorFilter.mode(
                                        grayColor.withOpacity(0.5),
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'No Completed Transactions yet.',
                                    style: TextStyle(
                                      color: grayColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              );
                            }),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: _getBookingHistory('Cancelled'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return ListView.builder(
                                  padding: const EdgeInsets.only(top: 32),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 16, left: 16, right: 16),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: errorColor,
                                          )),
                                      child: ListTile(
                                        trailing: Icon(
                                            Icons.keyboard_arrow_right_rounded),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                final date = DateTimeConvert()
                                                    .convertTimeStampToDate(
                                                        snapshot.data![index]
                                                            ['Time Stamp']);
                                                final time = DateTimeConvert()
                                                    .convertTimeStampToTime(
                                                        snapshot.data![index]
                                                            ['Time Stamp']);
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: ScreenUtil
                                                              .parentWidth(
                                                                  context) *
                                                          0.9,
                                                      height: ScreenUtil
                                                              .parentHeight(
                                                                  context) *
                                                          0.8,
                                                      child: Card(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16),
                                                          child: BookingInformationContent(
                                                              notes:
                                                                  '${snapshot.data![index]['Note'] ?? ''}',
                                                              pickupLocation:
                                                                  '${snapshot.data![index]['Pickup Location']}',
                                                              dropoffLocation:
                                                                  '${snapshot.data![index]['Dropoff Location']}',
                                                              bookingID:
                                                                  '${snapshot.data![index]['Booking ID']}',
                                                              date: date,
                                                              time: time,
                                                              price:
                                                                  '${snapshot.data![index]['Price']}'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                          // MyRouter.navigateToNext(
                                          //     context, Placeholder());
                                        },
                                        title: const Text(
                                          'Cancelled',
                                          style: TextStyle(color: errorColor),
                                        ),
                                        titleTextStyle: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Time: ${dateTimeConvert.convertTimeStampToTime(snapshot.data![index]['Time Stamp'])}',
                                            ),
                                            Text(
                                              'Date: ${dateTimeConvert.convertTimeStampToDate(snapshot.data![index]['Time Stamp'])}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data!.length,
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Bukyo.svg',
                                    colorFilter: ColorFilter.mode(
                                        grayColor.withOpacity(0.5),
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'No Cancelled Transactions yet.',
                                    style: TextStyle(
                                      color: grayColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              );
                            })
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeUID() async {
    uid = (await sharedPreferences.readCacheString('UID'))!;
    setState(() {
      uidReady = true;
    });
  }

  Future<List<Map<String, dynamic>>> _getBookingHistory(String status) async {
    List<Map<String, dynamic>> data = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Booking_Details')
          .where('Commuter UID', isEqualTo: uid)
          .where('Booking Status', isEqualTo: status)
          .get();
      data = snapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e);
    }
    return data;
  }
}
