import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class LoginViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final token = await _apiService.login(email, password);

    _isLoading = false;
    notifyListeners();

    return token != null;
  }
}