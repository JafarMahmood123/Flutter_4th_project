import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/Dish.dart';
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
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${viewModel.errorMessage}'),
                ),
              );
            }

            return Stack(
              children: [
                // Background Image
                if (viewModel.pictureUrl.isNotEmpty)
                  Hero(
                    tag: 'restaurant-image-${restaurantId}',
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(viewModel.pictureUrl),
                          fit: BoxFit.cover,
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
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Padding for button
                          children: [
                            _buildHeader(context, viewModel),
                            const SizedBox(height: 24),
                            _buildInfoCards(context, viewModel),
                            const SizedBox(height: 16),
                            const Divider(),
                            _buildAboutSection(context, viewModel),
                            _buildCuisinesSection(context, viewModel),
                            _buildDishesSection(context, viewModel.dishes),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Booking Button
                if (viewModel.restaurant != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RestaurantBookingScreen(restaurant: viewModel.restaurant!),
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

  // --- UI Helper Widgets ---

  Widget _buildHeader(BuildContext context, RestaurantViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            viewModel.restaurantName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Text(
              viewModel.starRating,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context, RestaurantViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoCard(context, Icons.price_check, 'Price Level', viewModel.priceLevel),
        _buildInfoCard(context, Icons.attach_money, 'Price Range', viewModel.priceRange),
        _buildInfoCard(context, Icons.table_restaurant, 'Tables', viewModel.numberOfTables),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, RestaurantViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About ${viewModel.restaurantName}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          viewModel.restaurantDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCuisinesSection(BuildContext context, RestaurantViewModel viewModel) {
    if (viewModel.cuisines.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuisines',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: viewModel.cuisines.map((cuisine) => Chip(label: Text(cuisine.name))).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

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

  Widget _buildInfoSection(BuildContext context, String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDishesSection(BuildContext context, List<Dish> dishes) {
    if (dishes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...dishes.map((dish) => Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dish.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}