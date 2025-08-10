import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_try_thesis/admin/pages/adminBookingHistory.dart';
import 'package:flutter_try_thesis/admin/pages/adminCommuterInfo.dart';
import 'package:flutter_try_thesis/admin/pages/adminDriverFeedbacks.dart';
import 'package:flutter_try_thesis/admin/pages/adminDriverPage.dart';
import 'package:flutter_try_thesis/admin/pages/adminSignUp.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/background.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilDrawer.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/routing/router.dart';

import 'adminDashboard.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _DashboardState();
}

class _DashboardState extends State<AdminMainScreen>
    with TickerProviderStateMixin {
  late TabController _bottomTabController;
  late List<ScrollController> _scrollControllers;
  late ValueNotifier<int> _indexListener;
  late ValueNotifier<Offset> _offsetListener;
  Offset _offset = Offset.zero;
  final List<String> _appbarTitles = [
    'Driver Feedbacks',
    'Driver Account Info',
    'Dashboard',
    'Commuter Account Info',
    'Booking History'
  ];

  CachedNetworkImageProvider? photo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializePhoto();
    _bottomTabController =
        TabController(length: 5, vsync: this, initialIndex: 2);

    _indexListener = ValueNotifier(_bottomTabController.index);

    _offsetListener = ValueNotifier(_offset);
    // _initializeScrollControllers();
  }

  // void _initializeScrollControllers() {
  //   _scrollControllers = List.generate(
  //     5,
  //     (index) => ScrollController()..addListener(() => _handleScroll(index)),
  //   );
  // }

  // void _handleScroll(int index) {
  //   final controller = _scrollControllers[index];
  //   if (controller.position.atEdge) {
  //     if (controller.position.pixels == controller.position.minScrollExtent) {
  //       _offsetListener.value = Offset.zero;
  //     } else {
  //       _offsetListener.value = const Offset(0, 10);
  //     }
  //   }
  // }

  // void _handleScrollerAttach(ScrollPosition position) {
  //   _scrollController.position.addListener(() {
  //     if (position.atEdge) {
  //       _offsetListener.value = Offset(0, 10);
  //     }
  //     if (position.pixels == position.minScrollExtent) {
  //       _offsetListener.value = Offset.zero;
  //     }
  //   });
  // }

  @override
  void dispose() {
    // Dispose all ScrollControllers
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    _bottomTabController.dispose();
    _indexListener.dispose();
    _offsetListener.dispose();
    super.dispose();
  }

  void _handleScrollerDetach(ScrollPosition position) {}

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primaryColor: accentColor,
          tabBarTheme: TabBarTheme(
            unselectedLabelColor: adminGradientColor1.withOpacity(0.8),
            indicatorColor: accentColor,
            labelColor: accentColor,
          ),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent)),
      child: Scaffold(
        drawer: AdminDrawer(
          photo: photo,
          onLogout: () {
            MyRouter.navigateAndRemoveAllStackBehind(context, AdminSignUp());
          },
        ),
        appBar: AppBar(
          backgroundColor: adminGradientColor4,
          leading: Builder(builder: (context) {
            return IconButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          }),
          title: ValueListenableBuilder<int>(
              valueListenable: _indexListener,
              builder: (context, snapshot, child) {
                return Text(
                  _appbarTitles[snapshot],
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    fontSize: ScreenUtil.parentWidth(context) < 320 ? 16 : 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
        ),
        bottomSheet: ValueListenableBuilder(
            valueListenable: _offsetListener,
            builder: (context, offset, child) {
              return AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                offset: offset,
                child: ValueListenableBuilder(
                    valueListenable: _indexListener,
                    builder: (context, snapshot, child) {
                      return TabBar(
                          dividerColor: adminGradientColor2,
                          dividerHeight: 80,
                          onTap: (value) {
                            _indexListener.value = value;
                          },
                          controller: _bottomTabController,
                          tabs: [
                            Tab(
                              height: 60,
                              icon: SvgPicture.asset(
                                height: 32,
                                'assets/images/Icons/survey-record-research-catalog-svgrepo-com.svg',
                                colorFilter: ColorFilter.mode(
                                    snapshot == 0
                                        ? accentColor
                                        : adminGradientColor1.withOpacity(0.8),
                                    BlendMode.srcIn),
                              ),
                            ),
                            Tab(
                              height: 60,
                              icon: SvgPicture.asset(
                                height: 32,
                                'assets/images/Bukyo.svg',
                                colorFilter: ColorFilter.mode(
                                    snapshot == 1
                                        ? accentColor
                                        : adminGradientColor1.withOpacity(0.8),
                                    BlendMode.srcIn),
                              ),
                            ),
                            const Tab(
                              height: 60,
                              icon: Icon(
                                Icons.dashboard,
                                size: 28,
                              ),
                            ),
                            Tab(
                              height: 60,
                              icon: SvgPicture.asset(
                                'assets/images/Icons/business-card-of-a-man-with-contact-info-svgrepo-com.svg',
                                colorFilter: ColorFilter.mode(
                                    snapshot == 3
                                        ? accentColor
                                        : adminGradientColor1.withOpacity(0.8),
                                    BlendMode.srcIn),
                              ),
                            ),
                            const Tab(
                              height: 60,
                              icon: Icon(
                                Icons.history,
                                size: 28,
                              ),
                            ),
                          ]);
                    }),
              );
            }),
        body: BackgroundWithColor(
          color1: adminGradientColor2.withOpacity(0.9),
          color2: adminGradientColor2,
          child: TabBarView(
            // physics: const NeverScrollableScrollPhysics(),
            controller: _bottomTabController,
            children: [
              AdminDriverFeedbacks(
                  // scrollController: _scrollControllers[0],
                  ),
              AdminDriverInfo(
                  // scrollController: _scrollControllers[1],
                  ),
              DashboardTab(
                tabController: _bottomTabController,
                context: context,
                // scrollController: _scrollControllers[2],
              ),
              AdminCommuterInfo(
                  // scrollController: _scrollControllers[3],
                  ),
              AdminBookingHistory(
                  // scrollController: _scrollControllers[4],
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> initializePhoto() async {
  //   final uid = await UserSharedPreferences().readCacheString("Admin UID");
  //   if (uid != null) {
  //     final path = await GetPhotoLinkOfUser().getPhotoLink(uid);
  //     if (path.isNotEmpty) {
  //       photo = CachedNetworkImageProvider(path);
  //     }
  //   }
  // }
}
