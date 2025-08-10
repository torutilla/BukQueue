 /*mainMap.dart*/
 
 
 // bookingProvider.addToPolylineList(polylinePoints);
      //   final length = directionsResponse.routes![0].legs![0].steps!.length;

      //   for (int i = 0; i <= length; i++) {
      //     print(length);
      //     bookingProvider.addToPolylineList([
      //       LatLng(
      //           directionsResponse
      //               .routes![0].legs![0].steps![i].startLocation!.lat!,
      //           directionsResponse
      //               .routes![0].legs![0].steps![i].startLocation!.lng!),
      //       LatLng(
      //           directionsResponse
      //               .routes![0].legs![0].steps![i].endLocation!.lat!,
      //           directionsResponse
      //               .routes![0].legs![0].steps![i].endLocation!.lng!),
      //     ], i);
      //   }
      // } else {
      //   print('null, Invalid response');
      // }

 // void _addMarkerOnTap(LatLng position) {
  //   LatLng snippetPosition = position;
  //   String snippet =
  //       'Lat: ${snippetPosition.latitude}, Lng: ${snippetPosition.longitude}';
  //   setState(() {
  //     _mapMarker.clear();
  //     _mapMarker.add(
  //       Marker(
  //         markerId: MarkerId('Map Pin'),
  //         position: position,
  //         infoWindow: InfoWindow(
  //           title: 'Pinned Location',
  //           snippet: snippet,
  //         ),
  //         draggable: true,
  //         onDragEnd: (value) {
  //           setState(() {
  //             snippetPosition = value;
  //           });
  //         },
  //       ),
  //     );
  //   });

  //   _getPlaceMarkOfPosition(snippetPosition);
  // }


   // onTap: (position) {
        //   if (widget.enableOnTapPinning) {
        //     //do something
        //     setState(() {
        //       _addMarkerOnTap(position);
        //     });
        //   }
        // },



         // markers: {
        //   Marker(
        //     markerId: MarkerId("PickUpLocation"),
        //     position: LatLng(widget.pickupLatLng.latitude,
        //         widget.pickupLatLng.longitude),
        //     visible: widget.pickupLatLng == LatLng(0, 0) ? false : true,
        //   ),
        // },


