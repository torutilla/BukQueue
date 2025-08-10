import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_try_thesis/account_management_pages/login.dart';
import 'package:flutter_try_thesis/admin/pages/adminAccountSettings.dart';
import 'package:flutter_try_thesis/admin/pages/adminAddVehicleType.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/savedPlaces.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/drawer_pages/aboutUs.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/bookingHistory.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/commuterTutorial.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/feedback.dart';
import 'package:flutter_try_thesis/drawer_pages/editProfile.dart';
import 'package:flutter_try_thesis/driver/driver_drawer/commuterFeedback.dart';
import 'package:flutter_try_thesis/driver/driver_drawer/driverProfile.dart';
import 'package:flutter_try_thesis/driver/driver_drawer/driverTutorial.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class UtilityDrawer extends StatelessWidget {
  final String? commuterContact;
  final String? commuterName;
  final CachedNetworkImageProvider? photo;
  final void Function()? onLogout;

  UtilityDrawer({
    super.key,
    this.commuterContact,
    this.commuterName,
    this.onLogout,
    this.photo,
  });
  final UserSharedPreferences sharedPreferences = UserSharedPreferences();
  @override
  Widget build(BuildContext context) {
    double deviceWidth = ScreenUtil.parentWidth(context);
    return Drawer(
      width: deviceWidth <= 300 ? deviceWidth * 0.80 : 280,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.black.withOpacity(0.5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/images/Bukyo.svg',
                        height: constraints.maxWidth * 0.50,
                        colorFilter: const ColorFilter.mode(
                            Color.fromARGB(255, 3, 122, 57), BlendMode.srcIn),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 25.0, bottom: 25.0, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitle(
                            text: 'PROFILE',
                            fontSize: 16,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 50,
                                width: 50,
                                child: CircleAvatar(
                                  foregroundImage: photo,
                                  child: Icon(
                                    Icons.person,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.6,
                                    child: Text(
                                      commuterName != null
                                          ? '$commuterName'
                                          : 'Commuter Name',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    commuterContact != null
                                        ? '$commuterContact'
                                        : '09123456789',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              MyRouter.navigateToNext(
                                  context, const EditProfile());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.edit_square,
                                    size: 16,
                                    color: accentColor,
                                  ),
                                ),
                                const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: accentColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: double.infinity, // Use double.infinity for full width
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, const BookingHistoryCommuter());
                              },
                              leading: const Icon(
                                Icons.history,
                                color: primaryColor,
                              ),
                              title: const Text(
                                'History',
                                style: TextStyle(color: primaryColor),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            ),
                            ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, const MyFeedbacks());
                              },
                              leading: const Icon(
                                Icons.chat,
                                color: primaryColor,
                              ),
                              title: const Text(
                                'Feedback',
                                style: TextStyle(color: primaryColor),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            ),
                            ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, const SavedPlaces());
                              },
                              leading: const Icon(
                                Icons.bookmark,
                                color: primaryColor,
                              ),
                              title: const Text(
                                'Saved Places',
                                style: TextStyle(color: primaryColor),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            ),
                            // ListTile(
                            //   visualDensity: VisualDensity.standard,
                            //   onTap: () {
                            //     MyRouter.navigateToNext(
                            //         context, const CommuterTutorial());
                            //   },
                            //   leading: const Icon(
                            //     Icons.help,
                            //     color: primaryColor,
                            //   ),
                            //   title: const Text(
                            //     'Tutorial',
                            //     style: TextStyle(color: primaryColor),
                            //   ),
                            //   trailing: const Icon(
                            //     Icons.arrow_forward_ios_rounded,
                            //     size: 12,
                            //     color: accentColor,
                            //   ),
                            // ),
                            ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, const AboutUsPage());
                              },
                              leading: const Icon(
                                Icons.info,
                                color: primaryColor,
                              ),
                              title: const Text(
                                'About Us',
                                style: TextStyle(color: primaryColor),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          visualDensity: VisualDensity.standard,
                          onTap: onLogout,
                          leading: const Icon(
                            Icons.logout_rounded,
                            color: errorColor,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: errorColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class UtilDriverDrawer extends StatelessWidget {
  final String? driverContact;
  final String? driverName;
  final void Function()? onLogout;
  final CachedNetworkImageProvider? photo;
  const UtilDriverDrawer({
    super.key,
    this.driverContact,
    this.driverName,
    this.onLogout,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = ScreenUtil.parentWidth(context);
    return Drawer(
      width: deviceWidth <= 300 ? deviceWidth * 0.80 : 280,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.black.withOpacity(0.5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/images/Bukyo.svg',
                        height: constraints.maxWidth * 0.50,
                        colorFilter: const ColorFilter.mode(
                            Color.fromARGB(255, 3, 122, 57), BlendMode.srcIn),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 25.0, bottom: 25.0, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitle(
                            text: 'PROFILE',
                            fontSize: 16,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 50,
                                width: 50,
                                child: CircleAvatar(
                                  foregroundImage: photo,
                                  child: Icon(
                                    Icons.person,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.6,
                                    child: Text(
                                      driverName != null
                                          ? '$driverName'
                                          : 'Driver Name',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    driverContact != null
                                        ? '$driverContact'
                                        : '09123456789',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              MyRouter.navigateToNext(
                                  context,
                                  const EditProfile(
                                    isDriver: true,
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.edit_square,
                                    size: 16,
                                    color: accentColor,
                                  ),
                                ),
                                const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: accentColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: double.infinity, // Use double.infinity for full width
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, const CommuterFeedback());
                              },
                              leading: const Icon(
                                Icons.chat,
                                color: primaryColor,
                              ),
                              title: const Text(
                                'Commuter Feedback',
                                style: TextStyle(color: primaryColor),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            ),
                            // ListTile(
                            //   visualDensity: VisualDensity.standard,
                            //   onTap: () {
                            //     MyRouter.navigateToNext(
                            //         context, const DriverTutorial());
                            //   },
                            //   leading: const Icon(
                            //     Icons.help,
                            //     color: primaryColor,
                            //   ),
                            //   title: const Text(
                            //     'Tutorial',
                            //     style: TextStyle(color: primaryColor),
                            //   ),
                            //   trailing: const Icon(
                            //     Icons.arrow_forward_ios_rounded,
                            //     size: 12,
                            //     color: accentColor,
                            //   ),
                            // ),
                            ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, const AboutUsPage());
                              },
                              leading: const Icon(
                                Icons.info,
                                color: primaryColor,
                              ),
                              title: const Text(
                                'About Us',
                                style: TextStyle(color: primaryColor),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          visualDensity: VisualDensity.standard,
                          onTap: () {
                            onLogout!();
                            MyRouter.navigateToNextPermanent(
                                context, const LoginForm());
                          },
                          leading: const Icon(
                            Icons.logout_rounded,
                            color: errorColor,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: errorColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  final String? adminName;
  final void Function()? onLogout;
  final CachedNetworkImageProvider? photo;
  const AdminDrawer({
    super.key,
    this.adminName,
    this.onLogout,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = ScreenUtil.parentWidth(context);
    return Drawer(
      width: deviceWidth <= 300 ? deviceWidth * 0.80 : 280,
      backgroundColor: adminGradientColor3,
      surfaceTintColor: Colors.black.withOpacity(0.5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [adminGradientColor2, adminGradientColor1],
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/images/Bukyo.svg',
                        height: constraints.maxWidth * 0.50,
                        colorFilter: const ColorFilter.mode(
                            adminGradientColor1, BlendMode.srcIn),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 25.0, bottom: 25.0, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitle(
                            text: 'PROFILE',
                            fontSize: 16,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 50,
                                width: 50,
                                child: CircleAvatar(
                                  foregroundImage: photo,
                                  child: Icon(
                                    Icons.person,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    adminName != null ? '$adminName' : 'Admin',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    'Administrator',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              MyRouter.navigateToNext(
                                  context, AdminAccountSettings());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.edit_square,
                                    size: 16,
                                    color: accentColor,
                                  ),
                                ),
                                const Text(
                                  'Account Settings',
                                  style: TextStyle(color: accentColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: double.infinity, // Use double.infinity for full width
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: List.generate(2, (index) {
                            List<String> text = [
                              'Manage vehicle types',
                              'About us',
                              // 'Tutorial',
                            ];
                            List<IconData> icons = [
                              Icons.motorcycle_sharp,
                              Icons.info,

                              // Icons.list_alt_rounded,
                              // Icons.help,
                            ];
                            List<Widget> widgetScreen = [
                              AddVehicleType(),
                              const AboutUsPage(),
                            ];
                            return ListTile(
                              visualDensity: VisualDensity.standard,
                              onTap: () {
                                MyRouter.navigateToNext(
                                    context, widgetScreen[index]);
                              },
                              leading: Icon(
                                icons[index],
                                color: softWhite,
                              ),
                              title: Text(
                                text[index],
                                style: TextStyle(color: softWhite),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          visualDensity: VisualDensity.standard,
                          onTap: () {
                            onLogout!();
                          },
                          leading: const Icon(
                            Icons.logout_rounded,
                            color: errorColor,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: errorColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
