class PropertyType {
  final String id;
  final String name;

  PropertyType({required this.id, required this.name});

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json['id'],
      name: json['name'],
    );
  }
}