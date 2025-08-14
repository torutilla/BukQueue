import 'package:flutter_try_thesis/models/api_json_management/googleMapApis.dart';
import 'package:flutter_try_thesis/models/providers/suggestionsProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestionsHelper {
  PlaceSuggestions placeSuggestions = PlaceSuggestions();
  Future<Map<String, LatLng>> getCacheOrResponse(
      SuggestionsProvider provider, String placeId) async {
    final selectedPlaceCache = await provider.getSavedCachePlaces(placeId);

    if (selectedPlaceCache.isNotEmpty) {
      print(selectedPlaceCache);
      return selectedPlaceCache.map((k, v) => MapEntry(k, v as LatLng));
    }

    final details = await placeSuggestions.getPlaceDetails(placeId);

    if (details == null) {
      throw Exception('Failed to retrieve place details');
    }

    await provider.savePlaceInCache(
      placeId,
      details.formattedAddress,
      details.coordinates,
    );

    return {
      placeId: details.coordinates,
    };
  }
}
