class Hotel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String url;
  final double starRate;
  final int numberOfRooms;
  final String pictureUrl;
  final double minPrice;
  final double maxPrice;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.url,
    required this.starRate,
    required this.numberOfRooms,
    required this.pictureUrl,
    required this.minPrice,
    required this.maxPrice,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      url: json['url'] ?? '',
      starRate: (json['starRate'] ?? 0.0).toDouble(),
      numberOfRooms: int.tryParse(json['numberOfRooms']?.toString() ?? '') ?? 0,
      pictureUrl: json['pictureUrl'] ?? '',
      minPrice: (json['minPrice'] ?? 0.0).toDouble(),
      maxPrice: (json['maxPrice'] ?? 0.0).toDouble(),
    );
  }
}
