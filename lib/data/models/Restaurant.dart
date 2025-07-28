import 'package:user_flutter_project/data/models/Dish.dart';

import 'Cuisine.dart';
import 'Feature.dart';
import 'MealType.dart';
import 'Tag.dart';
import 'WorkTime.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String url;
  final String pictureUrl;
  final double starRating;
  final double latitude;
  final double longitude;
  final int numberOfTables;
  final String priceLevel;
  final double minPrice;
  final double maxPrice;
  final String locationId;
  final String? restaurantManagerId;
  final List<Cuisine> cuisines;
  final List<MealType> mealTypes;
  final List<Feature> features;
  final List<Tag> tags;
  final List<WorkTime> workTimes;
  final List<Dish> dishes;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.pictureUrl,
    required this.starRating,
    required this.latitude,
    required this.longitude,
    required this.numberOfTables,
    required this.priceLevel,
    required this.minPrice,
    required this.maxPrice,
    required this.locationId,
    this.restaurantManagerId,
    required this.cuisines,
    required this.mealTypes,
    required this.features,
    required this.tags,
    required this.workTimes,
    required this.dishes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '',
      starRating: (json['starRating'] ?? 0.0).toDouble(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      numberOfTables: json['numberOfTables'] ?? 0,
      priceLevel: json['priceLevel'] ?? 'NotSet',
      minPrice: (json['minPrice'] ?? 0.0).toDouble(),
      maxPrice: (json['maxPrice'] ?? 0.0).toDouble(),
      locationId: json['locationId'] ?? '',
      restaurantManagerId: json['restaurantManagerId'],
      cuisines: (json['cuisines'] as List<dynamic>? ?? []).map((e) => Cuisine.fromJson(e)).toList(),
      mealTypes: (json['mealTypes'] as List<dynamic>? ?? []).map((e) => MealType.fromJson(e)).toList(),
      features: (json['features'] as List<dynamic>? ?? []).map((e) => Feature.fromJson(e)).toList(),
      tags: (json['tags'] as List<dynamic>? ?? []).map((e) => Tag.fromJson(e)).toList(),
      workTimes: (json['workTimes'] as List<dynamic>? ?? []).map((e) => WorkTime.fromJson(e)).toList(),
      dishes: (json['dishes'] as List<dynamic>? ?? []).map((e) => Dish.fromJson(e)).toList(),
    );
  }
}