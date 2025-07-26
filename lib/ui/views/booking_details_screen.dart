import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/Booking.dart';
import 'package:user_flutter_project/ui/viewmodels/booking_details_viewmodel.dart';
import 'package:user_flutter_project/ui/views/payment_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingDetailsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Details'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Fixed Image Size ---
              // The Image widget is constrained to a height of 220 pixels
              // and will cover the full width of the screen.
              Image.network(
                booking.restaurantPictureUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  height: 220,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name and Confirmation
                    Text(
                      booking.restaurantName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your reservation is confirmed.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green[700]),
                    ),
                    const SizedBox(height: 24),

                    // Booking Info Card
                    Card(
                      elevation: 2,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildDetailRow(context, icon: Icons.calendar_today, title: 'Date', value: DateFormat('EEEE, MMMM d, yyyy').format(booking.receiveDateTime)),
                            const Divider(height: 24),
                            _buildDetailRow(context, icon: Icons.access_time, title: 'Time', value: DateFormat('h:mm a').format(booking.receiveDateTime.toLocal())),
                            const Divider(height: 24),
                            _buildDetailRow(context, icon: Icons.group, title: 'Guests', value: '${booking.numberOfPeople} people'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Booking ID
                    Text(
                      'Booking ID',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      booking.id,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Consumer<BookingDetailsViewModel>(
                      builder: (context, viewModel, child) {
                        return viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text('Cancel'),
                                onPressed: () => _showCancelConfirmation(context, viewModel),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade700,
                                  side: BorderSide(color: Colors.red.shade700),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.payment),
                                label: const Text('Pay'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentScreen(booking: booking),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for creating consistent detail rows
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
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Confirmation dialog for cancellation
  void _showCancelConfirmation(BuildContext context, BookingDetailsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final success = await viewModel.cancelBooking(booking.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking cancelled successfully!'), backgroundColor: Colors.green),
                  );
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.errorMessage ?? 'Failed to cancel booking.'), backgroundColor: Colors.red),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
