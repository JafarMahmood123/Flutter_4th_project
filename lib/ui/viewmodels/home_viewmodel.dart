import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Restaurant.dart';
import '../../core/services/api_service.dart';
import '../../data/models/Hotel.dart';

class HomeViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Hotel> hotels = [];
  List<Restaurant> restaurants = [];
  List<Restaurant> recommendedRestaurants = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool isLoggedIn = false;

  Timer? _debounce;

  int _hotelPage = 1;
  bool _hasMoreHotels = true;
  bool _isFetchingMoreHotels = false;

  int _restaurantPage = 1;
  bool _hasMoreRestaurants = true;
  bool _isFetchingMoreRestaurants = false;

  int _recommendedRestaurantPage = 1;
  bool _hasMoreRecommendedRestaurants = true;
  bool _isFetchingMoreRecommendedRestaurants = false;

  HomeViewModel() {
    fetchData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await _apiService.isUserLoggedIn();
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    await checkLoginStatus();

    try {
      final hotelData = await _apiService.getHotels(page: 1);
      final restaurantData = await _apiService.getRestaurants(page: 1);

      if (isLoggedIn) {
        final recommendedRestaurantData =
        await _apiService.getRecommendedRestaurants(page: 1);
        recommendedRestaurants = recommendedRestaurantData
            .map((json) => Restaurant.fromJson(json))
            .toList();
      }

      hotels = hotelData.map((json) => Hotel.fromJson(json)).toList();
      restaurants =
          restaurantData.map((json) => Restaurant.fromJson(json)).toList();

    } catch (e) {
      // Handle errors appropriately in a real app
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _isSearching = true;
      notifyListeners();

      try {
        final restaurantData = await _apiService.getRestaurants(subName: query);
        restaurants = restaurantData.map((json) => Restaurant.fromJson(json)).toList();
      } catch (e) {
        print(e);
      } finally {
        _isSearching = false;
        notifyListeners();
      }
    });
  }

  Future<void> clearSearch() async {
    _isSearching = true;
    notifyListeners();

    try {
      final restaurantData = await _apiService.getRestaurants(page: 1);
      restaurants = restaurantData.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreHotels() async {
    if (_isFetchingMoreHotels || !_hasMoreHotels) return;

    _isFetchingMoreHotels = true;
    notifyListeners();

    try {
      final hotelData = await _apiService.getHotels(page: ++_hotelPage);
      if (hotelData.isEmpty) {
        _hasMoreHotels = false;
      } else {
        hotels.addAll(hotelData.map((json) => Hotel.fromJson(json)).toList());
      }
    } catch (e) {
      print(e);
    } finally {
      _isFetchingMoreHotels = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreRestaurants() async {
    if (_isFetchingMoreRestaurants || !_hasMoreRestaurants) return;

    _isFetchingMoreRestaurants = true;
    notifyListeners();

    try {
      final restaurantData =
      await _apiService.getRestaurants(page: ++_restaurantPage);
      if (restaurantData.isEmpty) {
        _hasMoreRestaurants = false;
      } else {
        restaurants.addAll(
            restaurantData.map((json) => Restaurant.fromJson(json)).toList());
      }
    } catch (e) {
      print(e);
    } finally {
      _isFetchingMoreRestaurants = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreRecommendedRestaurants() async {
    if (_isFetchingMoreRecommendedRestaurants ||
        !_hasMoreRecommendedRestaurants) return;

    _isFetchingMoreRecommendedRestaurants = true;
    notifyListeners();

    try {
      final recommendedRestaurantData = await _apiService
          .getRecommendedRestaurants(page: ++_recommendedRestaurantPage);
      if (recommendedRestaurantData.isEmpty) {
        _hasMoreRecommendedRestaurants = false;
      } else {
        recommendedRestaurants.addAll(recommendedRestaurantData
            .map((json) => Restaurant.fromJson(json))
            .toList());
      }
    } catch (e) {
      print(e);
    } finally {
      _isFetchingMoreRecommendedRestaurants = false;
      notifyListeners();
    }
  }
}