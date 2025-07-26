import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/Booking.dart';
import 'package:user_flutter_project/ui/viewmodels/payment_viewmodel.dart';

class PaymentScreen extends StatelessWidget {
  final Booking booking;

  const PaymentScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking for ${booking.restaurantName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              // This is a placeholder for the actual payment UI.
              // In a real app, you would integrate a payment gateway like Stripe or PayPal.
              const Center(
                child: Text(
                  'Payment Gateway Integration Here',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Spacer(),
              Consumer<PaymentViewModel>(
                builder: (context, viewModel, child) {
                  return viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await viewModel.processPayment(booking.id);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment successful!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(viewModel.errorMessage ?? 'Payment failed.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Pay Now'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
