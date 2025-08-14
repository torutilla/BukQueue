import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/models/cache_manager/sqlite_operations/bookingHistoryCacheModel.dart';
import 'package:flutter_try_thesis/models/cache_manager/sqlite_operations/sqliteOperations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestionsProvider extends ChangeNotifier {
  Map<String, dynamic> suggestedPlacesDetails = {};
  Map<String, dynamic> suggestedPlacesCache = {};
  String keyword = '';
  Map<String, bool> placesState = {};
  bool isSaved = false;
  final sql = SqliteOperations();

  void updatePlaceDetails(Map<String, dynamic> values) {
    suggestedPlacesDetails = values;
    notifyListeners();
  }

  void clearPlaceDetails() {
    suggestedPlacesDetails.clear();
  }

  void addToCache(Map<String, dynamic> value) {
    if (value.isNotEmpty) {
      value.forEach((key, value) {
        final placeCacheSql = PlaceCacheSql(
          pickupLocation: key,
          pickupLatLng: value,
        );
        final place = placeCacheSql.mapSavedPlace();
        print('Adding to cache: $place');
        sql.insertIntoTable('cachedPlacesResult', place);
      });
    }
    suggestedPlacesCache = value;
    notifyListeners();
  }

  ///Determine if entry exists in tbl:savedPlaces.
  Future<bool> placeExists(String value) async {
    final places = await sql.retrieveValuesInTable('savedPlaces',
        condition: 'Location LIKE ?', args: ['%$value%']);

    placesState[value] = places.isNotEmpty;

    notifyListeners();
    return places.isNotEmpty;
  }

  ///Save Place Details in Cache, tbl: savedPlaces.
  ///Requires [PlaceID], [LocationName], and [Coordinates]
  Future<void> savePlaceInCache(
      String placeId, String value, LatLng coordinates) async {
    bool placeExisting = await placeExists(value);

    if (!placeExisting) {
      final placeCacheSql = PlaceCacheSql(
        placeId: placeId,
        pickupLocation: value,
        pickupLatLng: coordinates,
      );
      final place = placeCacheSql.mapSavedPlace();

      sql.insertIntoTable('savedPlaces', place);
    }
    notifyListeners();
  }

  bool savePlaceState(String place) {
    return placesState[place] ?? false;
  }

  ///Remove Place Details Cache, tbl: savedPlaces
  void removePlaceInCache(String value) {
    sql.deleteValueInTable('savedPlaces', 'Location = ?', args: [value]);
    placesState.remove(value);

    notifyListeners();
  }

  Future<Map<String, Object?>> getSavedCachePlaces(String placeId) async {
    Map<String, Object?> places = {};
    final dbPlaces = await sql.retrieveValuesInTable('savedPlaces',
        condition: 'PlaceID LIKE ?', args: ['%$placeId%']);
    for (var entry in dbPlaces) {
      places.addAll({
        '${entry['PlaceID']}': LatLng(
            entry['Location_Lat'] as double, entry['Location_Lng'] as double)
      });
    }
    return places;
  }

  ///Retrive
  Future<Map<String, Object?>> getCachedPlaces(String placeID) async {
    Map<String, Object?> places = {};
    print(placeID);
    final dbPlaces = await sql.retrieveValuesInTable('cachedPlacesResult',
        condition: 'Location LIKE ?', args: ['%$placeID%']);
    for (var entry in dbPlaces) {
      places.addAll({
        '${entry['Location']}': LatLng(
            entry['Location_Lat'] as double, entry['Location_Lng'] as double)
      });
    }
    print(dbPlaces);
    print('Final places map: $places');
    return places;
  }

  // Future<Map<String, Object?>> getCachedPlaces(
  //     String placeID) async {
  //   Map<String, Object?> places = {};
  //   print(placeID);
  //   final dbPlaces = await sql.retrieveValuesInTable('cachedPlacesResult',
  //       condition: 'Location LIKE ?', args: ['%$placeID%']);
  //   for (var entry in dbPlaces) {
  //     places.addAll({
  //       '${entry['Location']}': LatLng(
  //           entry['Location_Lat'] as double, entry['Location_Lng'] as double)
  //     });
  //   }
  //   print(dbPlaces);
  //   print('Final places map: $places');
  //   return places;
  // }

  ///Add all autocomplete predictions to cache, DB: predictions
  Future<void> addPredictionIDtoCache(Map<String, dynamic> value) async {
    if (value.isNotEmpty) {
      for (var val in value.entries) {
        final place = {
          "PlaceName": val.key,
          "PlaceID": val.value,
        };
        print('Adding to cache: $place');
        try {
          await sql.insertIntoTable("predictions", place);
          // placesState[val.key] = true;
        } catch (e) {
          print('Error adding to cache: $e');
        }
      }
    }
  }

  Future<Map<String, Object?>> getCachedPrediction(String input) async {
    Map<String, Object?> places = {};
    try {
      final dbPlaces = await sql.retrieveValuesInTable('predictions',
          condition: 'PlaceName LIKE ?', args: ['%$input%']);

      if (dbPlaces.isNotEmpty) {
        for (var row in dbPlaces) {
          final placeId = row['PlaceID'] as String;
          final placeName = row['PlaceName'] as String;
          if (placeId.isNotEmpty && placeName.isNotEmpty) {
            places[placeName] = placeId;
          }
        }
      }
    } catch (e) {
      print('Error retrieving cached predictions: $e');
    }
    return places;
  }

  void removePredictionCache(String value) {
    sql.deleteValueInTable('predictions', 'PlaceID = ?', args: [value]);
    placesState.remove(value);

    notifyListeners();
  }

  ///Insert prediction to Saved Places Tab.
  Future<void> insertIntoSavedPlaces(Map<String, dynamic> value) async {
    if (value.isNotEmpty) {
      for (var val in value.entries) {
        final place = {
          "PlaceName": val.key,
          "PlaceID": val.value,
        };
        print('Adding to cache: $place');
        try {
          await sql.insertIntoTable("cachedPlacesResult", place);
          placesState[val.key] = true;
        } catch (e) {
          print('Error adding to cache: $e');
        }
      }
    }
  }

  void removeSavedPlaces(String value) {
    sql.deleteValueInTable('cachedPlacesResult', 'PlaceID = ?', args: [value]);
    placesState.remove(value);

    notifyListeners();
  }

  ///Load predictions in the Saved Places Tab.
  Future<Map<String, Object?>> loadSavedPlaces() async {
    Map<String, Object?> places = {};
    try {
      final dbPlaces = await sql.retrieveValuesInTable(
        'cachedPlacesResult',
      );

      if (dbPlaces.isNotEmpty) {
        for (var row in dbPlaces) {
          final placeId = row['PlaceID'] as String;
          final placeName = row['PlaceName'] as String;
          if (placeId.isNotEmpty && placeName.isNotEmpty) {
            places[placeName] = placeId;
            placesState[placeId] = true;
          }
        }
      }
    } catch (e) {
      print('Error retrieving cached predictions: $e');
    }
    return places;
  }
}
