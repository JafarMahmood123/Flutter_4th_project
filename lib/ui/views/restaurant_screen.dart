import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/ui/viewmodels/restaurant_viewmodel.dart';
import 'package:user_flutter_project/ui/views/restaurant_booking_screen.dart';

class RestaurantScreen extends StatelessWidget {
  final String restaurantId;

  const RestaurantScreen({Key? key, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantViewModel()..fetchRestaurantById(restaurantId),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Consumer<RestaurantViewModel>(
          builder: (context, viewModel, child) {
            // Loading State
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error State
            if (viewModel.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${viewModel.errorMessage}'),
                ),
              );
            }

            // No Data State
            if (viewModel.restaurant == null) {
              return const Center(child: Text('Restaurant details not found.'));
            }

            // --- Success State: Revamped UI Starts Here ---
            final restaurant = viewModel.restaurant!;
            return Stack(
              children: [
                // Background Hero Image
                Hero(
                  tag: 'restaurant-image-${restaurant.id}',
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(restaurant.pictureUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) => print("Image load error"),
                      ),
                    ),
                  ),
                ),

                // Back Button
                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),

                // Draggable Content Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  maxChildSize: 0.9,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          children: [
                            // Header: Name and Rating
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    restaurant.name,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 24),
                                    const SizedBox(width: 8),
                                    Text(
                                      restaurant.starRating.toStringAsFixed(1),
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Info Cards Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildInfoCard(context, Icons.price_check, 'Price Level', restaurant.priceLevel.name),
                                _buildInfoCard(context, Icons.attach_money, 'Price Range', '\$${restaurant.minPrice.toStringAsFixed(0)} - \$${restaurant.maxPrice.toStringAsFixed(0)}'),
                                _buildInfoCard(context, Icons.table_restaurant, 'Tables', restaurant.numberOfTables.toString()),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),

                            // About Section
                            Text(
                              'About ${restaurant.name}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              restaurant.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 120), // Extra space for CTA button
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Floating Action Button for Reservations
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RestaurantBookingScreen(restaurant: restaurant),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Book a Table'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Helper widget to create styled info cards for key details.
  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}