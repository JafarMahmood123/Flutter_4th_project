class Hotel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String url;
  final double starRate;
  final int numberOfRooms;

  Hotel({required this.id, required this.name, required this.description,
    required this.latitude, required this.longitude, required this.url,
    required this.starRate, required this.numberOfRooms});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      url: json['url'],
      starRate: json['starRate'].toDouble(),
      numberOfRooms: int.parse(json['numberOfRooms']),
    );
  }
}