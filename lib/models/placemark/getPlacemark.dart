import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/tagaytayCoordinates.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String> generateAddressFromPlacemark(LatLng position) async {
  List<Placemark> placemark =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  if (placemark.isNotEmpty) {
    Placemark specificPlace = placemark[0];

    return '${determineBarangayOfPlacemark(specificPlace, position)}, ${specificPlace.locality}, ${specificPlace.administrativeArea}';
  }
  return '';
}

String determineBarangayOfPlacemark(
    Placemark specificPlace, LatLng userLocation) {
  if (isPlusCode(specificPlace.street!)) {
    for (var coord in barangayCoordinates.entries) {
      if (isPointInPolygon(userLocation, coord.value)) {
        return '${specificPlace.street}, ${coord.key}';
      }
    }
  }
  return '${specificPlace.street}';
}
