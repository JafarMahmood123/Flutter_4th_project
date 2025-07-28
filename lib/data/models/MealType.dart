class MealType {
  final String id;
  final String name;

  MealType({required this.id, required this.name});

  factory MealType.fromJson(Map<String, dynamic> json) {
    return MealType(
      id: json['id'],
      name: json['name'],
    );
  }
}