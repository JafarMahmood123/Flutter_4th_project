import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';

class BookingDetailsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> cancelBooking(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _apiService.cancelBooking(bookingId);
      return success;
    } catch (e) {
      _errorMessage = "Failed to cancel booking: ${e.toString()}";
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}