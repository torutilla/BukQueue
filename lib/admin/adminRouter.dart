import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/admin/pages/adminSignUp.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/models/providers/adminProviders.dart';
import 'package:provider/provider.dart';

class AdminRouter extends StatelessWidget {
  const AdminRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AdminProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: const WidgetStatePropertyAll(softWhite),
              backgroundColor:
                  const WidgetStatePropertyAll(adminGradientColor1),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(accentColor),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: adminGradientColor2,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
            clipBehavior: Clip.antiAlias,
          ),
          tabBarTheme: TabBarTheme(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((state) {
              if (state.contains(WidgetState.pressed)) {
                return adminGradientColor1.withOpacity(0.5);
              }
              return null;
            }),
            labelColor: adminGradientColor2,
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: accentColor,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "Home",
        routes: {
          "Home": (context) => const AdminSignUp(),
        },
      ),
    );
  }

  static void navigateToNext(BuildContext context, Widget nextClass) {
    Navigator.push(context, pageRouteWithSlideAnimation(nextClass));
  }

  static void navigateToNextNoTransition(
      BuildContext context, Widget nextClass) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => nextClass));
  }

  static void navigateToNextPermanent(BuildContext context, Widget nextClass) {
    Navigator.pushReplacement(context, pageRouteWithSlideAnimation(nextClass));
  }

  static void navigateToPrevious(BuildContext context) {
    Navigator.pop(context);
  }
}

Route pageRouteWithSlideAnimation(Widget className) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => className,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.fastEaseInToSlowEaseOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
