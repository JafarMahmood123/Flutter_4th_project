class Amenity {
  final String id;
  final String name;
  final double price;
  final String hotelId;

  Amenity({
    required this.id,
    required this.name,
    required this.price,
    required this.hotelId,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      price: (json['price'] ?? 0.0).toDouble(),
      hotelId: json['hotelId'] ?? '',
    );
  }
}