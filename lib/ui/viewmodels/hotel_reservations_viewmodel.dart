import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/HotelReservation.dart';

class HotelReservationsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<HotelReservation> _reservations = [];
  List<HotelReservation> get reservations => _reservations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HotelReservationsViewModel() {
    fetchUserReservations();
  }

  Future<void> fetchUserReservations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> reservationsData = await _apiService.getReservationsByCustomerId();
      _reservations = reservationsData.map((json) => HotelReservation.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = "Failed to load reservations: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
