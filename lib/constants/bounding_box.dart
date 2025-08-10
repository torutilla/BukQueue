import 'package:google_maps_flutter/google_maps_flutter.dart';

Map<String, double> getBoundingBox(List<LatLng> points) {
  if (points.isEmpty) {
    throw ArgumentError("List of points cannot be empty.");
  }

  double minLat = points.first.latitude;
  double maxLat = points.first.latitude;
  double minLng = points.first.longitude;
  double maxLng = points.first.longitude;

  for (var point in points) {
    if (point.latitude < minLat) minLat = point.latitude;
    if (point.latitude > maxLat) maxLat = point.latitude;
    if (point.longitude < minLng) minLng = point.longitude;
    if (point.longitude > maxLng) maxLng = point.longitude;
  }

  return {
    'south': minLat,
    'west': minLng,
    'north': maxLat,
    'east': maxLng,
  };
}
