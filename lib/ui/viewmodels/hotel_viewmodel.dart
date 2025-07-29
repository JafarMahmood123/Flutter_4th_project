import 'package:flutter/material.dart';
import 'package:user_flutter_project/data/models/Amenity.dart';
import 'package:user_flutter_project/data/models/Hotel.dart';
import 'package:user_flutter_project/data/models/PropertyType.dart';
import '../../core/services/api_service.dart';

class HotelViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Hotel? _hotel;
  PropertyType? _propertyType;
  List<Amenity> _amenities = [];
  Hotel? get hotel => _hotel;
  PropertyType? get propertyType => _propertyType;
  List<Amenity> get amenities => _amenities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String get priceRange => '\$${_hotel?.minPrice.toStringAsFixed(0) ?? '0'} - \$${_hotel?.maxPrice.toStringAsFixed(0) ?? '0'}';

  Future<void> fetchHotelById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final hotelData = await _apiService.getHotelById(id);
      _hotel = Hotel.fromJson(hotelData);

      if (_hotel != null) {
        final propertyTypeData = await _apiService.getPropertyTypeByHotel(_hotel!.propertyId);
        _propertyType = PropertyType.fromJson(propertyTypeData);

        final amenitiesData = await _apiService.getAmenitiesByHotel(id);
        _amenities = amenitiesData.map((data) => Amenity.fromJson(data)).toList();
      }

    } catch (e) {
      _errorMessage = "Failed to load hotel details: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}