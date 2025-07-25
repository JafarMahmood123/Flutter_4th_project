import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/Booking.dart';
import 'package:user_flutter_project/ui/viewmodels/bookings_viewmodel.dart';
import 'package:user_flutter_project/ui/views/booking_details_screen.dart'; // Import the new screen

class BookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Bookings'),
        ),
        body: Consumer<BookingsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            if (viewModel.bookings.isEmpty) {
              return const Center(child: Text('You have no bookings yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: viewModel.bookings.length,
              itemBuilder: (context, index) {
                final booking = viewModel.bookings[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: InkWell( // Wrap with InkWell for tap functionality
                    onTap: () async {
                      // Await the result from the details screen
                      final bool? bookingCancelled = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(booking: booking),
                        ),
                      );

                      // If a booking was cancelled, refresh the list
                      if (bookingCancelled == true) {
                        // Access the viewModel to refresh the data
                        Provider.of<BookingsViewModel>(context, listen: false).fetchUserBookings();
                      }
                    },
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          booking.restaurantPictureUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              Icon(Icons.restaurant, size: 50),
                        ),
                      ),
                      title: Text(
                        booking.restaurantName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Date: ${DateFormat.yMMMd().format(booking.receiveDateTime)}'),
                          Text('Time: ${DateFormat.jm().format(booking.receiveDateTime.toLocal())}'),
                          Text('Guests: ${booking.numberOfPeople}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}