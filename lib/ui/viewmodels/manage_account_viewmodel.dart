import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';
import 'package:user_flutter_project/data/models/User.dart';
import 'package:user_flutter_project/ui/views/home_screen.dart';

class ManageAccountViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ManageAccountViewModel() {
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = await _apiService.getCustomerId();
      if (userId != null) {
        final userData = await _apiService.getUserById(userId);
        _user = User.fromJson(userData);
      } else {
        throw Exception("User not found or not logged in.");
      }
    } catch (e) {
      _errorMessage = "Failed to load user details: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _apiService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }
}