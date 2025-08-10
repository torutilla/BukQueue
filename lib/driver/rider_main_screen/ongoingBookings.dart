import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';
import 'package:flutter_try_thesis/constants/screenSizes.dart';
import 'package:flutter_try_thesis/constants/titleText.dart';
import 'package:flutter_try_thesis/constants/utility_widgets/bookingDetailsContent.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:flutter_try_thesis/models/providers/historyProvider.dart';
import 'package:provider/provider.dart';

class OngoingBookings extends StatelessWidget {
  const OngoingBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          Consumer<BookingHistoryProvider>(builder: (context, provider, child) {
        return provider.ongoingBooking.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: BookingInformationContent(
                  pickupLocation: provider.ongoingBooking['Pickup Location'],
                  dropoffLocation: provider.ongoingBooking['Dropoff Location'],
                  bookingID: provider.ongoingBooking['Booking ID'],
                  date: provider.ongoingBooking['Date'],
                  time: provider.ongoingBooking['Time'],
                  price: provider.ongoingBooking['Price'],
                  notes: provider.ongoingBooking['Note'],
                ),
              )
            : Center(
                child: Text('No Active Bookings'),
              );
      }),
    );
  }
}
