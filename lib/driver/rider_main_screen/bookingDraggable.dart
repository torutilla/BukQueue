import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/globalFunctions.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/alert.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/utilButton.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:provider/provider.dart';

class BookingDraggable extends StatelessWidget {
  final DraggableScrollableController bookingDraggableController;
  final String currentPhotoLink;
  final String currentPassenger;
  final String currentNumber;
  final String currentPickupLocation;
  final String currentDropoffLocation;
  final String currentDocId;
  final Function onCancelled;
  final Function onCompleted;
  const BookingDraggable(
      {super.key,
      required this.bookingDraggableController,
      required this.currentPhotoLink,
      required this.currentPassenger,
      required this.currentNumber,
      required this.currentPickupLocation,
      required this.currentDropoffLocation,
      required this.currentDocId,
      required this.onCancelled,
      required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0,
        minChildSize: 0,
        maxChildSize: 0.59,
        controller: bookingDraggableController,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: ScreenUtil.parentHeight(context) * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 4,
                      width: constraints.maxWidth * 0.3,
                      decoration: BoxDecoration(
                          color: grayInputBox,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          foregroundImage:
                              CachedNetworkImageProvider(currentPhotoLink),
                          backgroundColor: primaryColor,
                          radius: 24,
                          child: const Icon(Icons.person), //need to add picture
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: SizedBox(
                            width: constraints.maxWidth * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextTitle(
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  fontSize: 20,
                                  text: currentPassenger,
                                  textColor: blackColor,
                                ),
                                const Text('Commuter'),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(accentColor)),
                          onPressed: () {
                            messageNumber(currentNumber);
                          },
                          icon: const Icon(
                            Icons.message,
                            size: 18,
                          ),
                          color: Colors.white,
                        ),
                        IconButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(primaryColor)),
                          onPressed: () {
                            callNumber(currentNumber);
                          },
                          icon: const Icon(
                            Icons.call,
                            size: 18,
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: grayInputBox,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.5,
                      width: constraints.maxWidth * 0.9,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: primaryColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.my_location_rounded,
                                  size: 32,
                                  color: primaryColor,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup Location',
                                    style: TextStyle(color: grayColor),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.7,
                                    child: TextTitle(
                                      maxLines: 2,
                                      text: currentPickupLocation,
                                      textColor: primaryColor,
                                      fontSize: 18,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: grayInputBox,
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 32,
                                  color: accentColor,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dropoff Location',
                                    style: TextStyle(color: grayColor),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.7,
                                    child: TextTitle(
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      text: currentDropoffLocation,
                                      textColor: accentColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Consumer<BookingProvider>(
                              builder: (context, provider, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: constraints.maxWidth * 0.35,
                                  child: PrimaryButton(
                                    onPressedColor: warningColor.withBlue(4),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              actions: [
                                                SizedBox(
                                                  width: 90,
                                                  child: PrimaryButton(
                                                    onPressed: () {
                                                      cancelBooking(
                                                          context, provider);
                                                    },
                                                    buttonText: 'Yes',
                                                    backgroundColor:
                                                        grayInputBox,
                                                    textColor: Colors.black,
                                                    onPressedColor:
                                                        grayColor.withRed(50),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 90,
                                                  child: PrimaryButton(
                                                    onPressedColor:
                                                        errorColor.withRed(50),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: 'No',
                                                    backgroundColor: errorColor,
                                                  ),
                                                ),
                                              ],
                                              title: const TextTitle(
                                                text: 'Cancel Booking',
                                                textColor: errorColor,
                                              ),
                                              icon: const Icon(
                                                Icons.warning,
                                                size: 40,
                                              ),
                                              iconColor: errorColor,
                                              content: const Text(
                                                  'Are you sure you want to cancel this booking?'),
                                            );
                                          });
                                    },
                                    buttonText: 'Cancel',
                                    backgroundColor: errorColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: constraints.maxWidth * 0.55,
                                  child: PrimaryButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (c) {
                                            return CustomAlertDialog(
                                                iconSize: 50,
                                                alertIcon: Icons.check_circle,
                                                iconAndButtonColor:
                                                    primaryColor,
                                                title: 'Booking Complete',
                                                content:
                                                    'Trip successfully completed. Awaiting your next assignment!',
                                                buttonText: 'OK',
                                                onclick: () {
                                                  completeBooking(c, provider);
                                                });
                                          });
                                      // }
                                    },
                                    buttonText: 'Finish Booking',
                                    backgroundColor: primaryColor,
                                    // backgroundColor: completeButton
                                    //     ? primaryColor
                                    //     : primaryColor,

                                    ///edit color
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  void cancelBooking(BuildContext context, BookingProvider provider) {
    Navigator.of(context).pop();
    provider.updateBookingValues(
      currentDocId,
      {
        "Booking Status": 'Cancelled',
        "Elapsed": Timestamp.now(),
      },
      updateOngoingBookingStatus: true,
    );
    onCancelled();
  }

  void completeBooking(BuildContext context, BookingProvider provider) {
    Navigator.pop(context);
    provider.updateBookingValues(
      currentDocId,
      {
        "Booking Status": 'Completed',
        "Elapsed": Timestamp.now(),
      },
      updateOngoingBookingStatus: true,
    );
    onCompleted();
  }
}
