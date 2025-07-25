import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Dish.dart';
import '../../core/services/api_service.dart';

class RestaurantBookingViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Dish> _dishes = [];
  List<Dish> get dishes => _dishes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Booking details
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  TimeOfDay? _selectedStartTime;
  TimeOfDay? get selectedStartTime => _selectedStartTime;

  TimeOfDay? _selectedEndTime;
  TimeOfDay? get selectedEndTime => _selectedEndTime;

  final Map<String, int> _dishQuantities = {};
  Map<String, int> get dishQuantities => _dishQuantities;

  double get totalOrderPrice {
    double total = 0.0;
    _dishQuantities.forEach((dishId, quantity) {
      final dish = _dishes.firstWhere((d) => d.id == dishId);
      total += dish.price * quantity;
    });
    return total;
  }

  Future<void> fetchDishes(String restaurantId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> dishData = await _apiService.getDishesByRestaurantId(restaurantId);
      _dishes = dishData.map((json) => Dish.fromJson(json)).toList();
      // Initialize quantities to 0
      for (var dish in _dishes) {
        _dishQuantities[dish.id] = 0;
      }
    } catch (e) {
      _errorMessage = "Failed to load dishes: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void incrementDishQuantity(String dishId) {
    _dishQuantities.update(dishId, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void decrementDishQuantity(String dishId) {
    if (_dishQuantities.containsKey(dishId) && _dishQuantities[dishId]! > 0) {
      _dishQuantities.update(dishId, (value) => value - 1);
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedStartTime(TimeOfDay time) {
    _selectedStartTime = time;
    notifyListeners();
  }

  void setSelectedEndTime(TimeOfDay time) {
    _selectedEndTime = time;
    notifyListeners();
  }

  Future<bool> submitBooking(String restaurantId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_selectedDate == null || _selectedStartTime == null || _selectedEndTime == null) {
      _errorMessage = "Please select a date, start time, and end time for your booking.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final Map<String, int> dishesToBook = {};
    _dishQuantities.forEach((dishId, quantity) {
      if (quantity > 0) {
        dishesToBook[dishId.toString()] = quantity;
      }
    });

    try {
      // Construct the full DateTime objects
      final DateTime bookingStartDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );
      final DateTime bookingEndDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      );

      final bool success = await _apiService.createBooking(
        restaurantId: restaurantId,
        bookingDate: bookingStartDateTime.toIso8601String(),
        bookingStartTime: "${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}",
        bookingEndTime: "${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}",
        dishes: dishesToBook,
      );
      return success;
    } catch (e) {
      print("############################################################################");
      _errorMessage = "Failed to submit booking: ${e.toString()}";
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}