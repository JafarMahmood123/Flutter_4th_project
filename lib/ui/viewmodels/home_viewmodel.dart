import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Restaurant.dart';
import '../../core/services/api_service.dart';
import '../../data/models/Hotel.dart';

class HomeViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Hotel> hotels = [];
  List<Restaurant> restaurants = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    final hotelData = await _apiService.getHotels();
    final restaurantData = await _apiService.getRestaurants();
    hotels = hotelData.map((json) => Hotel.fromJson(json)).toList();
    restaurants = restaurantData.map((json) => Restaurant.fromJson(json)).toList();
    notifyListeners();
  }
}
