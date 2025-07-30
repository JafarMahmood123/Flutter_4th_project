import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/HotelReservation.dart';
import 'package:user_flutter_project/ui/viewmodels/hotel_reservation_details_viewmodel.dart';

class HotelReservationDetailsScreen extends StatelessWidget {
  final HotelReservation reservation;

  const HotelReservationDetailsScreen({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HotelReservationDetailsViewModel()..fetchReservationDetails(reservation.id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reservation Details'),
        ),
        body: Consumer<HotelReservationDetailsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            if (viewModel.reservation == null) {
              return const Center(child: Text('Reservation details not found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reservation at ${viewModel.hotel?.name ?? 'Hotel'}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context,
                            icon: Icons.calendar_today,
                            title: 'Start Date',
                            value: DateFormat('EEEE, MMMM d, yyyy').format(viewModel.reservation!.reservationStartDate),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.calendar_today,
                            title: 'End Date',
                            value: DateFormat('EEEE, MMMM d, yyyy').format(viewModel.reservation!.reservationEndDate),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.group,
                            title: 'Guests',
                            value: '${viewModel.reservation!.numberOfPeople} people',
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.king_bed,
                            title: 'Room Number',
                            value: viewModel.room?.roomNumber.toString() ?? 'N/A',
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.attach_money,
                            title: 'Price per night',
                            value: '\$${viewModel.room?.price.toStringAsFixed(2) ?? 'N/A'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Reservation ID',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    viewModel.reservation!.id,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
