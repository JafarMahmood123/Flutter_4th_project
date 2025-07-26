import 'package:flutter/material.dart';
import 'package:user_flutter_project/core/services/api_service.dart';

class PaymentViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> processPayment(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // In a real app, you would get a payment token from your payment gateway
      // and send it to your backend. For now, we'll just use a placeholder.
      const paymentToken = 'dummy_payment_token';
      final success = await _apiService.payForBooking(bookingId, paymentToken);
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
