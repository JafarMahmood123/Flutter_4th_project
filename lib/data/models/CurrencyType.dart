class CurrencyType {
  final String id;
  final String name;

  CurrencyType({required this.id, required this.name});

  factory CurrencyType.fromJson(Map<String, dynamic> json) {
    return CurrencyType(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
    );
  }
}
