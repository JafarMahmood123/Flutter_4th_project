import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';

import '../../data/models/City.dart';
import '../../data/models/Country.dart';

class SignUpViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Country> _countries = [];
  List<Country> get countries => _countries;

  List<City> _cities = [];
  List<City> get cities => _cities;

  Country? _selectedCountry;
  Country? get selectedCountry => _selectedCountry;

  City? _selectedCity;
  City? get selectedCity => _selectedCity;

  // Fetch countries when the view model is created
  SignUpViewModel() {
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      final countriesData = await _apiService.getCountries();
      _countries = countriesData.map((json) => Country.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onCountrySelected(Country? country) {
    _selectedCountry = country;
    _selectedCity = null; // Reset city when country changes
    _cities = [];
    notifyListeners();
    if (country != null) {
      fetchCitiesByCountry(country.id);
    }
  }

  void onCitySelected(City? city) {
    _selectedCity = city;
    notifyListeners();
  }

  Future<void> fetchCitiesByCountry(String countryId) async {
    try {
      final citiesData = await _apiService.getCitiesByCountry(countryId);
      _cities = citiesData.map((json) => City.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String birthDate,
    required String locationId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _apiService.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        birthDate: birthDate,
        locationId: locationId,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}