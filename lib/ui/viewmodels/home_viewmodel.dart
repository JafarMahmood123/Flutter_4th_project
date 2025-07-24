import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/Hotel.dart';

class HomeViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Hotel> hotels = [];
  // Add lists for restaurants and events

  Future<void> fetchData() async {
    final hotelData = await _apiService.getHotels();
    hotels = hotelData.map((json) => Hotel.fromJson(json)).toList();
    // Fetch restaurants and events here
    notifyListeners();
  }
}