import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_try_thesis/account_management_pages/accountBanning.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/commuter/booking_management/bookingDetails.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/feedback.dart';
import 'package:flutter_try_thesis/constants/removeOverlay.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/alert.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/bookingDetailsContent.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/overlayEntryCard.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilDrawer.dart';
import 'package:flutter_try_thesis/models/dateTimeConverter.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/uploadImage.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:flutter_try_thesis/map/mainMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreenWithMap extends StatefulWidget {
  const MainScreenWithMap({
    super.key,
  });

  @override
  MapState createState() => MapState();
}

class MapState extends State<MainScreenWithMap>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  FeedbackFirestoreComms feedbackFirestore = FeedbackFirestoreComms();
  Color cardColor = const Color.fromARGB(255, 243, 243, 243);
  FirestoreOperations firestoreOperations = FirestoreOperations();
  DateTimeConvert dateTimeConvert = DateTimeConvert();
  GetPhotoLinkOfUser getPhoto = GetPhotoLinkOfUser();
  String _documentID = '';
  bool showBottomNavbar = true;
  String commuterFullName = 'Commuter';
  String commuterContact = '';
  String commuterUID = '';
  Timer? deletionTimer;
  bool bookingActive = false;
  OverlayEntry? bookingOverlayEntry;
  late AnimationController animationController;
  Map<String, dynamic> bookingDetails = {};
  DraggableScrollableController bookingScrollableController =
      DraggableScrollableController();
  AccountBanning accountBan = AccountBanning();
  UserSharedPreferences sharedPrefs = UserSharedPreferences();
  late AnimationController completedBookingAnimationController;
  DraggableScrollableController priceAndZoneDraggable =
      DraggableScrollableController();
  bool bookingFailed = false;
  bool enablePriceDraggable = true;
  Offset initialOffsetPriceDraggableContainer = const Offset(0, 0.5);

  TextEditingController _noteController = TextEditingController();
  CachedNetworkImageProvider? photo;

  Timer? debounce;
  final cancelGracePeriod = 60;

  @override
  void initState() {
    super.initState();
    _initializeSharedPrefsValues();
    sharedPrefs.addToCache({"Initial Screen": "Map"});
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    completedBookingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: UtilityDrawer(
          photo: photo,
          onLogout: () async {
            await sharedPrefs.addToCache({"Initial Screen": "Login"});
            MyRouter.navigateToNextPermanent(context, const LoginForm());
            removePastBookingCache();
            await ClearDataAndSignOut().authSignOutAndClearCache();
            // firestoreOperations.deleteDatabaseValues(
            //     'Booking_Details', _documentID);
          },
          commuterName: commuterFullName,
          commuterContact: commuterContact,
        ),
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {});

                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
            'Welcome, ${_getNameBeforeSpace(commuterFullName)}!',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: PopScope(
          canPop: false,
          child: Stack(
            children: [
              SizedBox(
                width: ScreenUtil.parentWidth(context),
                height: ScreenUtil.parentHeight(context),
                child: const MainMap(),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: provider.price != 0 && enablePriceDraggable
                    ? Offset.zero
                    : initialOffsetPriceDraggableContainer,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 220,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: accentColor,
                            width: 2,
                          )),
                      width: ScreenUtil.parentWidth(context) * 0.9,
                      height: 95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                height: 40,
                                'assets/images/Bukyo.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              Text(
                                '${provider.zoneRef}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${provider.currentTerminal}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Estimated Price',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextTitle(
                                text: 'P${provider.price}.00',
                                textColor: accentColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bookingDraggableSheet(context),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  offset: showBottomNavbar ? Offset.zero : const Offset(0, 10),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(color: Colors.black12, width: 1))),
                    width: ScreenUtil.parentWidth(context),
                    height: 90,
                    padding: const EdgeInsets.only(
                        top: 16, right: 24, left: 24, bottom: 16),
                    child: PrimaryButton(
                      onPressed: () async {
                        if (provider.pickupLatLng != null &&
                            provider.dropoffLatLng != null &&
                            provider.bookingPolyline.isNotEmpty) {
                          // controlDraggable(
                          //     priceAndZoneDraggable, 0, Curves.easeOutCubic);

                          _setToBooking(provider);
                          setState(() {
                            enablePriceDraggable = false;
                          });
                          // Timer(Duration(seconds: cancelGracePeriod), () {
                          //   _addBookingDetailsToDatabase(
                          //     provider.pickupLocation,
                          //     provider.dropoffLocation,
                          //     provider.pickupLatLng!,
                          //     provider.dropoffLatLng!,
                          //     provider.passengerCount,
                          //     provider.notes,
                          //     provider.polylineCode,
                          //     provider,
                          //   );
                          // });
                          _addBookingDetailsToDatabase(
                            provider.pickupLocation,
                            provider.dropoffLocation,
                            provider.pickupLatLng!,
                            provider.dropoffLatLng!,
                            provider.passengerCount,
                            provider.notes,
                            provider.polylineCode,
                            provider,
                          );
                        } else {
                          // controlDraggable(bookingScrollableController, 1,
                          //     Curves.easeInCubic);
                          // showDialog(
                          //   barrierDismissible: false,
                          //   barrierColor: Colors.black12,
                          //   context: context,
                          //   builder: (context) {
                          //     double starValue = 1;
                          //     return OverlayEntryCard(
                          //       enableBackButton: false,
                          //       dismissable: false,
                          //       actions: [],
                          //       animationController:
                          //           completedBookingAnimationController,
                          //       borderRadius: BorderRadius.circular(16),
                          //       titleText: 'Feedback and Review',
                          //       height: ScreenUtil.parentHeight(context) * 0.6,
                          //       width: ScreenUtil.parentWidth(context) * 0.9,
                          //       child: LayoutBuilder(
                          //           builder: (context, constraints) {
                          //         return Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //             const TextTitle(
                          //               text: 'Destination Reached',
                          //               textColor: primaryColor,
                          //             ),
                          //             const Text('Rate your experience'),
                          //             RatingBar(
                          //               minRating: 1,
                          //               maxRating: 5,
                          //               initialRating: starValue,
                          //               glow: false,
                          //               ratingWidget: RatingWidget(
                          //                 full: const Icon(
                          //                   Icons.star,
                          //                   color: accentColor,
                          //                 ),
                          //                 half: const Icon(
                          //                   Icons.star,
                          //                   color: accentColor,
                          //                 ),
                          //                 empty: const Icon(
                          //                   Icons.star,
                          //                   color: grayInputBox,
                          //                 ),
                          //               ),
                          //               onRatingUpdate: (value) {
                          //                 starValue = value;
                          //               },
                          //             ),
                          //             const Text('Share your experience'),
                          //             TextFormField(
                          //               controller: _noteController,
                          //               cursorColor: primaryColor,
                          //               textAlign: TextAlign.left,
                          //               maxLines: 5,
                          //               decoration: InputDecoration(
                          //                 hintText: 'Write something...',
                          //                 focusedBorder: OutlineInputBorder(
                          //                   borderSide: const BorderSide(
                          //                       color: primaryColor),
                          //                   borderRadius:
                          //                       BorderRadius.circular(8),
                          //                 ),
                          //                 border: OutlineInputBorder(
                          //                   borderSide: const BorderSide(
                          //                     width: 0.5,
                          //                   ),
                          //                   borderRadius:
                          //                       BorderRadius.circular(8),
                          //                 ),
                          //               ),
                          //               style: const TextStyle(fontSize: 14),
                          //             ),
                          //             Container(
                          //               margin: EdgeInsets.all(8),
                          //               width: constraints.maxWidth * 0.9,
                          //               child: PrimaryButton(
                          //                 buttonText: 'Confirm',
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop();
                          //                   _resetValues(true);
                          //                 },
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       }),
                          //     );
                          //   },
                          // );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please fill up all details or confirm booking to proceed.')),
                          );
                        }
                      },
                      buttonText: 'Book Now',
                      onPressedColor: grayColor.withRed(255),
                      backgroundColor: provider.dropoffLatLng != null &&
                              provider.pickupLatLng != null &&
                              provider.bookingPolyline.isNotEmpty
                          ? primaryColor
                          : grayColor,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: ScreenUtil.parentHeight(context) * 0.20,
                    width: ScreenUtil.parentWidth(context) * 0.90 <= 350
                        ? ScreenUtil.parentWidth(context) * 0.90
                        : 350,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Consumer<BookingProvider>(
                            builder: (context, title, child) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: secondaryColor,
                                width: 0.5,
                              ),
                            ),
                            color: cardColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  onTap: () async {
                                    // if (await accountBan.isAccountBanned()) {
                                    //   showBanAccountStatus();
                                    //   return;
                                    // }
                                    if (bookingActive) {
                                      showBookingOverlayEntry(context);
                                    } else {
                                      MyRouter.navigateToNextNoTransition(
                                          context,
                                          const BookingDetails(
                                            pickUp: true,
                                          ));
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.my_location_sharp,
                                          color: primaryColor,
                                          size: 21,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PICK-UP',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: primaryColor,
                                                    fontSize: 12),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: 38,
                                            width: constraints.maxWidth * 0.60,
                                            child: Text(
                                              title.pickupLocation.isNotEmpty
                                                  ? title.pickupLocation
                                                  : 'Select Pick-up',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      fontSize: title
                                                              .pickupLocation
                                                              .isNotEmpty
                                                          ? 13
                                                          : 16,
                                                      color: grayColor,
                                                      overflow:
                                                          TextOverflow.fade),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  endIndent: 16,
                                  indent: 16,
                                  height: 0.5,
                                ),
                                InkWell(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                  onTap: () async {
                                    // if (await accountBan.isAccountBanned()) {
                                    //   showBanAccountStatus();
                                    //   return;
                                    // }
                                    if (bookingActive) {
                                      showBookingOverlayEntry(context);
                                    } else {
                                      MyRouter.navigateToNextNoTransition(
                                          context, const BookingDetails());
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.location_on,
                                          color: accentColor,
                                          size: 24,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'DROP-OFF',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: accentColor,
                                                    fontSize: 12),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: constraints.maxWidth * 0.60,
                                            height: 38,
                                            child: Text(
                                              title.dropoffLocation.isNotEmpty
                                                  ? title.dropoffLocation
                                                  : 'Select Drop-off',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      fontSize: title
                                                              .dropoffLocation
                                                              .isNotEmpty
                                                          ? 13
                                                          : 16,
                                                      color: grayColor,
                                                      overflow:
                                                          TextOverflow.fade),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _addBookingDetailsToDatabase(
    String pickupName,
    String dropoffName,
    LatLng pickupCoord,
    LatLng dropoffCoord,
    String passengerCount,
    String notes,
    String polylineCode,
    BookingProvider provider,
  ) async {
    final timeStamp = Timestamp.now();
    bookingDetails = {
      "Zone": provider.zoneRef,
      "Terminal": provider.currentTerminal,
      "Pickup Location": pickupName,
      "Dropoff Location": dropoffName,
      "Pickup LatLng": GeoPoint(pickupCoord.latitude, pickupCoord.longitude),
      "Dropoff LatLng": GeoPoint(dropoffCoord.latitude, dropoffCoord.longitude),
      "Polyline Code": polylineCode,
      "Booking Status": "For Booking",
      "Time Stamp": timeStamp,
      "Passenger Count": passengerCount,
      "Price": provider.price,
      "Note": notes,
      "Commuter UID": provider.bookingUserInfo['UID'],
      "Commuter Name": provider.bookingUserInfo['Full Name'],
      "Contact Number": provider.bookingUserInfo['Contact Number'],
    };
    try {
      FirebaseFirestore.instance
          .collection('Booking_Details')
          .add(bookingDetails)
          .then((doc) {
        _documentID = doc.id;
      });
      firestoreOperations.addDataToDatabase(
        'Booking_Details',
        bookingDetails,
        onCompleteAdd: (id) {
          _documentID = id;
          _listenToBookingChanges(provider);
          firestoreOperations.updateDatabaseValues(
            'Booking_Details',
            _documentID,
            {"Booking ID": _documentID},
          );
          sharedPrefs.setBool("Past Booking", true);
          sharedPrefs.addToCache({
            "Past Booking ID": id,
            "Past Booking Pickup": pickupName,
            "Past Booking Dropoff": dropoffName,
            "Past Notes": notes,
            "Past PickupLatLng":
                '${pickupCoord.latitude},${pickupCoord.longitude}',
            "Past DropoffLatLng":
                '${dropoffCoord.latitude},${dropoffCoord.longitude}',
            "Past Polyline": polylineCode,
            "Past Zone": provider.zoneRef,
          });
          sharedPrefs.addIntValue("Past Price", provider.price);
          print(id);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void addTimerToBooking(BookingProvider provider) {
    deletionTimer = Timer(const Duration(minutes: 3), () {
      setState(() {
        bookingFailed = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        firestoreOperations.deleteDatabaseValues(
            'Booking_Details', _documentID);
        _resetValues();
      });
    });
  }

  void _listenToBookingChanges(BookingProvider provider) {
    firestoreOperations.listenToDatabaseValues(
      'Booking_Details',
      documentPath: _documentID,
      listener: (snapshot) {
        if (snapshot.exists) {
          final bookingStatus = snapshot.get('Booking Status');
          if (bookingStatus == "Ongoing") {
            deletionTimer?.cancel();
            provider.bookingAvailable(true);

            provider.updateDriverInfoForBooking(snapshot.data());
            controlDraggable(bookingScrollableController, 0, Curves.easeOut);
            Future.delayed(const Duration(milliseconds: 500), () {
              controlDraggable(bookingScrollableController, 1, Curves.easeOut);
            });
          } else if (bookingStatus == "Cancelled") {
            deletionTimer?.cancel();
            showDialog(
                barrierDismissible: false,
                barrierColor: Colors.black12,
                context: context,
                builder: (BuildContext builderContext) {
                  return CustomAlertDialog(
                    iconAndButtonColor: errorColor,
                    title: 'Booking Cancelled',
                    content: 'Your booking has been cancelled.',
                    onclick: () {
                      Navigator.pop(builderContext);
                      _resetValues(true);
                    },
                  );
                });
            removePastBookingCache();
          } else if (bookingStatus == "Completed") {
            completedBookingAnimationController.forward();
            showDialog(
              barrierDismissible: false,
              barrierColor: Colors.black12,
              context: context,
              builder: (context) {
                double starValue = 1;
                return OverlayEntryCard(
                  enableBackButton: false,
                  dismissable: false,
                  actions: [],
                  animationController: completedBookingAnimationController,
                  borderRadius: BorderRadius.circular(16),
                  titleText: 'Feedback and Review',
                  height: ScreenUtil.parentHeight(context) * 0.7,
                  width: ScreenUtil.parentWidth(context) * 0.9,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const TextTitle(
                                text: 'Destination Reached',
                                textColor: primaryColor,
                              ),
                              const Text('Rate your experience'),
                              RatingBar(
                                minRating: 1,
                                maxRating: 5,
                                initialRating: starValue,
                                glow: false,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star,
                                    color: accentColor,
                                  ),
                                  half: const Icon(
                                    Icons.star,
                                    color: accentColor,
                                  ),
                                  empty: const Icon(
                                    Icons.star,
                                    color: grayInputBox,
                                  ),
                                ),
                                onRatingUpdate: (value) {
                                  starValue = value;
                                },
                              ),
                              const Text('Share your experience'),
                              TextFormField(
                                controller: _noteController,
                                cursorColor: primaryColor,
                                textAlign: TextAlign.left,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Write something...',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.8,
                                child: PrimaryButton(
                                  buttonText: 'Confirm',
                                  onPressed: () {
                                    try {
                                      feedbackFirestore.addFeedback({
                                        "Date": dateTimeConvert
                                            .convertTimeStampToDate(
                                                Timestamp.now()),
                                        "Feedback": _noteController.text,
                                        "Rating": starValue,
                                        "Driver UID": provider
                                            .driverInfoForBooking['Driver UID'],
                                        "Driver Name":
                                            provider.driverInfoForBooking[
                                                'Driver Name'],
                                        "Commuter UID":
                                            provider.bookingUserInfo['UID'],
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                    Navigator.of(context).pop();
                                    _resetValues(true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            );

            removePastBookingCache();
          } else {
            addTimerToBooking(provider);
          }
        }
      },
    );
  }

  void controlDraggable(
      DraggableScrollableController controller, double size, Curve curve) {
    controller.animateTo(size,
        duration: const Duration(milliseconds: 400), curve: curve);
  }

  Widget bookingDraggableSheet(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context, provider, child) {
      return DraggableScrollableSheet(
          controller: bookingScrollableController,
          minChildSize: 0.1,
          initialChildSize: 0.1,
          maxChildSize: provider.isBookingAvailable ? 0.7 : 0.4,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: ScreenUtil.parentWidth(context),
                        height: 30,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      Container(
                        color: grayInputBox,
                        width: 90,
                        height: 5,
                      ),
                    ],
                  ),
                  Container(
                    height: provider.isBookingAvailable
                        ? ScreenUtil.parentHeight(context) * 0.65 - 30
                        : ScreenUtil.parentHeight(context) * 0.4 - 50,
                    width: ScreenUtil.parentWidth(context),
                    color: Colors.white,
                    child: provider.isBookingAvailable
                        ? onGoingBookingWidget(provider)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextTitle(
                                text: !bookingFailed
                                    ? 'Searching for Driver in ${provider.zoneRef}'
                                    : 'No driver found. Please try again later',
                                textColor: primaryColor,
                                fontSize: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: !bookingFailed
                                    ? const CircularProgressIndicator(
                                        color: accentColor,
                                      )
                                    : null,
                              ),
                              SizedBox(
                                width: 160,
                                child: PrimaryButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            iconColor: errorColor,
                                            actions: [
                                              SizedBox(
                                                width: 90,
                                                child: PrimaryButton(
                                                  backgroundColor: softWhite,
                                                  textColor: blackColor,
                                                  onPressed: () {
                                                    if (debounce?.isActive ??
                                                        false) {
                                                      debounce?.cancel();
                                                    }

                                                    debounce = Timer(
                                                        const Duration(
                                                            milliseconds: 300),
                                                        () async {
                                                      try {
                                                        await firestoreOperations
                                                            .startTransaction(
                                                                (transaction) async {
                                                          final booking =
                                                              await transaction
                                                                  .get(
                                                            firestoreOperations
                                                                .getDocumentReference(
                                                              'Booking_Details',
                                                              _documentID,
                                                            ),
                                                          );

                                                          if (booking.exists &&
                                                              booking['Booking Status'] ==
                                                                  'For Booking') {
                                                            transaction.update(
                                                              firestoreOperations
                                                                  .getDocumentReference(
                                                                'Booking_Details',
                                                                _documentID,
                                                              ),
                                                              {
                                                                'Booking Status':
                                                                    'Cancelled'
                                                              },
                                                            );
                                                          } else if (booking[
                                                                  'Booking Status'] ==
                                                              'Accepted') {
                                                            throw Exception(
                                                                'The booking has already been accepted.');
                                                          } else {
                                                            throw Exception(
                                                                'Action cannot be performed.');
                                                          }
                                                        });

                                                        _resetValues();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Booking successfully cancelled.')),
                                                        );
                                                      } catch (error) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(error
                                                                  .toString())),
                                                        );
                                                      }
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                  buttonText: 'Yes',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90,
                                                child: PrimaryButton(
                                                    backgroundColor: errorColor,
                                                    onPressedColor:
                                                        errorColor.withRed(50),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    buttonText: 'No'),
                                              ),
                                            ],
                                            content: const Text(
                                                'Are you sure you want to cancel the booking?'),
                                            title: const TextTitle(
                                              text: 'Cancel Booking',
                                              textColor: errorColor,
                                            ),
                                            icon: const Icon(
                                              Icons.error,
                                              size: 48,
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                          );
                                        });
                                  },
                                  buttonText: 'Cancel',
                                  backgroundColor: Colors.white,
                                  textColor: primaryColor,
                                  borderColor: primaryColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          });
    });
  }

  Widget onGoingBookingWidget(BookingProvider provider) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              'Driver is on their way. (Est. time: ${provider.driverInfoForBooking['Estimated Arrival Time'] != null ? convertDecimalToReadableTime(provider.driverInfoForBooking['Estimated Arrival Time']) : 'Calculating time of arrival...'})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: FutureBuilder(
                    future: getPhoto.getPhotoLink(
                        provider.driverInfoForBooking['Driver UID']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return CircleAvatar(
                          foregroundImage:
                              CachedNetworkImageProvider(snapshot.data!),
                          child: Icon(Icons.person),
                        );
                      }
                      return CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.person),
                      );
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ScreenUtil.parentWidth(context) * 0.85,
                    child: TextTitle(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      fontSize: 20,
                      text:
                          '${provider.driverInfoForBooking['Driver Name'] != null ? provider.driverInfoForBooking['Driver Name'] : 'Driver'}',
                      textColor: primaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            height: 20,
                            width: 20,
                            'assets/images/Bukyo.svg',
                            colorFilter: const ColorFilter.mode(
                                accentColor, BlendMode.srcIn),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(provider.zoneRef),
                          ),
                        ],
                      ),
                      Text(
                          'Plate: ${provider.driverInfoForBooking['Plate Number']}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            height: 0.5,
            thickness: 0.3,
            color: grayInputBox,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Payment',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: primaryColor),
                  ),
                  const Text('Cash'),
                ],
              ),
              TextTitle(
                text: 'P${provider.price}.00',
                textColor: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Text(
              '${DateFormat.yMMMMd('en_US').format(Timestamp.now().toDate())}'),
          Text('Transaction ID: $_documentID'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      width: constraints.maxWidth * 0.45,
                      child: PrimaryButton(
                        prefixIcon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        backgroundColor: primaryColor.withOpacity(0.7),
                        onPressed: () {
                          callNumber(
                              '${provider.driverInfoForBooking['Driver Contact']}');
                        },
                        buttonText: 'Call',
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: constraints.maxWidth * 0.45,
                      child: PrimaryButton(
                        prefixIcon: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        onPressedColor: accentColor,
                        backgroundColor: accentColor.withOpacity(0.7),
                        onPressed: () {
                          messageNumber(
                              '${provider.driverInfoForBooking['Driver Contact']}');
                        },
                        buttonText: 'Message',
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  height: 50,
                  width: constraints.maxWidth * 0.95,
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
                                    buttonText: 'Yes',
                                    onPressed: () {
                                      firestoreOperations.updateDatabaseValues(
                                        'Booking_Details',
                                        _documentID,
                                        {
                                          "Booking Status": "Cancelled",
                                        },
                                      );
                                      _resetValues(true);
                                      Navigator.of(context).pop();
                                    },
                                    backgroundColor: grayInputBox,
                                    textColor: Colors.black,
                                    onPressedColor: grayColor.withRed(50),
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: PrimaryButton(
                                    onPressedColor: errorColor.withRed(50),
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
                    buttonText: 'Cancel Booking',
                    backgroundColor: errorColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void showBookingOverlayEntry(BuildContext context) {
    bookingOverlayEntry = OverlayEntry(builder: (context) {
      return OverlayEntryCard(
        animationController: animationController,
        onDismiss: () {
          removeOverlay(bookingOverlayEntry,
              animationController: animationController);
        },
        height: ScreenUtil.parentHeight(context) * 0.8,
        width: ScreenUtil.parentWidth(context) * 0.9,
        titleText: 'Booking Details',
        child: BookingInformationContent(
          price: '${bookingDetails['Price']}',
          pickupLocation: bookingDetails['Pickup Location'],
          dropoffLocation: bookingDetails['Dropoff Location'],
          bookingID: _documentID,
          notes: bookingDetails['Note'],
          date: DateFormat.yMMMMd('en_US')
              .format(bookingDetails['Time Stamp'].toDate()),
          time: DateFormat.jm().format(bookingDetails['Time Stamp'].toDate()),
        ),
      );
    });
    Overlay.of(context, debugRequiredFor: widget).insert(bookingOverlayEntry!);
    animationController.forward();
  }

  void _initializeSharedPrefsValues() async {
    BookingProvider provider =
        Provider.of<BookingProvider>(context, listen: false);
    commuterFullName = (await sharedPrefs.readCacheString('Full Name'))!;
    commuterContact = (await sharedPrefs.readCacheString('Contact Number'))!;
    commuterUID = (await sharedPrefs.readCacheString('UID'))!;
    final path = await getPhoto.getPhotoLink(commuterUID);
    if (path.isNotEmpty) {
      photo = CachedNetworkImageProvider(path);
    }

    provider.updateBookingUserInfo({
      "Full Name": commuterFullName,
      "Contact Number": commuterContact,
      "UID": commuterUID,
    });
    final loadPastBooking = (await sharedPrefs.readCacheBool('Past Booking'));
    _documentID = (await sharedPrefs.readCacheString("Past Booking ID")) ?? '';
    print(_documentID);
    if (loadPastBooking != null && loadPastBooking && _documentID.isNotEmpty) {
      final pastPickup =
          (await sharedPrefs.readCacheString('Past Booking Pickup'));
      final pastDropoff =
          (await sharedPrefs.readCacheString('Past Booking Dropoff'));
      final pastPickupLatLng = await _getLatLng('Past PickupLatLng');
      final pastDropoffLatLng = await _getLatLng('Past DropoffLatLng');
      final pastPolyline = await sharedPrefs.readCacheString('Past Polyline');
      final pastNotes = await sharedPrefs.readCacheString('Past Notes');
      final pastZone = await sharedPrefs.readCacheString("Past Zone");
      final pastPrice = await sharedPrefs.readInt("Past Price");
      final polyline = PolylinePoints().decodePolyline(pastPolyline!);
      provider.notes = pastNotes!;
      provider.updateZone(pastZone!);
      provider.updatePickup(pastPickup!, pastPickupLatLng);
      provider.updateDropoff(pastDropoff!, pastDropoffLatLng);
      provider.addPolylineListToPolyline(polyline
          .map((element) => LatLng(element.latitude, element.longitude))
          .toList());
      _setToBooking(provider);
      provider.updatePrice(pastPrice!);
      _listenToBookingChanges(provider);
    }
  }

  String _getNameBeforeSpace(String name) {
    return name.split(' ')[0];
  }

  void _resetValues([bool resetProvider = false]) {
    var provider = _getProvider(context);
    controlDraggable(bookingScrollableController, 0, Curves.easeOutCubic);
    setState(() {
      enablePriceDraggable = true;
      showBottomNavbar = true;
      bookingFailed = false;
      bookingActive = false;
      _documentID = '';
      _noteController.text = '';
    });
    firestoreOperations.stopListener();
    if (resetProvider) {
      provider.resetBookingInfo();
      provider.resetPolyline();
      provider.isBookingAvailable = false;
      provider.price = 0;
    }
    sharedPrefs.setBool("Past Booking", false);
  }

  BookingProvider _getProvider(BuildContext context) {
    return Provider.of<BookingProvider>(context, listen: false);
  }

  Future<LatLng> _getLatLng(String key) async {
    String latlng = (await sharedPrefs.readCacheString(key))!;
    List<String> parts = latlng.split(',');
    return LatLng(double.parse(parts[0]), double.parse(parts[1]));
  }

  void _setToBooking(BookingProvider provider) {
    setState(() {
      showBottomNavbar = !showBottomNavbar;
      bookingActive = true;
    });

    controlDraggable(bookingScrollableController, 1, Curves.easeInCubic);
  }

  String convertDecimalToReadableTime(double value) {
    int totalMinutes = value.round();

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return "$hours hr${hours > 1 ? 's' : ''} $minutes min${minutes > 1 ? 's' : ''}";
    } else if (hours > 0) {
      return "$hours hr${hours > 1 ? 's' : ''}";
    } else {
      return "$minutes min${minutes > 1 ? 's' : ''}";
    }
  }

  void removePastBookingCache() {
    sharedPrefs.setBool('Past Booking', false);
  }

  void showBanAccountStatus() {
    var date = DateFormat('MMM d, h:mm a').format(accountBan.banDate);
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              iconAndButtonColor: errorColor,
              title: 'Account Banned',
              content: 'Your account is banned until: ${date}',
              onclick: () {
                Navigator.pop(context);
              });
        });
  }

  // String getTerminal(LatLng pickupCoordinate) {
  //   var nearestTerminal = {};

  //   for (int i = 0; i < terminals.length; i++) {
  //     for (int j = i + 1; j < terminals.length; i++) {
  //       var distanceInTerminal =
  //           haversineFormula(pickupCoordinate, terminals[i].coordinates);
  //       nearestTerminal[terminals[i].terminalName] = distanceInTerminal;
  //       if (distanceInTerminal < nearestTerminal.values.elementAt(i)) {

  //       }
  //     }
  //   }
  // }
}

class GetPhotoLinkOfUser {
  ImageUpload imageClass = ImageUpload();
  Future<String> getPhotoLink(String uid, {String photo = 'Photo Link'}) async {
    String photoLink = '';
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('UID', isEqualTo: uid)
        .limit(1)
        .get();
    final data = snapshot.docs.first.data();
    final path = data[photo];
    if (path != null) {
      photoLink = path;
    }
    return photoLink;
  }
}
