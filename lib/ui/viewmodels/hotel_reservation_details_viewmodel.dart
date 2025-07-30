import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/Hotel.dart';
import 'package:user_flutter_project/data/models/HotelReservation.dart';
import 'package:user_flutter_project/data/models/Room.dart';

class HotelReservationDetailsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  HotelReservation? _reservation;
  HotelReservation? get reservation => _reservation;

  Hotel? _hotel;
  Hotel? get hotel => _hotel;

  Room? _room;
  Room? get room => _room;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReservationDetails(String reservationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reservationData = await _apiService.getReservationById(reservationId);
      _reservation = HotelReservation.fromJson(reservationData);

      if (_reservation != null) {
        final hotelData = await _apiService.getHotelById(_reservation!.hotelId);
        _hotel = Hotel.fromJson(hotelData);

        final roomsData = await _apiService.getRoomsByHotelId(_reservation!.hotelId);
        final roomData = roomsData.firstWhere((room) => room['id'] == _reservation!.roomId);
        _room = Room.fromJson(roomData);
      }
    } catch (e) {
      _errorMessage = "Failed to load reservation details: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
