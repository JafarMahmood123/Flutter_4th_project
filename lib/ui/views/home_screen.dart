// lib/ui/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/ui/views/bookings_screen.dart'; // Import the new screen
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
        // Add the drawer property here
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Reservation App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.book_online),
                title: Text('My Bookings'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingsScreen()),
                  );
                },
              ),
              // You can add more items here like Profile, Settings, Logout etc.
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
                  // Restaurants Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Top Restaurants',
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
                                builder: (context) => RestaurantScreen(restaurantId: restaurant.id),
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
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: Icon(Icons.restaurant, size: 40),
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
                                    Icon(Icons.star, color: Colors.amber, size: 16),
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

                  // Hotels Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Recommended Hotels',
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
                        return Container(
                          width: 160, // Increased width
                          margin: EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 120, // Increased image height
                                  width: double.infinity,
                                  child: Image.network(
                                    hotel.pictureUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          height: 120,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.hotel, size: 40),
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
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    hotel.starRate.toStringAsFixed(1),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
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