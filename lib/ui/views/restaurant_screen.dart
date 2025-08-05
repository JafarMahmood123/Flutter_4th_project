// lib/ui/views/restaurant_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/Dish.dart';
import 'package:user_flutter_project/data/models/Review.dart';
import 'package:user_flutter_project/ui/viewmodels/home_viewmodel.dart';
import 'package:user_flutter_project/ui/viewmodels/restaurant_viewmodel.dart';
import 'package:user_flutter_project/ui/views/login_screen.dart';
import 'package:user_flutter_project/ui/views/restaurant_booking_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantScreen({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantViewModel()..fetchRestaurantById(widget.restaurantId),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Consumer<RestaurantViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null && viewModel.restaurant == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${viewModel.errorMessage}'),
                ),
              );
            }

            return Stack(
              children: [
                if (viewModel.pictureUrl.isNotEmpty)
                  Hero(
                    tag: 'restaurant-image-${widget.restaurantId}',
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: _buildHeader(context, viewModel),
                          ),
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'About'),
                              Tab(text: 'Reviews'),
                            ],
                            // This is the fix for the ProviderNotFoundException
                            onTap: (index) {
                              if (index == 1 && viewModel.reviews.isEmpty) {
                                viewModel.fetchReviews(widget.restaurantId);
                              }
                            },
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildAboutTab(context, viewModel, scrollController),
                                _buildReviewsTab(context, viewModel, scrollController),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                if (viewModel.restaurant != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final apiService = ApiService();
                        final isLoggedIn = await apiService.isUserLoggedIn();
                        if (isLoggedIn) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RestaurantBookingScreen(restaurant: viewModel.restaurant!),
                            ),
                          );
                        } else {
                          final loginResult = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );

                          if (loginResult == true && context.mounted) {
                            // Proceed to the booking screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RestaurantBookingScreen(restaurant: viewModel.restaurant!),
                              ),
                            );
                          }
                        }
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

  Widget _buildAboutTab(BuildContext context, RestaurantViewModel viewModel, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        _buildInfoCards(context, viewModel),
        const SizedBox(height: 16),
        const Divider(),
        _buildAboutSection(context, viewModel),
        _buildLocationSection(context, viewModel),
        _buildCuisinesSection(context, viewModel),
        _buildMealTypesSection(context, viewModel),
        _buildTagsSection(context, viewModel),
        _buildFeaturesSection(context, viewModel),
        _buildWorkTimesSection(context, viewModel),
        _buildDishesSection(context, viewModel.dishes),
      ],
    );
  }

  Widget _buildReviewsTab(BuildContext context, RestaurantViewModel viewModel, ScrollController scrollController) {
    if (viewModel.isReviewsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.reviews.isEmpty) {
      return const Center(child: Text('No reviews yet.'));
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: viewModel.reviews.length,
      itemBuilder: (context, index) {
        final review = viewModel.reviews[index];
        final averageRating = (review.customerStarRating + review.ServiceStarRating + review.customerFoodStarRating) / 3;

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Review", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(averageRating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(review.description),
                const Divider(height: 20),
                _buildRatingRow(context, 'Food', review.customerFoodStarRating),
                _buildRatingRow(context, 'Service', review.ServiceStarRating),
                _buildRatingRow(context, 'Ambiance', review.customerStarRating),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingRow(BuildContext context, String category, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(category, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
        ],
      ),
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

  Widget _buildLocationSection(BuildContext context, RestaurantViewModel viewModel) {
    if (viewModel.restaurant == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            leading: Icon(Icons.map_outlined, color: Theme.of(context).primaryColor),
            title: const Text('View on Map'),
            subtitle: Text('Lat: ${viewModel.restaurant?.latitude}, Lon: ${viewModel.restaurant?.longitude}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: viewModel.openMap,
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

  Widget _buildMealTypesSection(BuildContext context, RestaurantViewModel viewModel) {
    if (viewModel.mealTypes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meal Types',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: viewModel.mealTypes.map((mealType) => Chip(label: Text(mealType.name))).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context, RestaurantViewModel viewModel) {
    if (viewModel.tags.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: viewModel.tags.map((tag) => Chip(label: Text(tag.name))).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context, RestaurantViewModel viewModel) {
    if (viewModel.features.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: viewModel.features.map((feature) => Chip(label: Text(feature.name))).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWorkTimesSection(BuildContext context, RestaurantViewModel viewModel) {
    if (viewModel.workTimes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Hours',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: viewModel.workTimes.map((workTime) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(workTime.dayOfWeek, style: Theme.of(context).textTheme.bodyLarge),
                      Text('${workTime.openingTime} - ${workTime.closingTime}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dish.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      if (dish.description.isNotEmpty && dish.description != 'No Description') ...[
                        const SizedBox(height: 4.0),
                        Text(
                          dish.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '€${dish.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}