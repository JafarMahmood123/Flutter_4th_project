import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/Amenity.dart';
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

  Room? _roomForDetails;
  Room? get roomForDetails => _roomForDetails;

  List<Amenity> _roomAmenities = [];
  List<Amenity> get roomAmenities => _roomAmenities;

  bool _isFetchingAmenities = false;
  bool get isFetchingAmenities => _isFetchingAmenities;

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
    _roomForDetails = null;
    notifyListeners();
  }

  void cancelRoomSelection() {
    _roomForDetails = null;
    _roomAmenities = [];
    notifyListeners();
  }

  Future<void> showRoomDetails(Room room) async {
    _roomForDetails = room;
    _isFetchingAmenities = true;
    notifyListeners();

    try {
      final amenitiesData = await _apiService.getAmenitiesByRoomId(room.id);
      _roomAmenities = amenitiesData.map((data) => Amenity.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = "Failed to load amenities: ${e.toString()}";
    } finally {
      _isFetchingAmenities = false;
      notifyListeners();
    }
  }

  Future<void> fetchRooms(String hotelId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final roomsData = await _apiService.getRoomsByHotelId(hotelId);
      _rooms = roomsData.map((data) => Room.fromJson(data)).toList();
      _rooms.sort((a, b) => a.roomNumber.compareTo(b.roomNumber));
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
        reservationStartDate: _startDate!,
        reservationEndDate: _endDate!,
      );

      final bool success = await _apiService.createHotelReservation(reservation);
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
