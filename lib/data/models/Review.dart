class Review {
  final String id;
  final String description;
  final double customerStarRating;
  final double ServiceStarRating;
  final double customerFoodStarRating;
  // final DateTime date;

  Review({
    required this.id,
    // required this.author,
    required this.description,
    required this.customerStarRating,
    required this.ServiceStarRating,
    required this.customerFoodStarRating,
    // required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      // author: json['author'] ?? 'Anonymous',
      description: json['description'] ?? '',
      customerStarRating: (json['customerStarRating'] ?? 0.0).toDouble(),
      ServiceStarRating: (json['customerServiceStarRating'] ?? 0.0).toDouble(),
      customerFoodStarRating: (json['customerFoodStarRating'] ?? 0.0).toDouble(),
      // date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }
}