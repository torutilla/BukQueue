import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/removeOverlay.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/actionSlider.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/alert.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/bookingDetailsContent.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/callSnackbar.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/linearProgress.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/loadingScreen.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/overlayEntryCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilDrawer.dart';
import 'package:flutter_try_thesis/driver/account_management/rider_page/signupRider.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/bookingDraggable.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/deniedVerificationScreen.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/pendingVerificationScreen.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/verifiedVerificationScreen.dart';
import 'package:flutter_try_thesis/map/mainMap.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/ongoingBookings.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/riderBookingHistory.dart';
import 'package:flutter_try_thesis/models/api_json_management/googleMapApis.dart';
import 'package:flutter_try_thesis/models/dynamicTimerWidget.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:flutter_try_thesis/models/providers/historyProvider.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/constants/zones.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/navigatorKey.dart';

class RiderScreenMap extends StatefulWidget {
  const RiderScreenMap({
    super.key,
  });

  @override
  RiderMapState createState() => RiderMapState();
}

class RiderMapState extends State<RiderScreenMap>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<LinearProgressIndicatorWithTimerState> progressKey =
      GlobalKey();

  Color cardColor = const Color.fromARGB(255, 243, 243, 243);
  FirestoreOperations firestoreOperations = FirestoreOperations();
  MainMapState mapState = MainMapState();
  StreamSubscription<Position>? currentLocationSubscription;
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  String currentUID = '';
  int currentIndex = 1;
  late TabController mainTabController;
  DraggableScrollableController draggableController =
      DraggableScrollableController();
  PersistentBottomSheetController? bottomSheet;
  OverlayEntry? detailsOverlay;
  GlobalKey<MainMapState> mainMapKey = GlobalKey<MainMapState>();
  bool isOnline = false;
  bool isBookingOngoing = false;
  double sliderValue = 0;
  Position? userLocation;
  late final List<Widget> _currentPage;
  String currentPickupLocation = '';
  String currentDropoffLocation = '';
  String currentNote = '';
  String currentDocId = '';
  String currentDate = '';
  String currentTime = '';
  String bookingStatus = '';
  String currentPassenger = '';
  String currentNumber = '';

  int mainBookingIndex = 0;

  DraggableScrollableController bookingDraggableController =
      DraggableScrollableController();
  DraggableScrollableController queueDraggable =
      DraggableScrollableController();
  Timer? queueTimer;
  final List<IconData> _bottomNavsIcon = [
    Icons.history,
    Icons.home,
    Icons.hourglass_top_rounded,
  ];

  final List<String> _bottomNavsIconLabel = [
    'History',
    'Home',
    'Ongoing',
  ];

  double trackWidth = 250;
  late AnimationController animationController;

  bool completeButton = false;

  bool startQueueListener = false;
  bool enableQueueDraggable = false;
  bool isTimerActive = true;

  String currentPolyline = '';

  String currentPrice = '';

  bool _hasShownCancelledDialog = false;

  GetPhotoLinkOfUser getPhoto = GetPhotoLinkOfUser();
  CachedNetworkImageProvider? photo;

  String currentPhotoLink = '';
  OverlayEntry? alertOverlayEntry;

  bool nextInLine = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      if (currentDocId.isNotEmpty) {
        sharedPreferences.addToCache({"Booking ID": currentDocId});
      }
    }
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      if (!enableQueueDraggable) {
        dequeuePosition();
      }
    }
    if (state == AppLifecycleState.resumed) {
      // enqueuePosition();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    getCurrentPos();
    sharedPreferences.addToCache({"Initial Screen": "Rider"});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSharedPreferences();
    });

    mainTabController = TabController(length: 3, vsync: this, initialIndex: 1);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _currentPage = [
      RiderBookingHistory(
        uid: currentUID,
      ),
      MainMap(
        key: mainMapKey,
      ),
      const OngoingBookings(),
    ];
    mainTabController.addListener(() {
      if (mainTabController.index != 1) {
        controlDraggable(draggableController, 0, Curves.easeOutCubic);
        controlDraggable(bookingDraggableController, 0, Curves.easeOutCubic);
      }
    });

    reloadTerminatedBooking();
  }

  void callSnackbar(String content) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text(content)));
  }

  void controlDraggable(
      DraggableScrollableController controller, double size, Curve curve) {
    controller.animateTo(size,
        duration: const Duration(milliseconds: 400), curve: curve);
  }

  Stream<String> _getVerificationStatus() {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      currentUID = auth.uid;
    }
    // print('current uid: $currentUID');
    final driverRef = FirebaseFirestore.instance
        .collection('Users')
        .where('UID', isEqualTo: currentUID)
        .limit(1)
        .snapshots();
    return driverRef.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 'Pending';
      }

      final verificationStatus =
          snapshot.docs.first.data()['Verification Status'] ?? 'Pending';
      return verificationStatus;
    });
  }

  BookingDraggable getBookingDraggable() => BookingDraggable(
      bookingDraggableController: bookingDraggableController,
      currentPhotoLink: currentPhotoLink,
      currentPassenger: currentPassenger,
      currentNumber: currentNumber,
      currentPickupLocation: currentPickupLocation,
      currentDropoffLocation: currentDropoffLocation,
      currentDocId: currentDocId,
      onBookingCancelled: () {
        _resetValues('Cancelled', resetOnlineStatus: true);
        _addToBookingHistory(context);
      },
      onBookingCompleted: () {
        _resetValues('Completed', resetOnlineStatus: true);
      });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _getVerificationStatus(),
        builder: (context, snapshot) {
          return Consumer<BookingProvider>(builder: (_, provider, child) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //
            // }
            if (snapshot.hasData && snapshot.data == 'Denied') {
              return DeniedVerificationScreen(currentUID: currentUID);
            }

            if (snapshot.hasData && snapshot.data == 'Verified') {
              return VerifiedVerificationScreen(
                isOnline: isOnline,
                mainTabController: mainTabController,
                bottomNavsIcon: _bottomNavsIcon,
                bottomNavsIconLabel: _bottomNavsIconLabel,
                photo: photo,
                currentPage: _currentPage,
                onOnlineToggle: (state) {},
                onDraggableButtonTap: () {},
                bookingDraggable: getBookingDraggable(),
              );
              // return Scaffold(
              //     bottomNavigationBar: BottomAppBar(
              //       color: primaryColor,
              //       height: 70,
              //       notchMargin: 8,
              //       clipBehavior: Clip.antiAlias,
              //       padding: const EdgeInsets.all(0),
              //       child: TabBar(
              //           isScrollable: false,
              //           indicator: BoxDecoration(
              //             color: accentColor.withBlue(10),
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           indicatorSize: TabBarIndicatorSize.tab,
              //           dividerHeight: 0,
              //           controller: mainTabController,
              //           labelColor: softWhite,
              //           unselectedLabelColor: secondaryColor.withOpacity(0.4),
              //           tabs: List.generate(3, (index) {
              //             return Tab(
              //               text: _bottomNavsIconLabel[index],
              //               icon: Icon(_bottomNavsIcon[index]),
              //             );
              //           })),
              //     ),
              //     drawer: UtilDriverDrawer(
              //       photo: photo,
              //       onLogout: () async {
              //         await ClearDataAndSignOut().authSignOutAndClearCache();
              //         await sharedPreferences
              //             .addToCache({"Initial Screen": "Login"});
              //       },
              //       driverName:
              //           provider.bookingUserInfo['Full Name'] ?? 'Driver',
              //       driverContact: provider.bookingUserInfo['Contact Number'] ??
              //           '+630000000000',
              //     ),
              //     appBar: AppBar(
              //       actions: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: CupertinoSwitch(
              //               activeColor: accentColor,
              //               trackColor: secondaryColor.withOpacity(0.2),
              //               value: isOnline,
              //               onChanged: (value) async {
              //                 if (userLocation == null) {
              //                   Fluttertoast.showToast(
              //                       msg: 'Trying to fetch location...');
              //                   userLocation = await getCurrentLocation();
              //                   return;
              //                 }
              //                 if (!allowedVehicleTypes(
              //                     provider.bookingUserInfo['Vehicle Type'])) {
              //                   CallSnackbar().callSnackbar(context,
              //                       'Unsupported Vehicle Type - Booking Unavailable');
              //                   return;
              //                 }
              //                 if (isBookingOngoing) {
              //                   ScaffoldMessenger.of(context).showSnackBar(
              //                     const SnackBar(
              //                         content: Text(
              //                             'The switch cannot be toggled while a booking is in progress.')),
              //                   );
              //                   return;
              //                 }
              //                 bool locationInTerminal =
              //                     await locationIsInTerminal();
              //                 print("In Terminal: $locationInTerminal");
              //                 if (locationInTerminal) {
              //                   // await _getTerminal();
              //                   setState(() {
              //                     enableQueueDraggable = true;
              //                     if (!isOnline) {
              //                       isOnline = value;
              //                       controlDraggable(queueDraggable, 0.9,
              //                           Curves.easeInCubic);
              //                       //     provider.updateTerminal(_getTerminal());
              //                       //     Future.delayed(const Duration(seconds: 1), () {
              //                       // provider.listenToBookingDatabaseValues();
              //                       //     });
              //                       // controlDraggable(
              //                       //     draggableController, 1, Curves.easeInCubic);
              //                     } else {
              //                       showDialog(
              //                           context: context,
              //                           builder: (context) {
              //                             return AlertDialog(
              //                               actionsAlignment:
              //                                   MainAxisAlignment.center,
              //                               title: const TextTitle(
              //                                 text: 'Switching Off Bookings',
              //                                 textColor: errorColor,
              //                                 maxLines: 2,
              //                               ),
              //                               content: const Text(
              //                                   'You haven\'t accepted any bookings yet. Are you sure you want to turn off bookings?'),
              //                               actions: [
              //                                 SizedBox(
              //                                   width: 100,
              //                                   child: PrimaryButton(
              //                                       backgroundColor: errorColor,
              //                                       buttonText: 'No',
              //                                       onPressed: () {
              //                                         Navigator.of(context)
              //                                             .pop();
              //                                       }),
              //                                 ),
              //                                 SizedBox(
              //                                   width: 100,
              //                                   child: PrimaryButton(
              //                                       backgroundColor:
              //                                           grayInputBox,
              //                                       buttonText: 'Yes',
              //                                       onPressed: () {
              //                                         setState(() {
              //                                           isOnline = value;
              //                                         });
              //                                         dequeuePosition();
              //                                         controlDraggable(
              //                                             draggableController,
              //                                             0,
              //                                             Curves.easeOutCubic);
              //                                         controlDraggable(
              //                                             queueDraggable,
              //                                             0,
              //                                             Curves.easeOutCubic);
              //                                         Navigator.of(context)
              //                                             .pop();
              //                                       }),
              //                                 ),
              //                               ],
              //                             );
              //                           });

              //                       //     isBookingOngoing = false;
              //                       //     provider.stopListeningToDatabase();
              //                     }
              //                   });
              //                 } else {
              //                   ScaffoldMessenger.of(context).showSnackBar(
              //                     const SnackBar(
              //                         content:
              //                             Text('Not currently in terminal')),
              //                   );
              //                 }
              //               }),
              //         ),
              //       ],
              //       backgroundColor: primaryColor,
              //       leading: Builder(
              //         builder: (context) {
              //           return IconButton(
              //             icon: const Icon(
              //               Icons.menu_rounded,
              //               color: Colors.white,
              //             ),
              //             onPressed: () {
              //               setState(() {});

              //               Scaffold.of(context).openDrawer();
              //             },
              //           );
              //         },
              //       ),
              //       title: Text(
              //         'Welcome, ${_getFirstNameInFirstSpace(provider.bookingUserInfo['Full Name'] ?? 'Driver')}!',
              //         style: Theme.of(context)
              //             .textTheme
              //             .titleSmall!
              //             .copyWith(color: Colors.white, fontSize: 17),
              //       ),
              //       centerTitle: true,
              //     ),
              //     body: Stack(
              //       children: [
              //         TabBarView(
              //             physics: const NeverScrollableScrollPhysics(),
              //             controller: mainTabController,
              //             children: List.generate(3, (index) {
              //               return _currentPage[index];
              //             })),
              //         Container(
              //           margin: const EdgeInsets.only(bottom: 40, right: 16),
              //           alignment: Alignment.bottomRight,
              //           child: FloatingActionButton(
              //             tooltip: 'Show bookings',
              //             mini: true,
              //             backgroundColor: isOnline ? primaryColor : grayColor,
              //             shape: const CircleBorder(),
              //             onPressed: () {
              //               if (enableQueueDraggable) {
              //                 controlDraggable(
              //                     queueDraggable, 0.9, Curves.easeInCubic);
              //               } else if (isOnline && isBookingOngoing) {
              //                 controlDraggable(bookingDraggableController, 0.9,
              //                     Curves.easeInCubic);
              //               } else if (isOnline) {
              //                 controlDraggable(
              //                     draggableController, 0.9, Curves.easeInCubic);
              //               }
              //             },
              //             child: const Icon(
              //               Icons.arrow_drop_up_sharp,
              //               color: softWhite,
              //             ),
              //           ),
              //         ),
              //         if (!isOnline)
              //           const Stack(
              //             alignment: Alignment.center,
              //             children: [
              //               ModalBarrier(
              //                 color: Colors.black38,
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.all(16.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     TextTitle(
              //                       text: 'Bookings are currently disabled.',
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w700,
              //                     ),
              //                     TextTitle(
              //                       text:
              //                           'Toggle the switch in the top-right corner to enable booking.',
              //                       fontSize: 14,
              //                       fontStyle: FontStyle.italic,
              //                       fontWeight: FontWeight.w500,
              //                       maxLines: 2,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         BookingDraggable(
              //             bookingDraggableController:
              //                 bookingDraggableController,
              //             currentPhotoLink: currentPhotoLink,
              //             currentPassenger: currentPassenger,
              //             currentNumber: currentNumber,
              //             currentPickupLocation: currentPickupLocation,
              //             currentDropoffLocation: currentDropoffLocation,
              //             currentDocId: currentDocId,
              //             onCancelled: () {
              //               _resetValues('Cancelled', resetOnlineStatus: true);
              //               _addToBookingHistory(context);
              //             },
              //             onCompleted: () {
              //               _resetValues('Completed', resetOnlineStatus: true);
              //             }),
              //         // showBookingDraggableSheet(context),
              //         _initializeSheet(context),
              //         queueDraggableSheet(context),
              //       ],
              //     ));
            }
            if (snapshot.hasData && snapshot.data == 'Pending') {
              return const PendingVerificationScreen();
            }
            return const LoadingScreen();
          });
        });
  }
  //   return Consumer<BookingProvider>(builder: (_, provider, child) {
  //     return Scaffold(
  //         bottomNavigationBar: BottomAppBar(
  //           color: primaryColor,
  //           height: 70,
  //           notchMargin: 8,
  //           clipBehavior: Clip.antiAlias,
  //           padding: const EdgeInsets.all(0),
  //           child: TabBar(
  //               isScrollable: false,
  //               indicator: BoxDecoration(
  //                 color: accentColor.withBlue(10),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               indicatorSize: TabBarIndicatorSize.tab,
  //               dividerHeight: 0,
  //               controller: mainTabController,
  //               labelColor: softWhite,
  //               unselectedLabelColor: secondaryColor.withOpacity(0.4),
  //               tabs: List.generate(3, (index) {
  //                 return Tab(
  //                   text: _bottomNavsIconLabel[index],
  //                   icon: Icon(_bottomNavsIcon[index]),
  //                 );
  //               })),
  //         ),
  //         drawer: UtilDriverDrawer(
  //           onLogout: () {
  //             sharedPreferences.addToCache({"Initial Screen": "Login"});
  //           },
  //           driverName: provider.bookingUserInfo['Full Name'] ?? 'Driver',
  //           driverContact:
  //               provider.bookingUserInfo['Contact Number'] ?? '+630000000000',
  //         ),
  //         appBar: AppBar(
  //           actions: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: CupertinoSwitch(
  //                   activeColor: accentColor,
  //                   trackColor: secondaryColor.withOpacity(0.2),
  //                   value: isOnline,
  //                   onChanged: (value) {
  //                     if (isBookingOngoing) {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                             content: Text(
  //                                 'The switch cannot be toggled while a booking is in progress.')),
  //                       );
  //                       return;
  //                     }
  //                     if (locationIsInTerminal()) {
  //                       _getTerminal();
  //                       setState(() {
  //                         isOnline = value;
  //                         enableQueueDraggable = true;
  //                         if (isOnline) {
  //                           controlDraggable(
  //                               queueDraggable, 0.9, Curves.easeInCubic);
  //                           //     provider.updateTerminal(_getTerminal());
  //                           //     Future.delayed(const Duration(seconds: 1), () {
  //                           // provider.listenToBookingDatabaseValues();
  //                           //     });
  //                           // controlDraggable(
  //                           //     draggableController, 1, Curves.easeInCubic);
  //                         } else {
  //                           dequeuePosition();
  //                           controlDraggable(
  //                               draggableController, 0, Curves.easeOutCubic);
  //                           controlDraggable(
  //                               queueDraggable, 0, Curves.easeOutCubic);
  //                           //     isBookingOngoing = false;
  //                           //     provider.stopListeningToDatabase();
  //                         }
  //                       });
  //                     } else {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                             content: Text('Not currently in terminal')),
  //                       );
  //                     }
  //                   }),
  //             ),
  //           ],
  //           backgroundColor: primaryColor,
  //           leading: Builder(
  //             builder: (context) {
  //               return IconButton(
  //                 icon: const Icon(
  //                   Icons.menu_rounded,
  //                   color: Colors.white,
  //                 ),
  //                 onPressed: () {
  //                   setState(() {});

  //                   Scaffold.of(context).openDrawer();
  //                 },
  //               );
  //             },
  //           ),
  //           title: Text(
  //             'Welcome, ${_getFirstNameInFirstSpace(provider.bookingUserInfo['Full Name'] ?? 'Driver')}!',
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .titleSmall!
  //                 .copyWith(color: Colors.white, fontSize: 17),
  //           ),
  //           centerTitle: true,
  //         ),
  //         body: Stack(
  //           children: [
  //             TabBarView(
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 controller: mainTabController,
  //                 children: List.generate(3, (index) {
  //                   return _currentPage[index];
  //                 })),
  //             Container(
  //               margin: const EdgeInsets.only(bottom: 40, right: 16),
  //               alignment: Alignment.bottomRight,
  //               child: FloatingActionButton(
  //                 tooltip: 'Show bookings',
  //                 mini: true,
  //                 backgroundColor: isOnline ? primaryColor : grayColor,
  //                 shape: const CircleBorder(),
  //                 onPressed: () {
  //                   if (enableQueueDraggable) {
  //                     controlDraggable(queueDraggable, 0.9, Curves.easeInCubic);
  //                   } else if (isOnline && isBookingOngoing) {
  //                     controlDraggable(
  //                         bookingDraggableController, 0.9, Curves.easeInCubic);
  //                   } else if (isOnline) {
  //                     controlDraggable(
  //                         draggableController, 0.9, Curves.easeInCubic);
  //                   }
  //                 },
  //                 child: const Icon(
  //                   Icons.arrow_drop_up_sharp,
  //                   color: softWhite,
  //                 ),
  //               ),
  //             ),
  //             if (!isOnline)
  //               const Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   ModalBarrier(
  //                     color: Colors.black38,
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.all(16.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         TextTitle(
  //                           text: 'Bookings are currently disabled.',
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                         TextTitle(
  //                           text:
  //                               'Toggle the switch in the top-right corner to enable booking.',
  //                           fontSize: 14,
  //                           fontStyle: FontStyle.italic,
  //                           fontWeight: FontWeight.w500,
  //                           maxLines: 2,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             showBookingDraggableSheet(context),
  //             _initializeSheet(context),
  //             queueDraggableSheet(context),
  //           ],
  //         ));
  //   });
  // }

  Widget queueDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
        controller: queueDraggable,
        initialChildSize: 0,
        minChildSize: 0,
        maxChildSize: 0.8,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: SizedBox(
                height: ScreenUtil.parentHeight(context) * 0.6,
                child: Consumer<BookingProvider>(
                    builder: (context, provider, child) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: grayColor,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              // SvgPicture.asset(
                              //   'assets/images/Bukyo.svg',
                              //   height: 80,
                              //   colorFilter: const ColorFilter.mode(
                              //       primaryColor, BlendMode.srcIn),
                              // ),
                              Column(
                                children: [
                                  const TextTitle(
                                    text: 'Join Queue',
                                    textColor: blackColor,
                                  ),
                                  Text(
                                      '${provider.bookingUserInfo['Zone Number']}: ${provider.currentTerminal}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // StreamBuilder(
                        //     stream: queueListener(),
                        //     builder: (_, snapshot) {
                        //       if (snapshot.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return SizedBox(
                        //           height: constraints.maxHeight * 0.4,
                        //           child: const Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               CircularProgressIndicator(),
                        //               Text('Calculating your position...'),
                        //             ],
                        //           ),
                        //         );
                        //       }
                        //       if (startQueueListener) {
                        //         if (snapshot.data == 0) {
                        //           queueTimer =
                        //               Timer(const Duration(seconds: 2), () {
                        //             Future.delayed(Duration(milliseconds: 500));
                        //             if (isTimerActive && snapshot.data == 0) {
                        //               controlDraggable(queueDraggable, 0,
                        //                   Curves.easeOutCubic);
                        //               Future.delayed(
                        //                   const Duration(seconds: 1));
                        //               controlDraggable(draggableController, 1,
                        //                   Curves.easeInCubic);
                        //               provider.listenToBookingDatabaseValues();
                        //               setState(() {
                        //                 startQueueListener = false;
                        //                 enableQueueDraggable = false;
                        //               });
                        //             }
                        //           });
                        //           return SizedBox(
                        //             height: constraints.maxHeight * 0.4,
                        //             child: const Center(
                        //               child: Text(
                        //                   'You are next in line. Please wait...'),
                        //             ),
                        //           );
                        //         }
                        //         if (snapshot.data != null) {
                        //           return SizedBox(
                        //             height: constraints.maxHeight * 0.4,
                        //             child: Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   'Your position in queue:',
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .titleMedium!
                        //                       .copyWith(
                        //                           color: accentColor,
                        //                           fontWeight: FontWeight.w700),
                        //                 ),
                        //                 TextTitle(
                        //                   text: '${snapshot.data!}',
                        //                   textColor: blackColor,
                        //                   fontSize: 120,
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //         }
                        //       }
                        //       return SizedBox(
                        //         height: constraints.maxHeight * 0.4,
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               'Drivers in Queue:',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .titleMedium!
                        //                   .copyWith(
                        //                       color: accentColor,
                        //                       fontWeight: FontWeight.w700),
                        //             ),
                        //             TextTitle(
                        //               text: '${snapshot.data /*?? 0*/}',
                        //               textColor: blackColor,
                        //               fontSize: 120,
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     }),
                        StreamBuilder<int>(
                          stream: queueListener(),
                          builder: (_, snapshot) {
                            final queuePosition = snapshot.data ?? -1;

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: constraints.maxHeight * 0.4,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    Text('Calculating your position...'),
                                  ],
                                ),
                              );
                            }
                            if (queuePosition != 0) {
                              if (queueTimer?.isActive ?? false) {
                                queueTimer?.cancel();
                              }
                            }

                            if (startQueueListener && queuePosition == 0) {
                              if (isTimerActive) {
                                queueTimer?.cancel();
                              }
                              queueTimer =
                                  Timer(const Duration(seconds: 2), () {
                                if (isTimerActive && queuePosition == 0) {
                                  controlDraggable(
                                      queueDraggable, 0, Curves.easeOutCubic);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    controlDraggable(draggableController, 1,
                                        Curves.easeInCubic);
                                  });

                                  provider.listenToBookingDatabaseValues();

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      startQueueListener = false;
                                      enableQueueDraggable = false;
                                    });
                                  });
                                } else {
                                  return;
                                }
                              });

                              return SizedBox(
                                height: constraints.maxHeight * 0.4,
                                child: const Center(
                                  child: Text(
                                      'You are next in line. Please wait...'),
                                ),
                              );
                            }

                            return SizedBox(
                              height: constraints.maxHeight * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    startQueueListener
                                        ? 'Your position in queue:'
                                        : 'Drivers in Queue:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: accentColor,
                                            fontWeight: FontWeight.w700),
                                  ),
                                  TextTitle(
                                    text:
                                        '${queuePosition >= 0 ? queuePosition : 0}',
                                    textColor: blackColor,
                                    fontSize: 120,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PrimaryButton(
                              backgroundColor: startQueueListener
                                  ? Colors.white
                                  : primaryColor,
                              buttonText: startQueueListener
                                  ? 'Cancel Queue'
                                  : 'Enter Queue',
                              borderColor:
                                  startQueueListener ? primaryColor : null,
                              textColor:
                                  startQueueListener ? primaryColor : softWhite,
                              onPressed: () {
                                if (startQueueListener) {
                                  isTimerActive = false;
                                  // queueTimer!.cancel();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actionsAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          actions: [
                                            PrimaryButton(
                                              onPressed: () {
                                                if (queueTimer != null &&
                                                    queueTimer!.isActive) {
                                                  queueTimer!.cancel();
                                                  print('Queue Timer canceled');
                                                }
                                                dequeuePosition();
                                                setState(() {
                                                  startQueueListener = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              buttonText: 'Yes',
                                              backgroundColor: grayInputBox,
                                              textColor: blackColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: PrimaryButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isTimerActive = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                buttonText: 'No',
                                                backgroundColor: errorColor,
                                              ),
                                            ),
                                          ],
                                          title: const Text('Cancel Queueing?'),
                                          content: const Text(
                                              'Do you want to cancel your queue and leave your current spot?'),
                                          icon: const Icon(
                                            Icons.warning,
                                            size: 48,
                                          ),
                                          iconColor: errorColor,
                                        );
                                      });
                                } else {
                                  queueListener();
                                  enqueuePosition();
                                  setState(() {
                                    startQueueListener = true;
                                    isTimerActive = true;
                                  });
                                }
                              }),
                        ),
                      ],
                    );
                  });
                }),
              ),
            ),
          );
        });
  }

  Widget _initializeSheet(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context, provider, child) {
      return SizedBox(
        height: ScreenUtil.parentHeight(context),
        child: DraggableScrollableSheet(
            controller: draggableController,
            shouldCloseOnMinExtent: false,
            initialChildSize: 0,
            minChildSize: 0,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.05],
            builder: (context, scrollcontroller) {
              return SingleChildScrollView(
                controller: scrollcontroller,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: ScreenUtil.parentWidth(context),
                          height: 40,
                          decoration: BoxDecoration(
                              color: isOnline ? primaryColor : grayColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16))),
                        ),
                        Container(
                          width: 80,
                          height: 6,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: ScreenUtil.parentHeight(context) * 0.75 - 35,
                      color: Colors.white,
                      child: isOnline == true && provider.values.isNotEmpty
                          ? ListView.builder(
                              itemCount: provider.values.length,
                              itemBuilder: (context, index) {
                                final item = provider.documentID;
                                String pickupLocation =
                                    '${provider.values[index]['Pickup Location']}';
                                String dropoffLocation =
                                    '${provider.values[index]['Dropoff Location']}';

                                return GestureDetector(
                                  onTap: () {
                                    _showDetailsOverlay(context, index);
                                    mainBookingIndex = index;
                                  },
                                  child: Container(
                                    key: ValueKey(item[index]),
                                    margin: const EdgeInsets.all(16),
                                    height: 340,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(4, 4),
                                            color: Colors.black12,
                                            blurRadius: 4,
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 1.0, color: primaryColor)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32.0),
                                              child: FutureBuilder(
                                                  future: getPhoto.getPhotoLink(
                                                      provider.values[index]
                                                          ['Commuter UID']),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.data != null) {
                                                      provider.photoLinks
                                                          .add(snapshot.data!);
                                                      return CircleAvatar(
                                                        foregroundImage:
                                                            CachedNetworkImageProvider(
                                                                snapshot.data!),
                                                        child: const Icon(
                                                            Icons.person),
                                                      );
                                                    }
                                                    return const CircleAvatar(
                                                      child: Icon(Icons.person),
                                                    );
                                                  }),
                                            ),
                                            TextTitle(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              text:
                                                  '${provider.values[index]['Commuter Name']}',
                                              textColor: primaryColor,
                                              fontSize: 18,
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: grayInputBox,
                                          indent: 8,
                                          endIndent: 8,
                                          height: 0.5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Pickup Location',
                                                    style: TextStyle(
                                                      color: grayColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    pickupLocation,
                                                    style: const TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              color: grayInputBox,
                                              endIndent: 24,
                                              indent: 24,
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Dropoff Location',
                                                    style: TextStyle(
                                                      color: grayColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    dropoffLocation,
                                                    style: const TextStyle(
                                                      color: accentColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),

                                        //
                                        sliderDeclineWidget(provider, index,
                                            sliderWidth: ScreenUtil.parentWidth(
                                                    context) *
                                                0.6),
                                        const Text(
                                          'Click to see full details',
                                          style: TextStyle(
                                              color: grayColor, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: ScreenUtil.parentWidth(context),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/Bukyo.svg',
                                      colorFilter: const ColorFilter.mode(
                                          grayInputBox, BlendMode.srcIn),
                                    ),
                                    const TextTitle(
                                      text: 'No Bookings',
                                      textColor: grayInputBox,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }

  Future<void> bookingSliderUpdateInfo(
      BookingProvider provider, ActionSliderController actionController) async {
    if (detailsOverlay != null) {
      removeOverlay(detailsOverlay);
    }
    final timeInMinutes = calculateEstimatedTimeOfArrival(
        LatLng(userLocation!.latitude, userLocation!.longitude),
        provider.pickupLatLng!);
    try {
      final isBookingStillAvailable = await provider.updateBookingValues(
        currentDocId,
        {
          "Driver UID": provider.bookingUserInfo['UID'],
          "Estimated Arrival Time": timeInMinutes,
          "Driver Name": provider.bookingUserInfo['Full Name'],
          "Driver Contact": provider.bookingUserInfo['Contact Number'],
          "Plate Number": provider.bookingUserInfo['Plate Number'],
          "Booking Status": "Ongoing",
          "Body Number": provider.bookingUserInfo['Body Number'],
        },
      );
      if (isBookingStillAvailable) {
        dequeuePosition();
        updateBooking(provider);
        await sharedPreferences.addToCache({
          "Booking ID": currentDocId,
          "Zone": provider.bookingUserInfo['Zone Number']
        });
        _listenToBooking(currentDocId);

        controlDraggable(draggableController, 0, Curves.easeOut);
        controlDraggable(bookingDraggableController, 0.9, Curves.easeInCubic);
        // provider.stopListeningToDatabase();
      }
      progressKey.currentState?.stopTimer();
      // else {
      //   callSnackbar('This booking has already been accepted.');
      // }
    } catch (e) {
      actionController.failure();
      actionController.reset();
      print(e);
      callSnackbar(
          'An error occurred while accepting the booking. Please check your internet connection and try again later.');
    }
  }

  void _showDetailsOverlay(BuildContext context, int index) {
    _updateBookingDetails(index);

    detailsOverlay = OverlayEntry(builder: (context) {
      return Consumer<BookingProvider>(builder: (context, provider, child) {
        return OverlayEntryCard(
          animationController: animationController,
          height: ScreenUtil.parentHeight(context) * 0.9,
          width: ScreenUtil.parentWidth(context) * 0.90,
          titleText: 'Booking Details',
          onDismiss: () {
            provider.resetBookingInfo();
            if (detailsOverlay != null) {
              removeOverlay(detailsOverlay);
            }
          },
          actions: [
            if (!isBookingOngoing)
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 80,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(4, 4),
                          blurRadius: 4,
                          color: Colors.black26,
                        )
                      ]),
                  child: IconButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (state) {
                          if (state.contains(WidgetState.pressed)) {
                            return Colors.transparent;
                          }
                          return null;
                        },
                      ),
                    ),
                    icon: const Icon(Icons.location_on_rounded),
                    color: softWhite,
                    onPressed: () async {
                      mapOperations(provider.documentID[index], provider);
                    },
                  ))
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BookingInformationContent(
                price: currentPrice,
                pickupLocation: currentPickupLocation,
                dropoffLocation: currentDropoffLocation,
                bookingID: currentDocId,
                notes: currentNote,
                date: currentDate,
                time: currentTime,
                sliderWidget: sliderDeclineWidget(provider, index,
                    sliderText: 'Accept', isOverlay: true),
              ),

              // if (!isBookingOngoing)
            ],
          ),
        );
      });
    });

    Overlay.of(context, debugRequiredFor: widget).insert(detailsOverlay!);
    animationController.forward();
  }

  OverlayEntry alertEntry(BuildContext context, BookingProvider provider,
      int index, VoidCallback onClose) {
    return alertOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: AlertDialogWithChoice(
                    title: 'Decline Booking',
                    content:
                        "Are you sure you want to decline this booking? If you proceed, you will be moved to the end of the queue.",
                    onClick1: () {
                      declineBookingAndResetQueueing(provider, index,
                          isOverlay: true);
                      removeOverlay(alertOverlayEntry);
                    },
                    onClick2: () {
                      removeOverlay(alertOverlayEntry);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget sliderDeclineWidget(BookingProvider provider, int index,
      {double? sliderWidth, String? sliderText, bool isOverlay = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 80,
                child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            const WidgetStatePropertyAll(softWhite),
                        backgroundColor: WidgetStatePropertyAll(
                            isBookingOngoing ? grayInputBox : errorColor)),
                    onPressed: () {
                      if (isBookingOngoing) {
                        return;
                      }
                      Overlay.of(context).insert(alertEntry(
                        context,
                        provider,
                        index,
                        () {
                          removeOverlay(alertOverlayEntry);
                        },
                      ));
                    },
                    child: const Text('Decline')),
              ),
              SizedBox(
                width: sliderWidth ?? 165,
                child: CustomActionSlider(
                  sliderText: sliderText ?? 'Accept Booking',
                  whileLoading: (ActionSliderController controller) {
                    provider.stopListeningToDatabase();

                    if (isBookingOngoing) {
                      controller.failure();
                      Fluttertoast.showToast(
                          msg: 'Cannot accept this booking.');
                      Future.delayed(const Duration(microseconds: 500));
                      controller.reset();
                    } else {
                      _updateBookingDetails(index);
                      setState(() {
                        isBookingOngoing = true;
                      });
                    }
                  },
                  callBack: (actionController) async {
                    try {
                      await bookingSliderUpdateInfo(provider, actionController);
                    } catch (e) {
                      print(e);
                    }
                  },
                  onError: () {
                    callSnackbar(
                        'An error occured while doing this action. Please try again later.');
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DynamicTimerWidget(timeInSeconds: 181),
                SizedBox(
                    width: 200,
                    child: LinearProgressIndicatorWithTimer(
                      key: progressKey,
                      timeInMilliseconds: 1000,
                      callBack: () {
                        declineBookingAndResetQueueing(provider, index,
                            isOverlay: isOverlay, isLinearTimer: true);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void declineBookingAndResetQueueing(BookingProvider provider, int index,
      {bool isOverlay = false, bool isLinearTimer = false}) async {
    Fluttertoast.showToast(
        msg: isLinearTimer ? 'Booking timed-out' : 'Booking declined');
    if (isOverlay) {
      removeOverlay(detailsOverlay, animationController: animationController);
    }
    await provider.addToDeclinedBookings(provider.documentID[index]);
    dequeuePosition();
    setState(() {
      provider.values.removeAt(index);
      enableQueueDraggable = true;
      // _jumpToNextDriver();
      // provider.values
      //     .removeAt(index);
    });
    controlDraggable(draggableController, 0, Curves.easeOutCubic);
    await Future.delayed(const Duration(milliseconds: 500));
    controlDraggable(queueDraggable, 1, Curves.easeInCubic);
  }

  Widget showBookingDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0,
        minChildSize: 0,
        maxChildSize: 0.59,
        controller: bookingDraggableController,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: ScreenUtil.parentHeight(context) * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 4,
                      width: constraints.maxWidth * 0.3,
                      decoration: BoxDecoration(
                          color: grayInputBox,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          foregroundImage:
                              CachedNetworkImageProvider(currentPhotoLink),
                          backgroundColor: primaryColor,
                          radius: 24,
                          child: const Icon(Icons.person), //need to add picture
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: SizedBox(
                            width: constraints.maxWidth * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextTitle(
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  fontSize: 20,
                                  text: currentPassenger,
                                  textColor: blackColor,
                                ),
                                const Text('Commuter'),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(accentColor)),
                          onPressed: () {
                            messageNumber(currentNumber);
                          },
                          icon: const Icon(
                            Icons.message,
                            size: 18,
                          ),
                          color: Colors.white,
                        ),
                        IconButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(primaryColor)),
                          onPressed: () {
                            callNumber(currentNumber);
                          },
                          icon: const Icon(
                            Icons.call,
                            size: 18,
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: grayInputBox,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: constraints.maxHeight * 0.5,
                        width: constraints.maxWidth * 0.9,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1, color: primaryColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.my_location_rounded,
                                    size: 32,
                                    color: primaryColor,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pickup Location',
                                      style: TextStyle(color: grayColor),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.7,
                                      child: TextTitle(
                                        maxLines: 2,
                                        text: currentPickupLocation,
                                        textColor: primaryColor,
                                        fontSize: 18,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              height: 1,
                              color: grayInputBox,
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 32,
                                    color: accentColor,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Dropoff Location',
                                      style: TextStyle(color: grayColor),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.7,
                                      child: TextTitle(
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        text: currentDropoffLocation,
                                        textColor: accentColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     SizedBox(
                        //       height: 50,
                        //       width: constraints.maxWidth * 0.45,
                        //       child: PrimaryButton(
                        //         prefixIcon: const Icon(
                        //           Icons.call,
                        //           color: Colors.white,
                        //         ),
                        //         backgroundColor: primaryColor.withOpacity(0.7),
                        //         onPressed: () {
                        //           callNumber(currentNumber); //change number
                        //         },
                        //         buttonText: 'Call',
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 50,
                        //       width: constraints.maxWidth * 0.45,
                        //       child: PrimaryButton(
                        //         prefixIcon: const Icon(
                        //           Icons.message,
                        //           color: Colors.white,
                        //         ),
                        //         onPressedColor: accentColor,
                        //         backgroundColor: accentColor.withOpacity(0.7),
                        //         onPressed: () {
                        //           messageNumber(currentNumber); //change number
                        //         },
                        //         buttonText: 'Message',
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Consumer<BookingProvider>(
                              builder: (context, provider, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: constraints.maxWidth * 0.35,
                                  child: PrimaryButton(
                                    onPressedColor: warningColor.withBlue(4),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              actions: [
                                                SizedBox(
                                                  width: 90,
                                                  child: PrimaryButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      provider
                                                          .updateBookingValues(
                                                        currentDocId,
                                                        {
                                                          "Booking Status":
                                                              'Cancelled',
                                                          "Elapsed":
                                                              Timestamp.now(),
                                                        },
                                                        updateOngoingBookingStatus:
                                                            true,
                                                      );
                                                      _resetValues('Cancelled',
                                                          resetOnlineStatus:
                                                              true);

                                                      _addToBookingHistory(
                                                          context);
                                                    },
                                                    buttonText: 'Yes',
                                                    backgroundColor:
                                                        grayInputBox,
                                                    textColor: Colors.black,
                                                    onPressedColor:
                                                        grayColor.withRed(50),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 90,
                                                  child: PrimaryButton(
                                                    onPressedColor:
                                                        errorColor.withRed(50),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: 'No',
                                                    backgroundColor: errorColor,
                                                  ),
                                                ),
                                              ],
                                              title: const TextTitle(
                                                text: 'Cancel Booking',
                                                textColor: errorColor,
                                              ),
                                              icon: const Icon(
                                                Icons.warning,
                                                size: 40,
                                              ),
                                              iconColor: errorColor,
                                              content: const Text(
                                                  'Are you sure you want to cancel this booking?'),
                                            );
                                          });
                                    },
                                    buttonText: 'Cancel',
                                    backgroundColor: errorColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: constraints.maxWidth * 0.55,
                                  child: PrimaryButton(
                                    onPressed: () {
                                      // if (completeButton) {
                                      //

                                      showDialog(
                                          context: context,
                                          builder: (c) {
                                            return CustomAlertDialog(
                                                iconSize: 50,
                                                alertIcon: Icons.check_circle,
                                                iconAndButtonColor:
                                                    primaryColor,
                                                title: 'Booking Complete',
                                                content:
                                                    'Trip successfully completed. Awaiting your next assignment!',
                                                buttonText: 'OK',
                                                onclick: () {
                                                  Navigator.pop(c);
                                                  provider.updateBookingValues(
                                                    currentDocId,
                                                    {
                                                      "Booking Status":
                                                          'Completed',
                                                      "Elapsed":
                                                          Timestamp.now(),
                                                    },
                                                    updateOngoingBookingStatus:
                                                        true,
                                                  );
                                                  _resetValues('Completed',
                                                      resetOnlineStatus: true);
                                                });
                                          });
                                      // }
                                    },
                                    buttonText: 'Finish Booking',
                                    backgroundColor: completeButton
                                        ? primaryColor
                                        : primaryColor,

                                    ///edit color
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  void mapOperations(String id, BookingProvider provider) async {
    print(id);

    DirectionsClass directions = DirectionsClass(provider);

    if (provider.BookingPolylineList.containsKey(id)) {
      print('using the cache polyline');

      provider.resetPolyline();
      List<LatLng> cachedPolyline =
          List<LatLng>.from(provider.BookingPolylineList[id]!);

      provider.addPolylineListToPolyline(cachedPolyline);

      // print(provider.bookingPolyline);
    } else {
      directions.decodePolyline(currentPolyline);
      String newId = id;
      provider.BookingPolylineList.putIfAbsent(
          newId, () => directions.bookingPolyline);

      debugPrint("${provider.BookingPolylineList}");
    }
    if (detailsOverlay != null) {
      removeOverlay(detailsOverlay);
    }
    controlDraggable(draggableController, 0, Curves.easeOutCubic);

    mainMapKey.currentState!.focusCameraToLocation(provider.pickupLatLng!);
  }

  void updateBooking(BookingProvider provider) {
    mainMapKey.currentState!.showCurrentLocation = false;
    if (provider.BookingPolylineList.containsKey(currentDocId)) {
      List<LatLng> cachedPolyline =
          List<LatLng>.from(provider.BookingPolylineList[currentDocId]!);
      provider.addPolylineListToPolyline(cachedPolyline);
    } else {
      DirectionsClass directions = DirectionsClass(provider);
      directions.decodePolyline(currentPolyline);
    }
    setState(() {
      isBookingOngoing = true;
    });

    // currentLocationSubscription =
    //     Geolocator.getPositionStream().listen((currentPosition) {
    //   mainMapKey.currentState!.bookingCameraWithTracking(
    //       LatLng(currentPosition.latitude, currentPosition.longitude));

    //   // _addingMarkerToPosition(currentPosition, provider);
    //   //add icon
    //   //updateValues position naman
    //   // if (isLocationWithinBounds(
    //   //         LatLng(currentPosition.latitude, currentPosition.longitude),
    //   //         provider.dropoffLatLng!,
    //   //         50) &&
    //   //     completeButton == false) {
    //   //   setState(() {
    //   //     completeButton = true;
    //   //   });
    //   // }
    // });

    BookingHistoryProvider historyProvider =
        Provider.of<BookingHistoryProvider>(context, listen: false);

    historyProvider.onGoingBooking({
      "Pickup Location": currentPickupLocation,
      "Dropoff Location": currentDropoffLocation,
      "Price": currentPrice,
      "Note": currentNote,
      "Booking ID": currentDocId,
      "Time": currentTime,
      "Date": currentDate,
    });
  }

  void _resetValues(String status, {bool resetOnlineStatus = false}) {
    BookingProvider provider =
        Provider.of<BookingProvider>(context, listen: false);
    dequeuePosition();
    setState(() {
      bookingStatus = status;
      isBookingOngoing = false;
    });
    controlDraggable(bookingDraggableController, 0, Curves.easeOutCubic);
    // Navigator.of(context).pop();
    // if (!resetOnlineStatus) {
    //   // controlDraggable(draggableController, 0.9, Curves.easeInCubic);
    //   // provider.listenToBookingDatabaseValues();
    //   controlDraggable(queueDraggable, 0.9, Curves.easeInOutCubic);
    //   provider.stopListeningToDatabase();
    // }
    provider.resetBookingInfo();
    sharedPreferences.deleteCache("Booking ID");
    MarkerId riderMarkerId = const MarkerId('Rider Position ID');
    bool markerExists = provider.pinnedMarkers
        .any((marker) => marker.markerId == riderMarkerId);
    if (markerExists) {
      Marker oldMarker = provider.pinnedMarkers
          .firstWhere((marker) => marker.markerId == riderMarkerId);
      provider.pinnedMarkers.remove(oldMarker);
    }
    BookingHistoryProvider history =
        Provider.of<BookingHistoryProvider>(context, listen: false);
    if (resetOnlineStatus) {
      setState(() {
        isOnline = false;
      });
    }
    history.ongoingBooking.clear();
  }

  void _addToBookingHistory(BuildContext context) {
    BookingHistoryProvider history =
        Provider.of<BookingHistoryProvider>(context, listen: false);
    history.addToHistory({
      "Pickup Location": currentPickupLocation,
      "Dropoff Location": currentDropoffLocation,
      "Note": currentNote,
      "Booking ID": currentDocId,
      "Price": currentPrice,
      "Time": currentTime,
      "Date": currentDate,
      "Status": bookingStatus,
    });
    if (history.ongoingBooking.isNotEmpty) {
      history.ongoingBooking.clear();
    }

    if (currentLocationSubscription != null) {
      currentLocationSubscription!.cancel();
      mainMapKey.currentState!.showCurrentLocation = true;
    }
  }

  void _loadSharedPreferences() async {
    BookingProvider provider =
        Provider.of<BookingProvider>(context, listen: false);

    currentUID = await sharedPreferences.readCacheString("UID") ?? '';
    setState(() {});
    provider.declinedBookingIds =
        await sharedPreferences.readCacheStringList('Declined Bookings') ?? [];
    final user = {
      "UID": currentUID,
      "Full Name": await sharedPreferences.readCacheString('Full Name'),
      "Contact Number":
          await sharedPreferences.readCacheString('Contact Number'),
      "Body Number": await sharedPreferences.readCacheString('Body Number'),
      "Zone Number": await sharedPreferences.readCacheString('Zone Number'),
      "Plate Number": await sharedPreferences.readCacheString('Plate Number'),
      "Vehicle Type": await sharedPreferences.readCacheString('Vehicle Type'),
    };
    provider.updateBookingUserInfo(user);
    if (currentUID.isNotEmpty) {
      final path = await getPhoto.getPhotoLink(currentUID);
      // print(path);
      if (path.isNotEmpty) {
        photo = CachedNetworkImageProvider(path);
      }
    }
  }

  void _addingMarkerToPosition(
      Position currentPosition, BookingProvider provider) {
    MarkerId riderMarkerId = const MarkerId('Rider Position ID');
    bool markerExists = provider.pinnedMarkers
        .any((marker) => marker.markerId == riderMarkerId);
    if (markerExists) {
      Marker oldMarker = provider.pinnedMarkers
          .firstWhere((marker) => marker.markerId == riderMarkerId);
      provider.pinnedMarkers.remove(oldMarker);
      provider.addToPinnedMarkers(
        Marker(
          markerId: riderMarkerId,
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
          flat: true,
        ),
      );
    } else {
      provider.addToPinnedMarkers(
        Marker(
          markerId: riderMarkerId,
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
        ),
      );
    }
  }

  String _getFirstNameInFirstSpace(String bookingUserInfo) {
    return bookingUserInfo.split(' ')[0];
  }

  Future<void> getCurrentPos() async {
    final getLocationPermission = await getCurrentLocation();
    if (getLocationPermission != null) {
      userLocation = getLocationPermission;
    } else {
      Fluttertoast.showToast(
          msg: 'Please grant the permission to location services.');
    }
  }

  Future<bool> locationIsInTerminal() async {
    BookingProvider provider =
        Provider.of<BookingProvider>(context, listen: false);
    final zoneRef = await sharedPreferences.readCacheString('Zone Number');

    provider.bookingUserInfo['Zone Number'] = zoneRef;
    print(zoneRef);
    // final zoneRef = provider.bookingUserInfo['Zone Number'];
    return terminals
        .where((terminal) => terminal.zone == zoneRef)
        .any((terminal) {
      bool isWithin = isLocationWithinBounds(
          LatLng(userLocation!.latitude, userLocation!.longitude),
          terminal.coordinates,
          100);
      if (isWithin) {
        provider.updateTerminal(terminal.terminalName);
      } else {
        provider.updateTerminal("");
      }
      return provider.currentTerminal.isNotEmpty;
    });
  }

  void _updateBookingDetails(int index) {
    BookingProvider provider = _getProvider();
    provider.resetBookingInfo();
    final booking = provider.getBooking(index);

    // provider.updatePickup(
    //     provider.riderPickupAddress(index), provider.getPickupLatLng(index));
    // provider.updateDropoff(
    //     provider.riderDropoffAddress(index), provider.getDropOffLatLng(index));
    // currentPhotoLink = provider.photoLinks[index];
    // currentPickupLocation = provider.pickupLocation;
    // currentDropoffLocation = provider.dropoffLocation;
    // currentPolyline = provider.values[index]['Polyline Code'];
    // currentNote = '${provider.values[index]['Note']}';
    // currentDocId = provider.documentID[index];
    // currentDate = provider.getDateStamp(index);
    // currentTime = provider.getTimeStamp(index);
    // currentPassenger = '${provider.values[index]['Commuter Name']}';
    // currentNumber = '${provider.values[index]['Contact Number']}';
    // currentPrice = '${provider.values[index]['Price']}';
  }

  BookingProvider _getProvider() {
    return Provider.of<BookingProvider>(context, listen: false);
  }

  Future<void> enqueuePosition() async {
    final provider = _getProvider();
    final bodyNumber = provider.bookingUserInfo['Body Number'];
    final zone = provider.bookingUserInfo['Zone Number'];
    final queueRef = FirebaseFirestore.instance.collection('Queue');

    final querySnapshot =
        await queueRef.where('Body Number', isEqualTo: bodyNumber).get();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      if (querySnapshot.docs.isNotEmpty) {
        final existingDocRef = queueRef.doc(querySnapshot.docs.first.id);
        transaction.update(existingDocRef, {
          'Queue Position': Timestamp.now().millisecondsSinceEpoch,
          'Available': true,
        });

        provider.updateQueueID(querySnapshot.docs.first.id);
        sharedPreferences.addToCache({
          "Queue ID": querySnapshot.docs.first.id,
        });
      } else {
        final newDocRef = queueRef.doc();
        transaction.set(newDocRef, {
          'Driver Name': provider.bookingUserInfo['Full Name'],
          'Body Number': bodyNumber,
          'Queue Position': Timestamp.now().millisecondsSinceEpoch,
          'Available': true,
          'Zone': zone,
          'Terminal': provider.currentTerminal
        });

        provider.updateQueueID(newDocRef.id);
        sharedPreferences.addToCache({
          "Queue ID": newDocRef.id,
        });
      }
    });
    // final provider = _getProvider();
    // final bodyNumber = provider.bookingUserInfo['Body Number'];
    // final zone = provider.bookingUserInfo['Zone Number'];
    // final driverName = provider.bookingUserInfo['Full Name'];
    // final terminal = provider.currentTerminal;

    // final HttpsCallable callable =
    //     FirebaseFunctions.instance.httpsCallable('enqueueDriver');
    // print('${bodyNumber} $zone $driverName $terminal');
    // try {
    //   final response = await callable.call({
    //     "bodyNumber": bodyNumber,
    //     "zone": zone,
    //     "terminal": terminal,
    //     "driverName": driverName,
    //   });

    //   if (response.data["success"]) {
    //     provider.updateQueueID(response.data["queueId"]);
    //   } else {
    //     print("Failed to enter queue.");
    //   }
    // } catch (e) {
    //   print("Error entering queue: $e");
    // }
  }

  // Future<void> enqueuePosition() async {
  //   final provider = _getProvider();
  //   final bodyNumber = provider.bookingUserInfo['Body Number'];
  //   final zone = provider.bookingUserInfo['Zone Number'];

  //   final queueBodyNumberExists =
  //       await firestoreOperations.retrieveCollectionSnapshots('Queue',
  //           documentPath: zone,
  //           subCollectionPath: '${provider.currentTerminal} Queue',
  //           where: 'Body Number',
  //           equalTo: bodyNumber);

  //   if (queueBodyNumberExists.docs.isNotEmpty) {
  //     firestoreOperations.updateDatabaseValues(
  //         'Queue',
  //         zone,
  //         {
  //           'Queue Position': Timestamp.now().millisecondsSinceEpoch,
  //           'Available': true,
  //         },
  //         subCollectionPath: '${provider.currentTerminal} Queue',
  //         subDocumentPath: queueBodyNumberExists.docs.first.id);
  //     provider.updateQueueID(queueBodyNumberExists.docs[0].id);
  //     sharedPreferences.addToCache({
  //       "Queue ID": queueBodyNumberExists.docs[0].id,
  //     });
  //   } else {
  //     firestoreOperations.addDataToDatabase(
  //       'Queue',
  //       documentPath: zone,
  //       subCollectionPath: '${provider.currentTerminal} Queue',
  //       {
  //         'Driver Name': provider.bookingUserInfo['Full Name'],
  //         'Body Number': provider.bookingUserInfo['Body Number'],
  //         'Queue Position': Timestamp.now().millisecondsSinceEpoch,
  //         'Available': true,
  //       },
  //       onCompleteAdd: (id) {
  //         provider.updateQueueID(id);
  //         sharedPreferences.addToCache({
  //           "Queue ID": id,
  //         });
  //       },
  //     );
  //   }
  // }

  Future<void> dequeuePosition() async {
    final provider = _getProvider();
    final zone = provider.bookingUserInfo['Zone Number'];
    FirebaseFirestore.instance
        .collection('Queue')
        .doc(provider.queueID)
        .update({
      'Available': false,
      'Queue Position': Timestamp.now().millisecondsSinceEpoch,
    });
    // firestoreOperations.updateDatabaseValues('Queue', zone, {},
    //     subCollectionPath: '${provider.currentTerminal} Queue',
    //     subDocumentPath: provider.queueID);
  }

  Future<void> _getTerminal() async {
    final provider = _getProvider();
    userLocation ??= await getCurrentLocation();
    print(userLocation);
    print("Number of terminals ${terminals.length}");
    for (var terminal in terminals) {
      if (isLocationWithinBounds(
          LatLng(userLocation!.latitude, userLocation!.longitude),
          terminal.coordinates,
          30)) {
        provider.updateTerminal(terminal.terminalName);
        print("Terminal: ${provider.currentTerminal}");
      } else {
        print("Not in terminal");
      }
    }
  }

  Stream<int> queueListener() {
    final provider = _getProvider();
    final zone = provider.bookingUserInfo['Zone Number'];
    final terminal = provider.currentTerminal;
    return FirebaseFirestore.instance
        .collection('Queue')
        // .doc(provider.bookingUserInfo['Zone Number'])
        // .collection('${provider.currentTerminal} Queue')
        .where('Available', isEqualTo: true)
        .where('Zone', isEqualTo: zone)
        .where('Terminal', isEqualTo: terminal)
        .orderBy('Queue Position')
        .snapshots()
        .map((querySnapshot) {
      final queriedDocs = querySnapshot.docs;

      for (int index = 0; index < queriedDocs.length; index++) {
        final docData = queriedDocs[index].data();

        if (docData.containsKey('Body Number') &&
            docData['Body Number'] == provider.bookingUserInfo['Body Number']) {
          // setState(() {
          //   nextInLine = (index == 0);
          // });
          return index;
        }
      }
      if (queriedDocs.isNotEmpty) {
        if (queueTimer?.isActive ?? false) {
          queueTimer?.cancel();
        }
        //   setState(() {
        //     nextInLine = false;
        //   });
      }
      return queriedDocs.length;
    }).distinct();
  }

  // Stream<int> queueListener() {
  //   final provider = _getProvider();

  //   return FirebaseFirestore.instance
  //       .collection('Queue')
  //       .doc(provider.bookingUserInfo['Zone Number'])
  //       .collection('${provider.currentTerminal} Queue')
  //       .snapshots()
  //       .map((querySnapshot) {
  //     final queriedDocs = querySnapshot.docs
  //         .where((doc) => doc.data()['Available'] == true)
  //         .toList();

  //     queriedDocs.sort(
  //       (a, b) {
  //         final docA = a.data()['Queue Position'] as int;
  //         final docB = b.data()['Queue Position'] as int;

  //         return docA.compareTo(docB);
  //       },
  //     );

  //     for (int index = 0; index < queriedDocs.length; index++) {
  //       final doc = queriedDocs[index].data() as Map<String, dynamic>;
  //       if (doc['Body Number'] == provider.bookingUserInfo['Body Number']) {
  //         return index;
  //       }
  //     }
  //     return queriedDocs.length;
  //   });
  // }

  void reloadTerminatedBooking() async {
    final provider = _getProvider();
    final bookingID = await sharedPreferences.readCacheString("Booking ID");
    final zone = await sharedPreferences.readCacheString("Zone");
    if (bookingID != null &&
        bookingID.isNotEmpty &&
        zone != null &&
        zone.isNotEmpty) {
      print(bookingID);

      try {
        final booking = await firestoreOperations.retrieveDatabaseValues(
          'Booking_Details',
          bookingID,
        );
        if (booking['Booking Status'] == 'Ongoing') {
          setState(() {
            isOnline = true;
          });
          provider.values.add(booking);
          provider.documentID.add(bookingID);
          Future.delayed(const Duration(seconds: 1), () {
            _updateBookingDetails(0);
            updateBooking(provider);
          });

          Future.delayed(const Duration(seconds: 1), () {
            controlDraggable(bookingDraggableController, 1, Curves.easeInCirc);
          });
        }
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  void _listenToBooking(String currentDocId) {
    print(currentDocId);
    FirebaseFirestore.instance
        .collection('Booking_Details')
        .doc(currentDocId)
        .snapshots()
        .listen((snapshot) {
      print('listening..');
      final data = snapshot.data();
      if (data != null && data['Booking Status'] == 'Cancelled') {
        if (!_hasShownCancelledDialog) {
          _hasShownCancelledDialog = true;
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                iconAndButtonColor: errorColor,
                title: 'Booking Cancelled',
                content: 'This booking has been cancelled.',
                onclick: () {
                  Navigator.of(context).pop();
                  _resetValues('Cancelled', resetOnlineStatus: true);
                },
              );
            },
          );
        }
      }
    });
  }

  bool allowedVehicleTypes(String vehicle) {
    List<String> vehicles = ['bukyo', 'tricycle', 'etrike'];
    String normalize(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');

    String normalizedVehicle = normalize(vehicle);

    for (var v in vehicles) {
      if (normalize(v) == normalizedVehicle) {
        return true;
      }
    }
    return false;
  }
}
