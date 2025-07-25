class Dish {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String restaurantId;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.restaurantId,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
    );
  }
}