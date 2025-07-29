import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/Room.dart';

import '../../data/models/HotelReservation.dart';

class HotelReservationViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  int _numberOfPeople = 1;
  int get numberOfPeople => _numberOfPeople;

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  Room? _selectedRoom;
  Room? get selectedRoom => _selectedRoom;

  void setStartDate(DateTime date) {
    _startDate = date;
    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
      _endDate = null;
    }
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void setNumberOfPeople(int count) {
    if (count > 0) {
      _numberOfPeople = count;
      notifyListeners();
    }
  }

  void selectRoom(Room room) {
    _selectedRoom = room;
    notifyListeners();
  }

  Future<void> fetchRooms(String hotelId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final roomsData = await _apiService.getRoomsByHotelId(hotelId);
      _rooms = roomsData.map((data) => Room.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = "Failed to load rooms: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitBooking(String hotelId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_startDate == null || _endDate == null) {
      _errorMessage = "Please select a start and end date.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (_selectedRoom == null) {
      _errorMessage = "Please select a room.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final String? customerId = await _apiService.getCustomerId();
      if (customerId == null) {
        _errorMessage = "Could not identify customer. Please log in again.";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final reservation = HotelReservation(
        hotelId: hotelId,
        customerId: customerId,
        roomId: _selectedRoom!.id,
        numberOfPeople: _numberOfPeople,
        receivationStartDate: _startDate!,
        receivationEndDate: _endDate!,
      );

      final bool success = await _apiService.createHotelBooking(reservation);
      return success;
    } catch (e) {
      _errorMessage = "Failed to submit booking: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
