import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_try_thesis/commuter/booking_management/customOverlaySnackbar.dart';
import 'package:flutter_try_thesis/commuter/booking_management/suggestionsCacheHelper.dart';
import 'package:flutter_try_thesis/commuter/commuter_drawer/savedPlaces.dart';
import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/removeOverlay.dart';
import 'package:flutter_try_thesis/constants/tariffs.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/callSnackbar.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/numberInputField.dart';
import 'package:flutter_try_thesis/constants/zones.dart';
import 'package:flutter_try_thesis/models/placemark/getPlacemark.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/cache_manager/sqlite_operations/bookingHistoryCacheModel.dart';
import 'package:flutter_try_thesis/models/cache_manager/sqlite_operations/sqliteOperations.dart';
import 'package:flutter_try_thesis/constants/tagaytayCoordinates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/models/api_json_management/googleMapApis.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:flutter_try_thesis/models/providers/suggestionsProvider.dart';
import 'package:flutter_try_thesis/routing/router.dart';
import 'package:flutter_try_thesis/map/mainMap.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// import 'package:geolocator/geolocator.dart';

class BookingDetails extends StatefulWidget {
  final bool pickUp;

  const BookingDetails({
    super.key,
    this.pickUp = false,
  });

  @override
  BookingDetailsState createState() => BookingDetailsState();
  static String getAddressDisplayOnOverlay = '';
}

class BookingDetailsState extends State<BookingDetails> {
  late DirectionsClass direction;
  final FocusNode pickupFocusNode = FocusNode();
  final FocusNode dropoffFocusNode = FocusNode();
  final FocusNode dummyFocus = FocusNode();
  final FocusNode commentNode = FocusNode();
  String _pickUpAddress = '';
  String _dropOffAddress = '';
  LatLng? _pickUpLatLng;
  LatLng? _dropOffLatLng;
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _passengerCount = '1';
  bool isLoading = false;
  RenderBox? pickupRenderBox;
  RenderBox? dropoffRenderBox;
  Color pickupColor = Colors.transparent;
  Color dropoffColor = Colors.transparent;
  bool _enablePickUpFieldCloseButton = false;
  bool _enableDropOffFieldCloseButton = false;
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  final sql = SqliteOperations();
  Timer? _debounce;
  OverlayEntry? overlayEntryMap;
  OverlayEntry? overlayEntrySuggestions;
  final GlobalKey _pickUpKey = GlobalKey();
  final GlobalKey _dropOffKey = GlobalKey();
  GlobalKey<MainMapState> mapStateKey = GlobalKey<MainMapState>();
  Offset _pickUpTextFieldPos = Offset.zero;
  Offset _dropOffTextFieldPos = Offset.zero;
  SuggestionsProvider suggestions = SuggestionsProvider();
  PlaceSuggestions placeSuggestions = PlaceSuggestions();
  late Position userLocation;
  final ConvenienceFee = 20;
  // Set<Marker> _mapMarker = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();

    _pickupController.addListener(() {
      if (_pickupController.text.isNotEmpty) {
        _enablePickUpFieldCloseButton = true;
        closeCircularIndicator();
      } else {
        if (overlayEntrySuggestions != null) {
          removeOverlay(overlayEntrySuggestions);
        }
      }
    });
    _dropoffController.addListener(() {
      if (_dropoffController.text.isNotEmpty) {
        _enableDropOffFieldCloseButton = true;
        closeCircularIndicator();
      } else {
        if (overlayEntrySuggestions != null) {
          removeOverlay(overlayEntrySuggestions);
        }
      }
    });

    if (_pickupController.text.isNotEmpty &&
        _dropoffController.text.isNotEmpty) {
      _enableDropOffFieldCloseButton = true;
      _enablePickUpFieldCloseButton = true;
    }
    if (widget.pickUp) {
      pickupFocusNode.requestFocus();
    } else {
      dropoffFocusNode.requestFocus();
    }

    pickupFocusNode.addListener(() {
      setState(() {
        pickupColor =
            pickupFocusNode.hasFocus ? grayInputBox : Colors.transparent;
      });
    });
    dropoffFocusNode.addListener(() {
      setState(() {
        dropoffColor =
            dropoffFocusNode.hasFocus ? grayInputBox : Colors.transparent;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BookingProvider bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);

      _pickupController.text = bookingProvider.pickupLocation;
      _dropoffController.text = bookingProvider.dropoffLocation;
      _pickUpAddress = _pickupController.text;
      _dropOffAddress = _dropoffController.text;
      _pickUpLatLng = bookingProvider.pickupLatLng;
      _dropOffLatLng = bookingProvider.dropoffLatLng;
      pickupRenderBox =
          _pickUpKey.currentContext!.findRenderObject() as RenderBox;
      final pickUpPosition = pickupRenderBox!.localToGlobal(Offset.zero);

      dropoffRenderBox =
          _dropOffKey.currentContext!.findRenderObject() as RenderBox;
      final dropOffPosition = dropoffRenderBox!.localToGlobal(Offset.zero);
      setState(() {
        _pickUpTextFieldPos = pickUpPosition;
        _dropOffTextFieldPos = dropOffPosition;
      });
    });
  }

  @override
  void dispose() {
    pickupFocusNode.dispose();
    dropoffFocusNode.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          if (overlayEntryMap != null) {
            removeOverlay(overlayEntryMap);
          }
          if (overlayEntrySuggestions != null) {
            removeOverlay(overlayEntrySuggestions);
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: softWhite,
          appBar: AppBar(
            backgroundColor: primaryColor,
            leading: IconButton(
              onPressed: () {
                _pickUpAddress = _pickupController.text;
                _dropOffAddress = _dropoffController.text;
                pickupFocusNode.unfocus();
                dropoffFocusNode.unfocus();
                MyRouter.navigateToPrevious(context);
                if (overlayEntrySuggestions != null) {
                  removeOverlay(overlayEntrySuggestions);
                }
                if (overlayEntryMap != null) {
                  removeOverlay(overlayEntryMap);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            title: Text(
              'Set Locations',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Builder(builder: (context) {
              return Stack(
                children: [
                  bookingWidgets(),
                  if (isLoading)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: ScreenUtil.parentWidth(context),
                          height: ScreenUtil.parentHeight(context),
                          child: ModalBarrier(
                            color: Colors.black12,
                          ),
                        ),
                        CircularProgressIndicator(
                          color: accentColor,
                        ),
                      ],
                    )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget bookingWidgets() {
    return Column(
      children: [
        SizedBox(
          width: ScreenUtil.parentWidth(context),
          height: ScreenUtil.parentHeight(context) * 0.18,
          child: LayoutBuilder(builder: (context, constraints) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Consumer<BookingProvider>(
                  builder: (context, bookingProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0, left: 16),
                          child: Icon(
                            Icons.my_location,
                            size: 24,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.75,
                          height: 40,
                          child: Consumer<SuggestionsProvider>(
                              builder: (context, provider, child) {
                            return TextFormField(
                              key: _pickUpKey,
                              textInputAction: TextInputAction.search,
                              controller: _pickupController,
                              cursorColor: primaryColor,
                              focusNode: pickupFocusNode,
                              onChanged: (value) {
                                // _generateSuggestionsInMenu(value, provider);
                                _generateSuggestions(value, provider);
                              },
                              style: const TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                suffixIcon: _enablePickUpFieldCloseButton
                                    ? IconButton(
                                        onPressed: () {
                                          placeSuggestions.endSession();
                                          _pickupController.text = '';
                                          bookingProvider.resetBookingInfo(
                                              resetPickup: true);
                                          _enablePickUpFieldCloseButton = false;
                                          suggestions.clearPlaceDetails();
                                          removeOverlay(
                                              overlayEntrySuggestions);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 14,
                                        ))
                                    : null,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                fillColor: pickupColor,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide.none),
                                hintText: 'Search Pick-up Location',
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                      height: 2,
                      thickness: 1,
                      color: grayInputBox,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0, left: 16),
                          child: Icon(
                            Icons.location_on,
                            size: 24,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.75,
                          height: 40,
                          child: Consumer<SuggestionsProvider>(
                              builder: (context, provider, child) {
                            return TextFormField(
                              onTap: () {
                                dropoffFocusNode.requestFocus();
                              },
                              key: _dropOffKey,
                              controller: _dropoffController,
                              cursorColor: accentColor,
                              onChanged: (value) {
                                _generateSuggestions(value, provider);
                              },
                              focusNode: dropoffFocusNode,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                              decoration: InputDecoration(
                                suffixIcon: _enableDropOffFieldCloseButton
                                    ? IconButton(
                                        onPressed: () {
                                          placeSuggestions.endSession();
                                          _dropoffController.text = '';
                                          bookingProvider.resetBookingInfo(
                                              resetDropoff: true);
                                          _enableDropOffFieldCloseButton =
                                              false;
                                          removeOverlay(
                                              overlayEntrySuggestions);
                                          suggestions.clearPlaceDetails();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 14,
                                        ))
                                    : null,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                fillColor: dropoffColor,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide.none),
                                hintText: 'Search Drop-off Location',
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                );
              }),
            );
          }),
        ),
        // Container(
        //   color: grayInputBox,
        //   height: 60,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       SizedBox(
        //         width: 110,
        //         child: TextButtonUtility(
        //           elevation: 6,
        //           borderRadius: 24,
        //           backgroundColor: Colors.white,
        //           padding: const EdgeInsets.symmetric(horizontal: 4),
        //           onpressed: () async {
        //             try {
        //               var result = await sql.retrieveValuesInTable(
        //                   'bookingHistory',
        //                   condition: 'id = ?',
        //                   args: ["Recent"]);

        //               _retrieveCache(result);
        //             } catch (e) {
        //               print('error retrieving values $e');
        //             }
        //           },
        //           text: 'Recent',
        //           icon: const Icon(Icons.history),
        //         ),
        //       ),
        //       SizedBox(
        //         width: 110,
        //         child: TextButtonUtility(
        //           elevation: 6,
        //           borderRadius: 24,
        //           backgroundColor: Colors.white,
        //           padding: const EdgeInsets.symmetric(horizontal: 4),
        //           onpressed: () {},
        //           text: 'Home',
        //           icon: const Icon(Icons.home),
        //         ),
        //       ),
        //       SizedBox(
        //         width: 110,
        //         child: TextButtonUtility(
        //           elevation: 6,
        //           borderRadius: 24,
        //           backgroundColor: Colors.white,
        //           padding: const EdgeInsets.symmetric(horizontal: 4),
        //           onpressed: () {},
        //           text: 'Work',
        //           icon: const Icon(Icons.work),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Consumer<BookingProvider>(builder: (context, bookingProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 180,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4),
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await _requestLocationPermission();
                          _setAddressToTextBox(userLocation, bookingProvider);
                        },
                        leading: const Icon(
                          Icons.share_location_outlined,
                          color: primaryColor,
                        ),
                        title: Text(
                          'Use my current location',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 2,
                        thickness: 0.3,
                        color: grayColor,
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          _goToMapWithOverlay();
                        },
                        leading: const Icon(
                          Icons.map,
                          color: primaryColor,
                        ),
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          size: 20,
                          color: accentColor,
                        ),
                        title: Text('Pin location on map',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400)),
                      ),
                      const Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 2,
                        thickness: 0.3,
                        color: grayColor,
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          if (overlayEntrySuggestions != null) {
                            removeOverlay(overlayEntrySuggestions);
                          }
                          MyRouter.navigateToNext(
                              context,
                              SavedPlaces(
                                assignToBooking: true,
                                onTapCallback: (address, coordinates,
                                    {pickup = false}) {
                                  final provider = _getProvider(context);
                                  if (pickup) {
                                    provider.updatePickup(address, coordinates);
                                    _pickupController.text =
                                        provider.pickupLocation;
                                    _pickUpLatLng = coordinates;
                                  } else {
                                    provider.updateDropoff(
                                        address, coordinates);
                                    _dropoffController.text =
                                        provider.dropoffLocation;
                                    _dropOffLatLng = coordinates;
                                  }
                                  Navigator.pop(context);
                                  _updateFocus();
                                },
                              ));
                        },
                        leading: const Icon(
                          Icons.bookmark,
                          color: primaryColor,
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: accentColor,
                          size: 24,
                        ),
                        title: Text('Saved Places',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400)),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Number of passengers'),
                  NumberInputField(
                    width: 130,
                    height: 40,
                    backgroundColor: grayInputBox,
                    borderRadius: 8,
                    callBack: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'The maximum number of passengers allowed is 3.')));
                    },
                    valueCallback: (number) {
                      setState(() {
                        _passengerCount = number;
                      });
                      print(_passengerCount);
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 8),
                    child: Text('Note to Driver:'),
                  ),
                  SizedBox(
                    height: ScreenUtil.parentHeight(context) * 0.20,
                    width: ScreenUtil.parentWidth(context) * 0.80,
                    child: TextFormField(
                      controller: _noteController,
                      focusNode: commentNode,
                      cursorColor: primaryColor,
                      textAlign: TextAlign.left,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Write something...',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryButton(
                  backgroundColor: _pickupController.text.isNotEmpty &&
                          _dropoffController.text.isNotEmpty
                      ? primaryColor
                      : grayColor,
                  onPressed: () {
                    print(
                        '$_pickUpAddress $_dropOffAddress $_pickUpLatLng $_dropOffLatLng');
                    if (_pickUpAddress == _dropOffAddress ||
                        _pickUpLatLng == _dropOffLatLng) {
                      CallSnackbar().callSnackbar(context, 'Invalid booking');
                      return;
                    }
                    if (_pickupController.text.isNotEmpty &&
                        _dropoffController.text.isNotEmpty) {
                      showDialog(
                          barrierDismissible: false,
                          barrierColor: Colors.black12,
                          context: context,
                          builder: (context) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: secondaryColor,
                            ));
                          });

                      _updateBookingState();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please set your locations to proceed.'),
                        ),
                      );
                    }
                  },
                  buttonText: 'Confirm',
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _goToMapWithOverlay() {
    overlayEntryMap = OverlayEntry(
      builder: (BuildContext context) {
        return Consumer<BookingProvider>(
            builder: (context, bookingProvider, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              ModalBarrier(
                onDismiss: () {
                  removeOverlay(overlayEntryMap);
                },
                color: Colors.black45,
              ),
              Material(
                child: SizedBox(
                  width: ScreenUtil.parentWidth(context) * 0.8,
                  height: ScreenUtil.parentHeight(context) * 0.8,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Stack(
                        children: [
                          MainMap(
                            key: mapStateKey,
                            enableOnTapPinning: true,
                          ),
                          Container(
                            width: constraints.maxWidth * 0.9,
                            height: 80,
                            margin: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(
                                    color: pickupFocusNode.hasFocus
                                        ? primaryColor
                                        : accentColor,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextTitle(
                                        text: bookingProvider.pinAddress1,
                                        textColor: pickupFocusNode.hasFocus
                                            ? primaryColor
                                            : accentColor,
                                        textAlign: TextAlign.left,
                                        fontSize: 14,
                                      ),
                                      Text(
                                        bookingProvider.pinAddress2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(24),
                            alignment: Alignment.bottomCenter,
                            child: PrimaryButton(
                              backgroundColor:
                                  bookingProvider.isBookingButtonAvailable
                                      ? primaryColor
                                      : grayColor,
                              onPressed: bookingProvider
                                      .isBookingButtonAvailable
                                  ? () {
                                      _updateBookingAddress(bookingProvider);
                                    }
                                  : () {},
                              buttonText: 'Confirm',
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        });
      },
    );

    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntryMap!);
  }

  SuggestionsProvider _getSuggestionsProvider(BuildContext context) {
    return Provider.of<SuggestionsProvider>(context, listen: false);
  }

  // Future<void> _placeSuggestionsOverlay(
  //     Map<String, dynamic> suggestedPlaces) async {
  //   for (int i = 0; i < suggestedPlaces.length; i++) {
  //     String placeName = suggestedPlaces.keys.elementAt(i);
  //     bool exists =
  //         await _getSuggestionsProvider(context).placeExists(placeName);
  //     _getSuggestionsProvider(context).placesState[placeName] = exists;
  //   }
  //   overlayEntrySuggestions = OverlayEntry(builder: (context) {
  //     double topPosition = pickupFocusNode.hasFocus
  //         ? _pickUpTextFieldPos.dy + 42
  //         : _dropOffTextFieldPos.dy + 42;
  //     double leftPosition = pickupFocusNode.hasFocus
  //         ? _pickUpTextFieldPos.dx
  //         : _dropOffTextFieldPos.dx;
  //     return Positioned(
  //       top: topPosition,
  //       left: leftPosition,
  //       right: 20,
  //       child: Material(
  //         elevation: 2,
  //         child: ConstrainedBox(
  //           constraints: const BoxConstraints(
  //             maxHeight: 160,
  //             maxWidth: 50,
  //           ),
  //           child: Consumer<SuggestionsProvider>(
  //               builder: (context, suggestions, child) {
  //             return ListView.separated(
  //               separatorBuilder: (context, index) => const Divider(),
  //               shrinkWrap: true,
  //               itemCount: suggestedPlaces.length,
  //               itemBuilder: (context, index) {
  //                 String placeName = suggestedPlaces.keys.elementAt(index);
  //                 bool isSaved = suggestions.savePlaceState(placeName);
  //                 return Consumer<BookingProvider>(
  //                     builder: (context, provider, child) {
  //                   return ListTile(
  //                     leading: const Icon(
  //                       Icons.location_pin,
  //                       color: Colors.red,
  //                     ),
  //                     trailing: IconButton(
  //                         onPressed: () async {
  //                           if (isSaved) {
  //                             suggestions.removePlaceInCache(placeName);
  //                           } else {
  //                             suggestions.savePlaceInCache(
  //                                 placeName, suggestedPlaces[placeName]);
  //                           }
  //                         },
  //                         icon: Icon(
  //                           isSaved
  //                               ? Icons.bookmark
  //                               : Icons.bookmark_border_outlined,
  //                           color: accentColor,
  //                         )),
  //                     title: Text(placeName),
  //                     onTap: () {
  //                       provider.pinAddress1 = placeName;
  //                       provider.pinLatLng = suggestedPlaces[placeName];
  //                       _updateBookingAddress(provider);

  //                       removeOverlay(overlayEntrySuggestions);
  //                     },
  //                   );
  //                 });
  //               },
  //             );
  //           }),
  //         ),
  //       ),
  //     );
  //   });

  //   Overlay.of(context, debugRequiredFor: widget)
  //       .insert(overlayEntrySuggestions!);
  // }

  void closeCircularIndicator() {
    setState(() => isLoading = false);
  }

  Future<void> _requestLocationPermission() async {
    final getLocationPermission = await getCurrentLocation();
    if (getLocationPermission != null) {
      userLocation = getLocationPermission;
    } else {
      Fluttertoast.showToast(
          msg: 'Please grant the permission to location services.');
    }
  }

  void _setAddressToTextBox(
      Position userLocation, BookingProvider provider) async {
    String address = await generateAddressFromPlacemark(
        LatLng(userLocation.latitude, userLocation.longitude));
    if (dropoffFocusNode.hasFocus) {
      _dropoffController.text = address;
      _enableDropOffFieldCloseButton = _dropoffController.text.isNotEmpty;
      provider.updateDropoff(_dropoffController.text,
          LatLng(userLocation.latitude, userLocation.longitude));
      _dropOffAddress = _dropoffController.text;
      _dropOffLatLng = LatLng(userLocation.latitude, userLocation.longitude);
    } else if (pickupFocusNode.hasFocus) {
      _pickupController.text = address;
      _enablePickUpFieldCloseButton = _pickupController.text.isNotEmpty;
      provider.updatePickup(_pickupController.text,
          LatLng(userLocation.latitude, userLocation.longitude));
      _pickUpAddress = _pickupController.text;
      _pickUpLatLng = LatLng(userLocation.latitude, userLocation.longitude);
    } else {
      _pickupController.text = address;
      _enablePickUpFieldCloseButton = _pickupController.text.isNotEmpty;
      provider.updatePickup(_pickupController.text,
          LatLng(userLocation.latitude, userLocation.longitude));
      _pickUpAddress = _pickupController.text;
      _pickUpLatLng = LatLng(userLocation.latitude, userLocation.longitude);
    }
    _updateFocus();
  }

  void _updateBookingAddress(BookingProvider bookingProvider,
      {FocusNode? currentNode}) {
    if (currentNode == pickupFocusNode) {
      _updateFields(bookingProvider);
    } else if (currentNode == dropoffFocusNode) {
      _updateFields(bookingProvider, dropoff: true);
    }
    if (pickupFocusNode.hasFocus) {
      if (!isPointInPolygon(bookingProvider.pinLatLng!,
              tagaytayBoundary.expand((element) => element).toList()) ||
          isPointInPolygon(bookingProvider.pinLatLng!, restricted)) {
        OverlaySnackbar().showCustomSnackBar(context, 'Cannot set pin here.');

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text('Cannot set pin here.')));
        return;
      }

      _updateFields(bookingProvider);
      print(_pickUpLatLng);
    } else if (dropoffFocusNode.hasFocus) {
      _updateFields(bookingProvider, dropoff: true);

      print(_dropOffLatLng);
    }
    if (overlayEntryMap != null) {
      removeOverlay(overlayEntryMap);
    }
    _updateFocus();
  }

  void _updateFields(BookingProvider provider, {bool dropoff = false}) {
    if (!dropoff) {
      _pickupController.text =
          '${provider.pinAddress1}, ${provider.pinAddress2}';
      _enablePickUpFieldCloseButton = _pickupController.text.isNotEmpty;
      _pickUpAddress = _pickupController.text;
      provider.updatePickup(_pickupController.text, provider.pinLatLng!);
      _pickUpLatLng = provider.pinLatLng;
    } else {
      _dropoffController.text =
          '${provider.pinAddress1}, ${provider.pinAddress2}';
      _dropOffAddress = _dropoffController.text;
      _enableDropOffFieldCloseButton = _dropoffController.text.isNotEmpty;
      provider.updateDropoff(_dropoffController.text, provider.pinLatLng!);
      _dropOffLatLng = provider.pinLatLng;
    }
  }

  void _updateBookingState() async {
    BookingProvider bookingClass =
        Provider.of<BookingProvider>(context, listen: false);
    bookingClass.bookingPolyline = [];
    DirectionsClass direction = DirectionsClass(bookingClass);
    // String id =
    //     '${bookingClass.pickupLocation} ${bookingClass.dropoffLocation}';
    try {
      print("Pickup: $_pickUpLatLng, Dropoff: $_dropOffLatLng ");
      if (!bookingClass.pinnedMarkers
          .contains(Marker(markerId: MarkerId('Pickup Pin')))) {
        bookingClass.addToPinnedMarkers(
            bookingClass.generateMarker('Pickup Pin', _pickUpLatLng!));
      }
      if (!bookingClass.pinnedMarkers
          .contains(Marker(markerId: MarkerId('Dropoff Pin')))) {
        bookingClass.addToPinnedMarkers(
            bookingClass.generateMarker('Dropoff Pin', _dropOffLatLng!));
      }
    } catch (e) {
      print('error adding pins: $e');
    }
    // if (bookingClass.bookingPolyline.isEmpty) {
    //   if (bookingClass.BookingPolylineList.containsKey(id)) {
    //     List<LatLng> cachedPolyline =
    //         List<LatLng>.from(bookingClass.BookingPolylineList[id]!);
    //     bookingClass.addPolylineListToPolyline(cachedPolyline);
    // } else {

    print("Points: ${_pickUpLatLng!}, ${_dropOffLatLng!}");
    try {
      await direction.getDirectionofLocation(_pickUpLatLng!, _dropOffLatLng!);
      // bookingClass.BookingPolylineList.putIfAbsent(
      //     '${bookingClass.pickupLocation} ${bookingClass.dropoffLocation}',
      //     () => direction.bookingPolyline);
      // }
      // }

      Navigator.of(context).pop();
    } catch (e) {
      print('error adding polyline $e');
      Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      Navigator.of(context).pop();
    }
    _calculatePrice(bookingClass);

    if (bookingClass.bookingPolyline.isNotEmpty) {
      MyRouter.navigateToPrevious(context);
      bookingClass.passengerCount = _passengerCount;
      bookingClass.notes = _noteController.text;
      pickupFocusNode.unfocus();
      dropoffFocusNode.unfocus();
      if (overlayEntrySuggestions != null) {
        removeOverlay(overlayEntrySuggestions);
      }
    } else {
      print('Coordinates are empty');
    }
    _addBookingToCache();
  }

  ///Generate Predictions.
  ///Use cached predictions if present
  Future<void> _generateSuggestions(
      String input, SuggestionsProvider provider) async {
    // removeOverlay(overlayEntrySuggestions);

    // PlaceSearch placeSearch = PlaceSearch();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(seconds: 1, milliseconds: 500), () async {
      await suggestions.loadSavedPlaces();
      if (input.isNotEmpty) {
        var cachePlaces = await provider.getCachedPrediction(input);
        if (cachePlaces.isNotEmpty) {
          // _generateSuggestionsInMenu(cachePlaces);
          _updateSuggestionsList(cachePlaces);
          // _placeSuggestionsOverlay(provider.suggestedPlacesDetails);
        } else {
          // var googlePredictions = [
          //   AutocompletePrediction(placeId: '123', description: 'Picnic'),
          // ];
          var googlePredictions =
              await placeSuggestions.generateSuggestions(input);
          if (googlePredictions != null && googlePredictions.isNotEmpty) {
            final Map<String, dynamic> result = {};
            for (var prediction in googlePredictions) {
              result[prediction.description] = prediction.placeId;
            }
            await provider.addPredictionIDtoCache(result);
            _updateSuggestionsList(result);
          } else {
            print('Google Predictions is null and empty: Wrong condition');
          }
          // var returnValue =
          //     await placeSearch.generatePlaces(input, userLocation);
          // Map<String, dynamic> generatedPlaces = {};
          // returnValue.forEach(
          //   (key, value) {
          //     for (var barangay in barangayCoordinates.entries) {
          //       if (isPointInPolygon(
          //           value, barangayCoordinates[barangay.key]!)) {
          //         generatedPlaces[key] = value;
          //         break;
          //       }
          //     }
          //   },
          // );
          // print(generatedPlaces);
          // provider.updatePlaceDetails(generatedPlaces);
          // provider.addToCache(generatedPlaces);
          // _generateSuggestionsInMenu(generatedPlaces);
          // _placeSuggestionsOverlay(provider.suggestedPlacesDetails);
          // }
        }
      } else {
        placeSuggestions.endSession();
        placeSuggestions.startNewSession();
      }
    });
  }

  ///Show menu when suggestions are completed.
  void _updateSuggestionsList(Map<String, dynamic> places) {
    if (places.isEmpty) return;

    // final bookingProvider =
    //     Provider.of<BookingProvider>(context, listen: false);
    Offset position;
    RenderBox? renderBox;
    FocusNode currentNode;

    if (pickupFocusNode.hasFocus) {
      position = _pickUpTextFieldPos;
      renderBox = pickupRenderBox;
      currentNode = pickupFocusNode;
    } else {
      position = _dropOffTextFieldPos;
      renderBox = dropoffRenderBox;
      currentNode = dropoffFocusNode;
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + renderBox!.size.height,
        position.dx + renderBox.size.width,
        0,
      ),
      items: List.generate(places.length, (index) {
        final placeCoords = places.keys.elementAt(index);
        final placeId = places.values.elementAt(index);

        return PopupMenuItem(
          enabled: false,
          child: Consumer2<SuggestionsProvider, BookingProvider>(
            builder: (context, suggest, booking, _) {
              final isSaved = suggest.savePlaceState(placeId);

              return GestureDetector(
                onTap: () async {
                  print(placeId);
                  final info = await _suggestionSelected(placeId);
                  booking.pinAddress1 = placeCoords;
                  print('Coordinates: ${info[placeId]}');
                  booking.pinLatLng = info[placeId];
                  _updateBookingAddress(booking, currentNode: currentNode);
                  placeSuggestions.endSession();
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.location_pin, color: Colors.red),
                  title: Text(placeCoords),
                  trailing: IconButton(
                    onPressed: () async {
                      if (isSaved) {
                        suggest.removeSavedPlaces(placeId);
                      } else {
                        await suggest
                            .insertIntoSavedPlaces({placeCoords: placeId});
                      }
                    },
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                      color: accentColor,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  ///Get Place Details based on [placeID].
  ///Retrieve cache if present
  Future<Map<String, LatLng>> _suggestionSelected(String placeId) async {
    SuggestionsProvider provider =
        Provider.of<SuggestionsProvider>(context, listen: false);
    SuggestionsHelper helper = SuggestionsHelper();
    return await helper.getCacheOrResponse(provider, placeId);
  }

  void _updateFocus() {
    if (_dropoffController.text.isNotEmpty &&
        _pickupController.text.isNotEmpty) {
      commentNode.requestFocus();
    } else if (_pickupController.text.isNotEmpty) {
      dropoffFocusNode.requestFocus();
    } else {
      pickupFocusNode.requestFocus();
    }
  }

  void _addBookingToCache() {
    var bookingProvider = _getProvider(context);
    PlaceCacheSql sqlPlaceCache = PlaceCacheSql(
      bookingID: 'Recent',
      pickupLocation: bookingProvider.pickupLocation,
      dropoffLocation: bookingProvider.dropoffLocation,
      pickupLatLng: bookingProvider.pickupLatLng!,
      dropoffLatLng: bookingProvider.dropoffLatLng!,
      polyline: bookingProvider.polylineCode,
    );
    var result = sqlPlaceCache.mapBooking();
    try {
      sql.insertIntoTable('bookingHistory', result);
    } catch (e) {
      print('error inserting to table $e');
    }
    print(result);
  }

  void _retrieveCache(List<Map<String, Object?>> result) async {
    var recentBooking = result[0];
    _pickupController.text = recentBooking['Pickup_Location'] as String;
    _dropoffController.text = recentBooking['Dropoff_Location'] as String;
    _getProvider(context).updatePickup(
      recentBooking['Pickup_Location'] as String,
      LatLng(recentBooking['Pickup_Lat'] as double,
          recentBooking['Pickup_Lng'] as double),
    );
    _getProvider(context).updateDropoff(
      recentBooking['Dropoff_Location'] as String,
      LatLng(recentBooking['Dropoff_Lat'] as double,
          recentBooking['Dropoff_Lng'] as double),
    );
    String polylinePoints = result[0]['Polyline'] as String;
    List<LatLng> polyline = PolylinePoints()
        .decodePolyline(polylinePoints)
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
    _getProvider(context).addPolylineListToPolyline(polyline);

    _updateFocus();
  }

  BookingProvider _getProvider(BuildContext context) {
    return Provider.of<BookingProvider>(context, listen: false);
  }

  double getPriceBasedOnDistance(LatLng pickup, LatLng dropoff) {
    final distanceInMeters = haversineFormula(pickup, dropoff);
    final price = (distanceInMeters / 1000) * 2;

    return price;
  }

  void _calculatePrice(BookingProvider provider) {
    //determine terminal first
    provider.updateZone(getZoneofPlace(provider.pickupLatLng!));
    // final closest = findClosestTerminal(
    //     provider.pickupLatLng!,
    //     terminals
    //         .where((terminal) => terminal.zone == provider.zoneRef)
    //         .toList());
    final closestTerminalCoordinate = findClosestLatLng(
        provider.pickupLatLng!,
        terminals
            .where((e) => e.zone == provider.zoneRef)
            .map((terminal) => terminal.coordinates)
            .toList());
    final terminal = terminals
        .where((e) => e.coordinates == closestTerminalCoordinate)
        .toList();
    // print('Closest Terminal: ${terminal[0].zone}, ${terminal[0].terminalName}');
    provider.updateTerminal(terminal[0].terminalName);
    final filteredTariffsBasedOnTerminal = tariffsList
        .expand((innerList) => innerList.where((tariff) =>
            tariff.zone == provider.zoneRef &&
            tariff.terminalName == terminal[0].terminalName))
        .toList();
    // print(filteredTariffsBasedOnTerminal
    //     .map((terminal) => terminal.locationLatLng)
    //     .toList());
    final closestTariffLocationInCoordinate = findClosestLatLng(
        provider.dropoffLatLng!,
        filteredTariffsBasedOnTerminal
            .map((terminal) => terminal.locationLatLng)
            .toList());
    final closestLocationInTariff = filteredTariffsBasedOnTerminal
        .where((e) => e.locationLatLng == closestTariffLocationInCoordinate)
        .toList();
    // print(closestLocationInTariff[0].placeName);
    if (isLocationWithinBounds(provider.dropoffLatLng!,
        closestLocationInTariff[0].locationLatLng, 50)) {
      provider.updatePrice(closestLocationInTariff[0].price);
    } else {
      int baseFare = closestLocationInTariff[0].price;
      // print('Base Fare: $baseFare');
      final distancePrice = getPriceBasedOnDistance(
          provider.dropoffLatLng!, closestLocationInTariff[0].locationLatLng);
      baseFare += distancePrice.toInt();
      // baseFare += ConvenienceFee;
      provider.updatePrice(baseFare);
      // print('Final Price: ${provider.price}');
    }

    //get
    // convertFareListToTariff()
    // provider.updatePrice(1);
  }

  // Future<void> _generateSuggestionsInMenu(Map<String, dynamic> places) async {
  //   if (places.isEmpty) {
  //     return;
  //   }
  //   var bookingProvider;
  //   var position;
  //   var renderBox;
  //   FocusNode currentNode;
  //   if (pickupFocusNode.hasFocus) {
  //     position = _pickUpTextFieldPos;
  //     renderBox = pickupRenderBox;
  //     currentNode = pickupFocusNode;
  //   } else {
  //     position = _dropOffTextFieldPos;
  //     renderBox = dropoffRenderBox;
  //     currentNode = dropoffFocusNode;
  //   }
  //   // await _generateSuggestions(value, provider);
  //   // Map<String, dynamic> places = provider.suggestedPlacesDetails;
  //   // print("places:  $places");
  //   showMenu(
  //       context: context,
  //       position: RelativeRect.fromLTRB(
  //           position.dx,
  //           position.dy + renderBox.size.height,
  //           position.dx + renderBox.size.width,
  //           0),
  //       items: List.generate(places.length, (index) {
  //         String placeName = places.keys.elementAt(index);
  //         return PopupMenuItem(onTap: () async {
  //           //use place details when selected
  //           // final info = await _suggestionSelected(places.values.elementAt(index));
  //           bookingProvider.pinAddress1 = placeName;
  //           bookingProvider.pinLatLng = places[placeName];
  //           _updateBookingAddress(bookingProvider, currentNode: currentNode);
  //         }, child: Consumer2<SuggestionsProvider, BookingProvider>(
  //             builder: (context, suggest, booking, _) {
  //           bool isSaved = suggest.savePlaceState(placeName);
  //           bookingProvider = booking;
  //           return ListTile(
  //             enabled: false,
  //             leading: const Icon(
  //               Icons.location_pin,
  //               color: Colors.red,
  //             ),
  //             title: Text(placeName),
  //             trailing: IconButton(
  //                 onPressed: () async {
  //                   if (isSaved) {
  //                     suggest.removePlaceInCache(placeName);
  //                   } else {
  //                     suggest.savePlaceInCache(placeName, places[placeName]);
  //                   }
  //                 },
  //                 icon: Icon(
  //                   isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
  //                   color: accentColor,
  //                 )),
  //           );
  //         }));
  //       }));
  // }
}
