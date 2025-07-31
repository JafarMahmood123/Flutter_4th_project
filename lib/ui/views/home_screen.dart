import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/ui/views/bookings_screen.dart';
import 'package:user_flutter_project/ui/views/hotel_reservations_screen.dart';
import 'package:user_flutter_project/ui/views/hotel_screen.dart';
import 'package:user_flutter_project/ui/views/restaurant_screen.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel()..fetchData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Explore'),
          centerTitle: true,
          elevation: 0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.book_online),
                title: Text('Restaurant Bookings'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.hotel),
                title: Text('Hotel Reservations'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotelReservationsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended Restaurants Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Recommended Restaurant For You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180, // Increased height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.recommendedRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant =
                        viewModel.recommendedRestaurants[index];
                        // WRAP a portion of the code with InkWell
                        return InkWell(
                          // In home_screen.dart, inside the ListView.builder for restaurants:

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Pass the ID to the RestaurantScreen
                                builder: (context) =>
                                    RestaurantScreen(restaurantId: restaurant.id),
                              ),
                            );
                          },
                          child: Container(
                            width: 160, // Increased width
                            margin: EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // WRAP Image with a Hero widget
                                Hero(
                                  tag:
                                  'restaurant-image-${restaurant.id}_recommended',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 120, // Increased image height
                                      width: double.infinity,
                                      child: Image.network(
                                        restaurant.pictureUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                            Container(
                                              height: 120,
                                              color: Colors.grey[200],
                                              child:
                                              Icon(Icons.restaurant, size: 40),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      restaurant.starRating.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  // Restaurants Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Available Restaurants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180, // Increased height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = viewModel.restaurants[index];
                        // WRAP a portion of the code with InkWell
                        return InkWell(
                          // In home_screen.dart, inside the ListView.builder for restaurants:

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Pass the ID to the RestaurantScreen
                                builder: (context) =>
                                    RestaurantScreen(restaurantId: restaurant.id),
                              ),
                            );
                          },
                          child: Container(
                            width: 160, // Increased width
                            margin: EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // WRAP Image with a Hero widget
                                Hero(
                                  tag: 'restaurant-image-${restaurant.id}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 120, // Increased image height
                                      width: double.infinity,
                                      child: Image.network(
                                        restaurant.pictureUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                            Container(
                                              height: 120,
                                              color: Colors.grey[200],
                                              child:
                                              Icon(Icons.restaurant, size: 40),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      restaurant.starRating.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),

                  // Recommended Hotels Section - COMING SOON
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Recommended Hotels For You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Top Hotels Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Available Hotels',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180, // Increased height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = viewModel.hotels[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HotelScreen(hotelId: hotel.id),
                              ),
                            );
                          },
                          child: Container(
                            width: 160, // Increased width
                            margin: EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: 'hotel-image-${hotel.id}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 120, // Increased image height
                                      width: double.infinity,
                                      child: Image.network(
                                        hotel.pictureUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                            Container(
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: Icon(Icons.hotel, size: 40),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  hotel.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      hotel.starRate.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}