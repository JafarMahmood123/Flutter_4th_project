// lib/ui/viewmodels/restaurant_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Restaurant.dart';
import '../../core/services/api_service.dart';

class RestaurantViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // The restaurant data, nullable to represent the "not loaded" state.
  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  // State management properties
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches a single restaurant from the API using its unique ID.
  ///
  /// Notifies listeners before and after the API call to update the UI
  /// with loading, error, or success states.
  Future<void> fetchRestaurantById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify UI to show loading indicator

    try {
      // Await the API call to get the raw restaurant data.
      final restaurantData = await _apiService.getRestaurantsById(id);
      // Parse the JSON data into a Restaurant model object.
      _restaurant = Restaurant.fromJson(restaurantData);
    } catch (e) {
      // If an error occurs, store the error message.
      _errorMessage = "Failed to load restaurant details: ${e.toString()}";
      print(_errorMessage);
    } finally {
      // Ensure loading is set to false and notify the UI to update.
      _isLoading = false;
      notifyListeners();
    }
  }
}