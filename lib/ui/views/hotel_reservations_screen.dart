import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/HotelReservation.dart';
import 'package:user_flutter_project/ui/viewmodels/hotel_reservations_viewmodel.dart';
import 'package:user_flutter_project/ui/views/hotel_reservation_details_screen.dart';

class HotelReservationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HotelReservationsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Hotel Reservations'),
        ),
        body: Consumer<HotelReservationsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            if (viewModel.reservations.isEmpty) {
              return const Center(
                  child: Text('You have no hotel reservations yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: viewModel.reservations.length,
              itemBuilder: (context, index) {
                final reservation = viewModel.reservations[index];
                final hotel = viewModel.hotels[index];
                return Card(
                  elevation: 3,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HotelReservationDetailsScreen(reservation: reservation),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        hotel.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Guests: ${reservation.numberOfPeople}'),
                          Text(
                              'From: ${DateFormat.yMMMd().format(reservation.reservationStartDate)}'),
                          Text(
                              'To: ${DateFormat.yMMMd().format(reservation.reservationEndDate)}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
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