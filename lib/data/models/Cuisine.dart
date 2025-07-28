class Cuisine {
  final String id;
  final String name;

  Cuisine({required this.id, required this.name});

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'],
      name: json['name'],
    );
  }
}