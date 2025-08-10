import 'package:flutter/widgets.dart';
import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/tariffs.dart';
import 'package:flutter_try_thesis/constants/zones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/tagaytayCoordinates.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MainMap extends StatefulWidget {
  final bool enableOnTapPinning;

  const MainMap({
    super.key,
    this.enableOnTapPinning = false,
  });

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  GoogleMapController? mapController;
  Position? center;
  LatLng cameraPos = const LatLng(14.131033, 120.978850);
  Marker? _mapMarker;
  LatLng _initialPosition = const LatLng(0, 0);

  List<LatLng> bookingPolylineCoordinates = [];
  bool showCurrentLocation = true;
  LatLng? addressLatLng;
  List<LatLng> currentZonePoly = zone3;

  final Set<Polyline> _polylinesOfTagaytay = {
    // const Polyline(
    //   polylineId: PolylineId('Zambal'),
    //   points: zambalCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Neogan'),
    //   points: neoganCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Bagong Tubig'),
    //   points: bagongTubigCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Guinhawa North'),
    //   points: guinhawaNorthCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Guinhawa South'),
    //   points: guinhawaSouthCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Asisan'),
    //   points: asisanCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Mendez Crossing West'),
    //   points: mendezCrossingWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Mendez Crossing East'),
    //   points: mendezCrossingEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Sambong'),
    //   points: sambongCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Patutong Malaki North'),
    //   points: patutongMalakiNorthCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Patutong Malaki South'),
    //   points: patutongMalakiSouthCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Kaybagal North'),
    //   points: kaybagalNorthCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Kaybagal South'),
    //   points: kaybagalSouthCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Kaybagal Central'),
    //   points: kaybagalCentralCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Maharlika West'),
    //   points: maharlikaWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Maharlika East'),
    //   points: maharlikaEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Maitim 2nd West'),
    //   points: maitim2ndWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Maitim 2nd Central'),
    //   points: maitim2ndCentralCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Silang Crossing West'),
    //   points: silangCrossingWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Silang Crossing East'),
    //   points: silangCrossingEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Maitim 2nd East'),
    //   points: maitim2ndEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Mag-Asawang Ilat'),
    //   points: magAsawangIlatCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('San Jose'),
    //   points: sanJoseCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Tolentino West'),
    //   points: tolentinoWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Tolentino East'),
    //   points: tolentinoEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Francisco'),
    //   points: franciscoCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Sungay West'),
    //   points: sungayWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Sungay East'),
    //   points: sungayEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Iruhin West'),
    //   points: iruhinWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Iruhin Central'),
    //   points: iruhinCentralCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Iruhin East'),
    //   points: iruhinEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Dapdap West'),
    //   points: dapdapWestCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
    // const Polyline(
    //   polylineId: PolylineId('Dapdap East'),
    //   points: dapdapEastCoordinates,
    //   color: accentColor,
    //   width: 1,
    // ),
  };

  String addressOfPinnedLocation = '';
  String addressOfPinnedLocation2 = '';

  @override
  void initState() {
    super.initState();

    _initializeCamera();
    _mapMarker = Marker(
      markerId: const MarkerId('Map Pin'),
      position: cameraPos,
      draggable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
      return GoogleMap(
        // circles: tariffsList.expand((outerList) {
        //   return outerList.map((tariff) {
        //     return Circle(
        //       circleId: CircleId('${tariff.placeName}'),
        //       center: tariff.locationLatLng,
        //       radius: 20,
        //       fillColor: secondaryColor.withOpacity(0.2),
        //       strokeColor: secondaryColor,
        //       strokeWidth: 1,
        //     );
        //   });
        // }).toSet(),

        // circles: Set.from(List.generate(terminals.length, (index) {
        //   return Circle(
        //     circleId: CircleId('CircleID${[index]}'),
        //     center: terminals[index].coordinates,
        //     radius: 20,
        //     fillColor: secondaryColor.withOpacity(0.2),
        //     strokeColor: secondaryColor,
        //     strokeWidth: 1,
        //   );
        // })),
        polylines: {
          Polyline(
            visible: true,
            polylineId: const PolylineId("Route"),
            points: bookingProvider.bookingPolyline ?? [],
            width: 5,
            color: Colors.blue,
          ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone1"),
          //     points: zone1,
          //     width: 1,
          //     color: Colors.orange,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone1A"),
          //     points: zone1A,
          //     width: 1,
          //     color: Colors.green,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone1B"),
          //     points: zone1B,
          //     width: 1,
          //     color: Colors.lightBlue,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone1C"),
          //     points: zone1C,
          //     width: 1,
          //     color: Colors.grey,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone1D"),
          //     points: zone1D,
          //     width: 1,
          //     color: Colors.black,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone2"),
          //     points: zone2,
          //     width: 1,
          //     color: Colors.red,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone2A"),
          //     points: zone2A,
          //     width: 1,
          //     color: Colors.purple,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone3"),
          //     points: zone3,
          //     width: 1,
          //     color: Colors.red,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone3A"),
          //     points: zone3A,
          //     width: 1,
          //     color: Colors.red,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone4"),
          //     points: zone4,
          //     width: 1,
          //     color: Colors.blue.shade900,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Zone4A"),
          //     points: zone4A,
          //     width: 1,
          //     color: Colors.black,
          //   ),
          //   Polyline(
          //     visible: true,
          //     polylineId: const PolylineId("Restricted"),
          //     points: restricted,
          //     width: 1,
          //     color: Colors.red,
          //   ),
        },
        myLocationButtonEnabled: false,
        myLocationEnabled: showCurrentLocation,
        zoomControlsEnabled: false,
        onMapCreated: _onMapCreated,
        onCameraMove: (position) {
          setState(() {
            _mapMarker = _mapMarker?.copyWith(positionParam: position.target);
            final latlngPosition = _mapMarker?.position;
            _getPlaceMarkOfPosition(latlngPosition!);
            // _updateZonePolyline(latlngPosition);
          });
          if (widget.enableOnTapPinning) {
            bookingProvider.disableButton();
          }
        },
        onCameraIdle: () async {
          List<Placemark> pinnedLocationPlacemark =
              await placemarkFromCoordinates(
                  _initialPosition.latitude, _initialPosition.longitude);
          if (pinnedLocationPlacemark.isNotEmpty) {
            Placemark pinnedLocation = pinnedLocationPlacemark[0];
            if (isPlusCode(pinnedLocation.street!)) {
              addressOfPinnedLocation = _determineBarangayBasedOnLocation(
                  _initialPosition,
                  placemark: pinnedLocation);
            } else {
              addressOfPinnedLocation = '${pinnedLocation.street}';
            }
            addressOfPinnedLocation2 =
                '${pinnedLocation.locality}, ${pinnedLocation.administrativeArea}';

            bookingProvider.updatePinAddress(addressOfPinnedLocation,
                addressOfPinnedLocation2, _initialPosition);
          }
        },
        markers: widget.enableOnTapPinning
            ? {_mapMarker!}
            : bookingProvider.pinnedMarkers,
        initialCameraPosition: CameraPosition(
          target: cameraPos,
          zoom: 16.0,
        ),
        buildingsEnabled: true,
      );
    });
  }

  void _initializeCamera() async {
    center = (await getCurrentLocation());
    if (center != null) {
      setState(() {
        cameraPos = LatLng(center!.latitude, center!.longitude);
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.animateCamera(
      CameraUpdate.newLatLng(cameraPos),
    );
  }

  void _getPlaceMarkOfPosition(LatLng position) async {
    _initialPosition = position;
  }

  void focusCameraToLocation(LatLng position) {
    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14)));
  }

  void trackCurrentLocation() {
    //
  }

  void bookingCameraWithTracking(LatLng currentPosition) {
    mapController!.animateCamera(CameraUpdate.newLatLng(currentPosition));
  }

  void animateBookingCamera(LatLng newCameraPos) {
    mapController!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: newCameraPos)));
  }

  String _determineBarangayBasedOnLocation(LatLng currentLocation,
      {Placemark? placemark}) {
    // for tagaytay boundary
    // for (int i = 0; i < tagaytayBoundary.length; i++) {
    //   if (_isPointInPolygon(
    //       currentLocation,
    //       tagaytayBoundary
    //           .expand((tagaytayListofCoordinates) => tagaytayListofCoordinates)
    //           .toList())) {
    //     return 'Within Tagaytay';
    //   }
    // }
    for (var coord in barangayCoordinates.entries) {
      if (isPointInPolygon(currentLocation, coord.value)) {
        setState(() {
          _polylinesOfTagaytay.clear();
          _polylinesOfTagaytay.add(
            Polyline(
              polylineId: PolylineId(coord.key),
              points: coord.value,
              color: accentColor,
              width: 1,
            ),
          );
        });
        return '${placemark?.name}, ${coord.key}';
      }
    }
    return placemark!.street!;
  }

  void _updateZonePolyline(LatLng position) {
    for (var coord in zoneList.entries) {
      if (isPointInPolygon(position, coord.value)) {
        currentZonePoly = coord.value;
      } else {}
    }
  }
}
