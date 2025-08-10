import 'dart:math';

import 'package:flutter_try_thesis/constants/zones.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

bool isLocationWithinBounds(
    LatLng currentLocation, LatLng targetLocation, double range) {
  final distance = haversineFormula(
    currentLocation,
    targetLocation,
  );
  print(distance);
  if (distance <= range) {
    return true;
  }

  return false;
}

LatLng findClosestLatLng(LatLng target, List<LatLng> latLngList) {
  LatLng? closestPoint;
  double minDistance = double.infinity;

  for (final point in latLngList) {
    final distance = haversineFormula(target, point);
    if (distance < minDistance) {
      minDistance = distance;
      closestPoint = point;
    }
  }

  return closestPoint!;
}

double calculateEstimatedTimeOfArrival(
    LatLng driverLocation, LatLng pickupLocation) {
  final distanceInMeters = haversineFormula(driverLocation, pickupLocation);
  final speed = 23 * (1000 / 60);
  print(speed);
  print(distanceInMeters);
  return distanceInMeters / speed;
}

double haversineFormula(
  LatLng currentPos,
  LatLng locationPos,
) {
  const double radius = 6371 * 1000;

  final double latitudeDifference =
      degreesToRadians(currentPos.latitude - locationPos.latitude);
  final double longitudeDifference =
      degreesToRadians(currentPos.longitude - locationPos.longitude);

  final a = pow(sin(latitudeDifference / 2), 2) +
      cos(degreesToRadians(currentPos.latitude)) *
          cos(degreesToRadians(locationPos.latitude)) *
          pow(sin(longitudeDifference / 2), 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radius * c;
}

double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  int n = polygon.length;
  bool inside = false;

  double x = point.latitude;
  double y = point.longitude;

  for (int i = 0; i < n; i++) {
    double xi = polygon[i].latitude;
    double yi = polygon[i].longitude;
    double xj = polygon[(i + 1) % n].latitude;
    double yj = polygon[(i + 1) % n].longitude;

    bool intersect =
        ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
    if (intersect) {
      inside = !inside;
    }
  }

  return inside;
}

bool isPlusCode(String address) {
  RegExp plusCodePattern = RegExp(r'^[A-Z0-9]{4,6}\+[A-Z0-9]{2,8}$');

  return plusCodePattern.hasMatch(address);
}

void callNumber(String number) async {
  final call = Uri.parse('tel:$number');
  if (await canLaunchUrl(call)) {
    launchUrl(call);
  } else {
    throw 'Could not launch';
  }
}

void messageNumber(String number) async {
  final sms = Uri.parse('sms:$number');
  if (await canLaunchUrl(sms)) {
    launchUrl(sms);
  } else {
    throw 'Could not launch';
  }
}

String getZoneofPlace(LatLng position) {
  for (var coord in zoneList.entries) {
    if (isPointInPolygon(position, coord.value)) {
      return coord.key;
    }
  }
  return 'Out of bounds';
}

Future<Position?> getCurrentLocation() async {
  var userLocationRequestPermission = await Permission.location.status;

  if (!userLocationRequestPermission.isGranted) {
    Permission.location.request();
  }

  userLocationRequestPermission = await Permission.location.status;
  if (userLocationRequestPermission.isGranted) {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
  // else if (userLocationRequestPermission.isDenied) {
  //   openAppSettings();
  //   if (userLocationRequestPermission.isGranted) {
  //     return await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //   }
  // }
  return null;
}
