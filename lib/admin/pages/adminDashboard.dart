import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../constants/titleText.dart';

class DashboardTab extends StatelessWidget {
  final ScrollController? scrollController;
  final TabController? tabController;
  const DashboardTab({
    super.key,
    required this.context,
    this.scrollController,
    this.tabController,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = ScreenUtil.parentWidth(context);
    final deviceHeight = ScreenUtil.parentHeight(context);

    int tableIndexNum = 3;
    double tableHeaderPadding = ScreenUtil.parentWidth(context) < 500 ? 48 : 24;
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: adminGradientColor2,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 8),
                    child: TextTitle(
                      text: 'User Statistics',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) {
                        List<String> titles = [
                          'Total no. Commuters',
                          'Total no. of Drivers',
                        ];
                        List<int> screens = [
                          3,
                          1,
                        ];

                        return GestureDetector(
                          onTap: () {
                            if (tabController != null) {
                              tabController!.animateTo(screens[index]);
                              print(tabController!.index);
                            } else {
                              print('Tab controller is null');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: adminGradientColor3.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 120,
                            width: (deviceWidth * 0.5) - 24,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: TextTitle(
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    text: titles[index],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                StreamBuilder<int>(
                                    stream: _getUserCount(index),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasData) {
                                        return TextTitle(
                                          text: '${snapshot.data}',
                                          fontSize: 42,
                                          textColor: accentColor,
                                        );
                                      }
                                      return const Text(
                                        'No data.',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        );
                      })),
                  GestureDetector(
                    onTap: () {
                      if (tabController != null) {
                        tabController!.animateTo(1);
                        print(tabController!.index);
                      } else {
                        print('Tab controller is null');
                      }
                    },
                    child: Container(
                      width: ScreenUtil.parentWidth(context),
                      height: 260,
                      decoration: BoxDecoration(
                        color: adminGradientColor3.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title Container
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.topLeft,
                              child: const TextTitle(
                                text: 'Driver Verification Status',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: constraints.maxHeight - 50,
                                  width: constraints.maxWidth * 0.55,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Center(
                                    child: StreamBuilder<Map<String, int>?>(
                                        stream: _getAllDriverStatus(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: accentColor,
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            return PieChart(
                                              PieChartData(
                                                pieTouchData:
                                                    PieTouchData(enabled: true),
                                                sections: [
                                                  PieChartSectionData(
                                                      color: accentColor,
                                                      value: double.parse(
                                                          '${snapshot.data!['Pending']}')),
                                                  PieChartSectionData(
                                                      color: Colors.blue,
                                                      value: double.parse(
                                                          '${snapshot.data!['Verified']}')),
                                                  PieChartSectionData(
                                                      color: errorColor,
                                                      value: double.parse(
                                                          '${snapshot.data!['Denied']}')),
                                                ],
                                                centerSpaceRadius:
                                                    ScreenUtil.parentWidth(
                                                                context) <
                                                            350
                                                        ? 25
                                                        : 40,
                                              ),
                                            );
                                          }
                                          return const Text(
                                            'No data.',
                                            style:
                                                TextStyle(color: Colors.white),
                                          );
                                        }),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(3, (index) {
                                    Map<String, Color> textAndColor = {
                                      "Verified": Colors.blue,
                                      "Pending": accentColor,
                                      "Denied": errorColor,
                                    };
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square,
                                            color: textAndColor.values
                                                .elementAt(index),
                                          ),
                                          Text(
                                            textAndColor.keys.elementAt(index),
                                            style: const TextStyle(
                                                color: softWhite),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: adminGradientColor2,
                  borderRadius: BorderRadius.circular(16)),
              width: ScreenUtil.parentWidth(context) * 0.95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitle(
                    text: 'Recent Bookings',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: StreamBuilder<List<Map<String, dynamic>?>>(
                        stream: _getRecentBookings(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            print(snapshot.error);
                          }
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                if (tabController != null) {
                                  tabController!.animateTo(4);
                                  print(tabController!.index);
                                } else {
                                  print('Tab controller is null');
                                }
                              },
                              child: DataTable(
                                  columnSpacing: 20,
                                  dividerThickness: 0.1,
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      color:
                                          adminGradientColor3.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8)),
                                  columns: List.generate(tableIndexNum,
                                      (columnIndex) {
                                    List<String> title = [
                                      'Date',
                                      'Zone',
                                      'Status',
                                    ];
                                    return DataColumn(
                                        label: Container(
                                      width: deviceWidth / tableIndexNum -
                                          tableHeaderPadding,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            title[columnIndex],
                                          ),
                                        ],
                                      ),
                                    ));
                                  }),
                                  rows: List.generate(snapshot.data!.length,
                                      (rowIndex) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Text(
                                          _getDateInTimeStamp(snapshot
                                              .data![rowIndex]!['Time Stamp']),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${snapshot.data![rowIndex]!['Zone']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${snapshot.data![rowIndex]!['Booking Status'] == 'For Booking' ? 'Pending' : snapshot.data![rowIndex]!['Booking Status']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ]);
                                  })),
                            );
                          }
                          return const Center(
                            child: Text(
                              'No data.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Stream<int> _getUserCount(int index) {
    if (index == 0) {
      return FirebaseFirestore.instance
          .collection('Users')
          .where('Role', isEqualTo: 'Commuter')
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.length);
    }
    return FirebaseFirestore.instance
        .collection('Users')
        .where('Role', isEqualTo: 'Driver')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.length);
  }

  Stream<Map<String, int>?> _getAllDriverStatus() {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('Role', isEqualTo: 'Driver')
        .snapshots()
        .map((snapshot) {
      int verified = 0;
      int pending = 0;
      int unverified = 0;

      for (var doc in snapshot.docs) {
        String status = doc.data()['Verification Status'];
        if (status == 'Verified') {
          verified++;
        } else if (status == 'Pending') {
          pending++;
        } else if (status == 'Denied') {
          unverified++;
        }
      }
      if (verified == 0 && pending == 0 && unverified == 0) {
        return null;
      }
      return {
        'Verified': verified,
        'Pending': pending,
        'Denied': unverified,
      };
    });
  }

  Stream<List<Map<String, dynamic>>> _getRecentBookings() async* {
    yield* FirebaseFirestore.instance
        .collection('Booking_Details')
        .orderBy('Time Stamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  String _getDateInTimeStamp(dynamic data) {
    final timestamp = data;
    return DateFormat.yMd('en_US').format(timestamp.toDate());
  }
}
