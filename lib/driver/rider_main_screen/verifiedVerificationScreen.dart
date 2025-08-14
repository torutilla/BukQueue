import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/callSnackbar.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilDrawer.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/bookingDraggable.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class VerifiedVerificationScreen extends StatelessWidget {
  final bool isOnline;
  final TabController mainTabController;
  final List<IconData> bottomNavsIcon;
  final List<String> bottomNavsIconLabel;
  final CachedNetworkImageProvider? photo;
  final List<Widget> currentPage;
  final Function(bool) onOnlineToggle;
  final Function onDraggableButtonTap;
  final BookingDraggable bookingDraggable;

  VerifiedVerificationScreen({
    super.key,
    required this.isOnline,
    required this.mainTabController,
    required this.bottomNavsIcon,
    required this.bottomNavsIconLabel,
    required this.photo,
    required this.currentPage,
    required this.onOnlineToggle,
    required this.onDraggableButtonTap,
    required this.bookingDraggable,
  });
  final sharedPreferences = UserSharedPreferences();
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context, provider, _) {
      return Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: primaryColor,
            height: 70,
            notchMargin: 8,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(0),
            child: TabBar(
                isScrollable: false,
                indicator: BoxDecoration(
                  color: accentColor.withBlue(10),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0,
                controller: mainTabController,
                labelColor: softWhite,
                unselectedLabelColor: secondaryColor.withOpacity(0.4),
                tabs: List.generate(3, (index) {
                  return Tab(
                    text: bottomNavsIconLabel[index],
                    icon: Icon(bottomNavsIcon[index]),
                  );
                })),
          ),
          drawer: UtilDriverDrawer(
            photo: photo,
            onLogout: () async {
              await ClearDataAndSignOut().authSignOutAndClearCache();
              await sharedPreferences.addToCache({"Initial Screen": "Login"});
            },
            driverName: provider.bookingUserInfo['Full Name'] ?? 'Driver',
            driverContact:
                provider.bookingUserInfo['Contact Number'] ?? '+630000000000',
          ),
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSwitch(
                  activeColor: accentColor,
                  trackColor: secondaryColor.withOpacity(0.2),
                  value: isOnline,
                  onChanged: (value) async {
                    onOnlineToggle(value);
                    if (userLocation == null) {
                      Fluttertoast.showToast(
                          msg: 'Trying to fetch location...');
                      userLocation = await getCurrentLocation();
                      return;
                    }
                    if (!allowedVehicleTypes(
                        provider.bookingUserInfo['Vehicle Type'])) {
                      CallSnackbar().callSnackbar(context,
                          'Unsupported Vehicle Type - Booking Unavailable');
                      return;
                    }
                    if (isBookingOngoing) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'The switch cannot be toggled while a booking is in progress.')),
                      );
                      return;
                    }
                    bool locationInTerminal = await locationIsInTerminal();
                    print("In Terminal: $locationInTerminal");
                    if (locationInTerminal) {
                      // await _getTerminal();
                      setState(() {
                        enableQueueDraggable = true;
                        if (!isOnline) {
                          isOnline = value;
                          controlDraggable(
                              queueDraggable, 0.9, Curves.easeInCubic);
                          //     provider.updateTerminal(_getTerminal());
                          //     Future.delayed(const Duration(seconds: 1), () {
                          // provider.listenToBookingDatabaseValues();
                          //     });
                          // controlDraggable(
                          //     draggableController, 1, Curves.easeInCubic);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: const TextTitle(
                                    text: 'Switching Off Bookings',
                                    textColor: errorColor,
                                    maxLines: 2,
                                  ),
                                  content: const Text(
                                      'You haven\'t accepted any bookings yet. Are you sure you want to turn off bookings?'),
                                  actions: [
                                    SizedBox(
                                      width: 100,
                                      child: PrimaryButton(
                                          backgroundColor: errorColor,
                                          buttonText: 'No',
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: PrimaryButton(
                                          backgroundColor: grayInputBox,
                                          buttonText: 'Yes',
                                          onPressed: () {
                                            setState(() {
                                              isOnline = value;
                                            });
                                            dequeuePosition();
                                            controlDraggable(
                                                draggableController,
                                                0,
                                                Curves.easeOutCubic);
                                            controlDraggable(queueDraggable, 0,
                                                Curves.easeOutCubic);
                                            Navigator.of(context).pop();
                                          }),
                                    ),
                                  ],
                                );
                              });

                          //     isBookingOngoing = false;
                          //     provider.stopListeningToDatabase();
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Not currently in terminal')),
                      );
                    }
                  },
                ),
              ),
            ],
            backgroundColor: primaryColor,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // setState(() {});

                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text(
              'Welcome, ${_getFirstNameInFirstSpace(provider.bookingUserInfo['Full Name'] ?? 'Driver')}!',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.white, fontSize: 17),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: mainTabController,
                  children: List.generate(3, (index) {
                    return currentPage[index];
                  })),
              Container(
                margin: const EdgeInsets.only(bottom: 40, right: 16),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  tooltip: 'Show bookings',
                  mini: true,
                  backgroundColor: isOnline ? primaryColor : grayColor,
                  shape: const CircleBorder(),
                  onPressed: () {
                    onDraggableButtonTap();
                    if (enableQueueDraggable) {
                      controlDraggable(queueDraggable, 0.9, Curves.easeInCubic);
                    } else if (isOnline && isBookingOngoing) {
                      controlDraggable(
                          bookingDraggableController, 0.9, Curves.easeInCubic);
                    } else if (isOnline) {
                      controlDraggable(
                          draggableController, 0.9, Curves.easeInCubic);
                    }
                  },
                  child: const Icon(
                    Icons.arrow_drop_up_sharp,
                    color: softWhite,
                  ),
                ),
              ),
              if (!isOnline)
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    ModalBarrier(
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextTitle(
                            text: 'Bookings are currently disabled.',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          TextTitle(
                            text:
                                'Toggle the switch in the top-right corner to enable booking.',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              bookingDraggable,

              // showBookingDraggableSheet(context),
              _initializeSheet(context),
              queueDraggableSheet(context),
            ],
          ));
    });
  }

  String _getFirstNameInFirstSpace(String bookingUserInfo) {
    return bookingUserInfo.split(' ')[0];
  }
}
