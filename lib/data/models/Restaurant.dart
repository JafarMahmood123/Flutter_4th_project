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
  final RestaurantPriceLevel priceLevel;
  final double minPrice;
  final double maxPrice;
  final String locationId;
  final String? restaurantManagerId;

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
      priceLevel: RestaurantPriceLevel.values.firstWhere(
            (e) => e.toString() == 'RestaurantPriceLevel.${json['priceLevel']}',
        orElse: () => RestaurantPriceLevel.Moderate,
      ),
      minPrice: (json['minPrice'] ?? 0.0).toDouble(),
      maxPrice: (json['maxPrice'] ?? 0.0).toDouble(),
      locationId: json['locationId'] ?? '',
      restaurantManagerId: json['restaurantManagerId'],
    );
  }
}

enum RestaurantPriceLevel {
  Cheap,
  Moderate,
  Expensive,
  Luxury,
}