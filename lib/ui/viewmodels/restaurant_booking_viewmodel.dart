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

  int _numberOfPeople = 1;
  int get numberOfPeople => _numberOfPeople;

  final Map<String, int> _dishQuantities = {};
  Map<String, int> get dishQuantities => _dishQuantities;

  double get totalOrderPrice {
    double total = 0.0;
    _dishQuantities.forEach((dishId, quantity) {
      final dish = _dishes.firstWhere((d) => d.id == dishId, orElse: () => Dish(id: '', name: '', description: '', price: 0.0, imageUrl: '', restaurantId: ''));
      total += dish.price * quantity;
    });
    return total;
  }

  Future<void> fetchDishes(String restaurantId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> dishData =
      await _apiService.getDishesByRestaurantId(restaurantId);
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

  void setNumberOfPeople(int count) {
    if (count > 0) {
      _numberOfPeople = count;
      notifyListeners();
    }
  }

  Future<bool> submitBooking(String restaurantId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_selectedDate == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      _errorMessage =
      "Please select a date, start time, and end time for your booking.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Basic validation for end time being after start time
    final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
    final endMinutes = _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;
    if (endMinutes <= startMinutes) {
      _errorMessage = "End time must be after the start time.";
      _isLoading = false;
      notifyListeners();
      return false;
    }


    final Map<String, int> dishesToBook = {};
    _dishQuantities.forEach((dishId, quantity) {
      if (quantity > 0) {
        dishesToBook[dishId] = quantity;
      }
    });

    try {
      final String? customerId = await _apiService.getCustomerId();
      if (customerId == null) {
        _errorMessage = "Could not identify customer. Please log in again.";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Construct the receiveDateTime in UTC format
      final DateTime receiveDateTime = DateTime.utc(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );

      // Construct start and end DateTime to calculate duration
      final DateTime localStartDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );
      final DateTime localEndDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      );

      final Duration duration = localEndDateTime.difference(localStartDateTime);
      final String bookingDurationTime =
          "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:00";

      final bool success = await _apiService.createBooking(
        restaurantId: restaurantId,
        userId: customerId,
        receiveDateTime: receiveDateTime.toIso8601String(),
        bookingDurationTime: bookingDurationTime,
        numberOfPeople: _numberOfPeople,
        tableNumber: 0, // Hardcoded as table selection UI is not implemented
        dishesIdsWithQuantities: dishesToBook,
      );
      return success;
    } catch (e) {
      _errorMessage = "Failed to submit booking: ${e.toString()}";
      print(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
