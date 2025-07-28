import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Restaurant.dart';
import 'package:user_flutter_project/data/models/Dish.dart';
import '../../core/services/api_service.dart';
import '../../data/models/Cuisine.dart';
import '../../data/models/Feature.dart';
import '../../data/models/MealType.dart';
import '../../data/models/Tag.dart';
import '../../data/models/WorkTime.dart';

class RestaurantViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Private state
  Restaurant? _restaurant;
  List<Dish> _dishes = [];
  List<Cuisine> _cuisines = [];

  // Public properties for the View
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String get restaurantName => _restaurant?.name ?? 'Loading...';
  String get restaurantDescription => _restaurant?.description ?? '';
  String get pictureUrl => _restaurant?.pictureUrl ?? '';
  String get starRating => _restaurant?.starRating.toStringAsFixed(1) ?? '0.0';
  String get priceLevel => _restaurant?.priceLevel.name ?? '';
  String get priceRange => '\$${_restaurant?.minPrice.toStringAsFixed(0) ?? '0'} - \$${_restaurant?.maxPrice.toStringAsFixed(0) ?? '0'}';
  String get numberOfTables => _restaurant?.numberOfTables.toString() ?? '0';

  List<Cuisine> get cuisines => _restaurant?.cuisines ?? [];
  List<MealType> get mealTypes => _restaurant?.mealTypes ?? [];
  List<Feature> get features => _restaurant?.features ?? [];
  List<Tag> get tags => _restaurant?.tags ?? [];
  List<WorkTime> get workTimes => _restaurant?.workTimes ?? [];
  List<Dish> get dishes => _dishes;

  Restaurant? get restaurant => _restaurant;

  /// Fetches all data for the restaurant and updates the state.
  Future<void> fetchRestaurantById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final restaurantData = await _apiService.getRestaurantsById(id);
      _restaurant = Restaurant.fromJson(restaurantData);

      final dishesData = await _apiService.getDishesByRestaurantId(id);
      _dishes = dishesData.map((data) => Dish.fromJson(data)).toList();

      final cuisinesData = await _apiService.getCuisinesByRestaurant(id);
       _cuisines = cuisinesData.map((data) => Cuisine.fromJson(data)).toList();

    } catch (e) {
      _errorMessage = "Failed to load restaurant details: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}