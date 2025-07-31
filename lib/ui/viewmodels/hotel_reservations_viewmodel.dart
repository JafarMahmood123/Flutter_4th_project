import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/Hotel.dart';
import 'package:user_flutter_project/data/models/HotelReservation.dart';

class HotelReservationsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<HotelReservation> _reservations = [];
  List<HotelReservation> get reservations => _reservations;

  List<Hotel> _hotels = [];
  List<Hotel> get hotels => _hotels;

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
      final List<dynamic> reservationsData =
      await _apiService.getReservationsByCustomerId();
      _reservations = reservationsData
          .map((json) => HotelReservation.fromJson(json))
          .toList();

      List<Hotel> hotelList = [];
      for (var reservation in _reservations) {
        final hotelData = await _apiService.getHotelById(reservation.hotelId);
        hotelList.add(Hotel.fromJson(hotelData));
      }
      _hotels = hotelList;
    } catch (e) {
      _errorMessage = "Failed to load reservations: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}