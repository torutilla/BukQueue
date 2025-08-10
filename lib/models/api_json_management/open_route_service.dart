import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class OpenRouteService {
  Future<Map?> getDistance(LatLng pickup, LatLng dropoff) async {
    String apiKey = dotenv.env['OPEN_ROUTE_SERVICE_KEY'] ?? '';
    try {
      final response = await http.post(
        Uri.parse('https://api.openrouteservice.org/v2/matrix/driving-car'),
        headers: {
          "Authorization": apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          [pickup.latitude, pickup.longitude],
          [dropoff.latitude, dropoff.longitude],
        }),
      );

      final data = jsonDecode(response.body);
      final summary = data['routes'][0]['summary'];
      return {"Distance": summary['distance'], "Duration": summary['duration']};
    } catch (e) {
      print('Failed getting distance: $e');
      return null;
    }
  }
}
