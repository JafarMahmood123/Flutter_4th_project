import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodels/hotel_reservations_viewmodel.dart';

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
              return const Center(child: Text('You have no hotel reservations yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: viewModel.reservations.length,
              itemBuilder: (context, index) {
                final reservation = viewModel.reservations[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: ListTile(
                    title: Text(
                      'Reservation ID: ${reservation.hotelId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Room ID: ${reservation.roomId}'),
                        Text('Guests: ${reservation.numberOfPeople}'),
                        Text('From: ${DateFormat.yMMMd().format(reservation.reservationStartDate)}'),
                        Text('To: ${DateFormat.yMMMd().format(reservation.reservationEndDate)}'),
                      ],
                    ),
                    isThreeLine: true,
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
