import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = "https://45f14d8dee4a.ngrok-free.app"; // Your backend URL

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/User/LogIn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Assuming your backend returns the token directly in the body
      final token = response.body;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    }
    return null;
  }

  Future<List<dynamic>> getHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Hotels'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  Future<List<dynamic>> getRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<dynamic> getRestaurantsById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<List<dynamic>> getDishesByRestaurantId(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$restaurantId/Dishes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dishes for restaurant $restaurantId');
    }
  }

  Future<bool> createBooking({
    required String restaurantId,
    required String bookingDate,
    required String bookingStartTime,
    required String bookingEndTime,
    required Map<String, dynamic> dishes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$_baseUrl/Bookings'), // Assuming this endpoint for bookings
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'restaurantId': restaurantId,
        'bookingDate': bookingDate,
        'bookingStartTime': bookingStartTime,
        'bookingEndTime': bookingEndTime,
        'dishes': dishes,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true; // Booking successful
    } else {
      print('Booking failed with status: ${response.statusCode} and body: ${response.body}');
      throw Exception('Failed to create booking: ${response.body}');
    }
  }
}