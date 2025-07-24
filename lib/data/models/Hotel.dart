class Hotel {
  final String id;
  final String name;
  final double starRate;
  // Add other fields as needed

  Hotel({required this.id, required this.name, required this.starRate});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      starRate: json['starRate'].toDouble(),
    );
  }
}