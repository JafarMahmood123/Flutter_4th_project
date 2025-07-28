import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/Restaurant.dart';
import 'package:user_flutter_project/ui/viewmodels/restaurant_booking_viewmodel.dart';
import 'package:intl/intl.dart';

class RestaurantBookingScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantBookingScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
      RestaurantBookingViewModel()..fetchDishes(restaurant.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book at ${restaurant.name}'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Consumer<RestaurantBookingViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.dishes.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null && viewModel.dishes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${viewModel.errorMessage}'),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Dishes:',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.dishes.length,
                    itemBuilder: (context, index) {
                      final dish = viewModel.dishes[index];
                      final quantity = viewModel.dishQuantities[dish.id] ?? 0;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dish.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '€${dish.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.green[700]),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                    const Icon(Icons.remove_circle_outline),
                                    onPressed: () => viewModel
                                        .decrementDishQuantity(dish.id),
                                  ),
                                  Text(quantity.toString()),
                                  IconButton(
                                    icon:
                                    const Icon(Icons.add_circle_outline),
                                    onPressed: () => viewModel
                                        .incrementDishQuantity(dish.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Booking Details:',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      viewModel.selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${DateFormat('EEE, MMM d, yyyy').format(viewModel.selectedDate!)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: viewModel.selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        viewModel.setSelectedDate(pickedDate);
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      viewModel.selectedStartTime == null
                          ? 'Select Start Time'
                          : 'Start Time: ${viewModel.selectedStartTime!.format(context)}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime:
                        viewModel.selectedStartTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        viewModel.setSelectedStartTime(pickedTime);
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      viewModel.selectedEndTime == null
                          ? 'Select End Time'
                          : 'End Time: ${viewModel.selectedEndTime!.format(context)}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime:
                        viewModel.selectedEndTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        viewModel.setSelectedEndTime(pickedTime);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // -- WIDGET FOR NUMBER OF PEOPLE --
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of People:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: viewModel.numberOfPeople > 1
                                ? () => viewModel.setNumberOfPeople(
                                viewModel.numberOfPeople - 1)
                                : null,
                          ),
                          Text(
                            '${viewModel.numberOfPeople}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => viewModel.setNumberOfPeople(
                                viewModel.numberOfPeople + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Order:',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '€${viewModel.totalOrderPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                        final success =
                        await viewModel.submitBooking(restaurant.id);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Booking successful!')),
                          );
                          Navigator.of(context)
                              .pop(); // Go back to restaurant details
                        }
                        // Error message is now displayed above the button
                      },
                      icon: viewModel.isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                          viewModel.isLoading ? 'Submitting...' : 'Confirm Booking'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
