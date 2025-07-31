import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Restaurant.dart';
import '../../core/services/api_service.dart';
import '../../data/models/Hotel.dart';

class HomeViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Hotel> hotels = [];
  List<Restaurant> restaurants = [];
  List<Restaurant> recommendedRestaurants = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final hotelData = await _apiService.getHotels();
      final restaurantData = await _apiService.getRestaurants();
      final recommendedRestaurantData =
      await _apiService.getRecommendedRestaurants();

      hotels = hotelData.map((json) => Hotel.fromJson(json)).toList();
      restaurants =
          restaurantData.map((json) => Restaurant.fromJson(json)).toList();
      recommendedRestaurants = recommendedRestaurantData
          .map((json) => Restaurant.fromJson(json))
          .toList();
    } catch (e) {
      // Handle errors appropriately in a real app
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}