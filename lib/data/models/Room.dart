class Room {
  final String id;
  final int roomNumber;
  final int maxOccupancy;
  final String description;
  final double price;
  final String roomTypeDescription;

  Room({
    required this.id,
    required this.roomNumber,
    required this.maxOccupancy,
    required this.description,
    required this.price,
    required this.roomTypeDescription,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      roomNumber: json['roomNumber'] ?? 0,
      maxOccupancy: json['maxOccupancy'] ?? 0,
      description: json['description'] ?? 'No Description',
      price: (json['price'] ?? 0.0).toDouble(),
      roomTypeDescription: json['roomTypeId'] ?? '',
    );
  }
}
