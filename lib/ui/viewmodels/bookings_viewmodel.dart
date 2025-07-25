import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/Booking.dart';

class BookingsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BookingsViewModel() {
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> bookingsData = await _apiService.getUserBookings();
      _bookings = bookingsData.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = "Failed to load bookings: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}