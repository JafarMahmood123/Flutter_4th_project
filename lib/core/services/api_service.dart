// lib/core/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/HotelReservation.dart';

class ApiService {
  final String _baseUrl = "https://a94d9f611d39.ngrok-free.app";


  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/User/LogIn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
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

  Future<dynamic> getHotelById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Hotels/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load hotel');
    }
  }

  Future<List<dynamic>> getRoomsByHotelId(String hotelId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/Hotels/$hotelId/rooms'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load rooms for hotel with Id: $hotelId');
    }
  }

  Future<List<dynamic>> getAmenitiesByRoomId(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$_baseUrl/Rooms/$roomId/amenities'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load amenities for room with Id: $roomId');
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

  /// Decodes the JWT to extract the customer ID.
  Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('DEBUG: Retrieved token from storage: $token');

    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print('DEBUG: Decoded token payload: $decodedToken');

        final userId = decodedToken['sub'];

        print('DEBUG: Extracted userId with current key: $userId');
        return userId;

      } catch (e) {
        print("ERROR: Failed to decode token: $e");
        return null;
      }
    }
    print('ERROR: Token was not found in SharedPreferences.');
    return null;
  }


  /// Creates a booking with the new JSON structure.
  Future<bool> createBooking({
    required String restaurantId,
    required String? userId,
    required String receiveDateTime,
    required String bookingDurationTime,
    required int numberOfPeople,
    required int tableNumber,
    required Map<String, int> dishesIdsWithQuantities,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (userId == null) {
      throw Exception('Customer ID not found. User might not be logged in.');
    }

    final body = jsonEncode({
      'receiveDateTime': receiveDateTime,
      'bookingDurationTime': bookingDurationTime,
      'numberOfPeople': numberOfPeople,
      'tableNumber': tableNumber,
      'restaurantId': restaurantId,
      'userId': userId,
      'addBookingDishRequest': {
        'dishesIdsWithQuantities': dishesIdsWithQuantities,
      },
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/RestaurantBooking'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true; // Booking successful
    } else {
      print(
          'Booking failed with status: ${response.statusCode} and body: ${response.body}');
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  /// Fetches all restaurant bookings for the current user.
  Future<List<dynamic>> getUserBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = await getCustomerId();

    if (token == null || userId == null) {
      throw Exception('User is not logged in.');
    }

    final response = await http.get(
      // Your backend has the endpoint GetRestaurantBookingsByCustomerId
      Uri.parse('$_baseUrl/RestaurantBooking/customer/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  }

  /// Cancels a booking by its ID.
  Future<bool> cancelBooking(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('User is not logged in.');
    }

    final response = await http.delete(
      // This endpoint should match your backend's RestaurantBookingController
      Uri.parse('$_baseUrl/RestaurantBooking/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Status code 204 (No Content) is a common successful response for a DELETE request.
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to cancel booking. Status: ${response.statusCode}');
    }
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String birthDate,
    required String locationId,
  }) async {

    final response = await http.post(
      Uri.parse('$_baseUrl/User/SignUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'birthDate': birthDate,
        'locationId': locationId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      String message = 'An error occurred during sign up.';
      if (response.body.isNotEmpty) {
        try {
          message = response.body;
        } catch (e) {
        }
      }
      throw Exception(message);
    }
  }

  Future<bool> payForBooking(String bookingId, String paymentToken) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$_baseUrl/RestaurantBooking/pay'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'bookingId': bookingId,
        'paymentToken': paymentToken,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to process payment');
    }
  }

  // New methods for fetching countries and cities
  Future<List<dynamic>> getCountries() async {
    final response = await http.get(Uri.parse('$_baseUrl/countries'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<List<dynamic>> getCitiesByCountry(String countryId) async {
    final response = await http.get(Uri.parse('$_baseUrl/cities/country/$countryId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cities for country $countryId');
    }
  }

  Future<String> checkExistingLocation(String countryId, String cityId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/Location/check'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'countryId': countryId, 'cityId': cityId }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check existing location');
    }
  }

  Future<List<dynamic>> getCuisinesByRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$restaurantId/cuisines'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cuisines for restaurant $restaurantId');
    }
  }

  Future<List<dynamic>> getMealTypesByRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$restaurantId/mealtypes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cuisines for restaurant $restaurantId');
    }
  }

  Future<List<dynamic>> getTagsByRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$restaurantId/tags'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cuisines for restaurant $restaurantId');
    }
  }

  Future<List<dynamic>> getFeaturesByRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$restaurantId/features'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load features for restaurant $restaurantId');
    }
  }

  Future<List<dynamic>> getWorkTimesByRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Restaurants/$restaurantId/worktimes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load work times for restaurant $restaurantId');
    }
  }

  Future<List<dynamic>> getReviewsByRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/RestaurantReview/restaurant/$restaurantId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load reviews for restaurant $restaurantId');
    }
  }

  Future<dynamic> getPropertyTypeByHotel(String propertyTypeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/PropertyTypes/$propertyTypeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Property Types with Id: $propertyTypeId');
    }
  }

  Future<List<dynamic>> getAmenitiesByHotel(String hotelId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Hotels/$hotelId/amenities'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Amenities for hotel with Id: $hotelId');
    }
  }

  Future<bool> createHotelReservation(HotelReservation reservation) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$_baseUrl/HotelReservations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create hotel booking');
    }
  }

  Future<List<dynamic>> getReservationsByCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = await getCustomerId();

    if (token == null || userId == null) {
      throw Exception('User is not logged in.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/HotelReservations/customer/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load hotel reservations');
    }
  }
}
