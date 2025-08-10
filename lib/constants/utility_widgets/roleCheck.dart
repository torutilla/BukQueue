import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/commuter/commuter_screen/mainScreenWithMap.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/customCard.dart';
import 'package:flutter_try_thesis/driver/rider_main_screen/riderMainScreen.dart';
import 'package:flutter_try_thesis/routing/router.dart';

class RoleCheck {
  final Map<String, List<String>> userRoles;

  RoleCheck({
    required this.userRoles,
  });

  static const String driverRole = 'Driver';
  static const String commuterRole = 'Commuter';

  bool hasRole(String role) {
    return userRoles['Role']?.contains(role) ?? false;
  }

  void showRoleCheckDialog(BuildContext context) {
    if (hasRole(driverRole) && hasRole(commuterRole)) {
      _showDualRoleDialog(context);
    } else if (hasRole(driverRole)) {
      _navigateToDriverScreen(context);
    } else {
      _navigateToCommuterScreen(context);
    }
  }

  void _showDualRoleDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: ScreenUtil.parentHeight(context) * 0.3,
              width: ScreenUtil.parentWidth(context) * 0.8,
              child: Card(
                elevation: 16,
                shadowColor: Colors.black12,
                child: Column(
                  children: [
                    Text("You have multiple roles."),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDriverScreen(BuildContext context) {
    MyRouter.navigateToNextPermanent(context, RiderScreenMap());
  }

  void _navigateToCommuterScreen(BuildContext context) {
    MyRouter.navigateToNextPermanent(context, MainScreenWithMap());
  }
}
