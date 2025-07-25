class Booking {
  final String id;
  final DateTime receiveDateTime;
  final String bookingDurationTime;
  final int numberOfPeople;
  final String restaurantName;
  final String restaurantPictureUrl;

  Booking({
    required this.id,
    required this.receiveDateTime,
    required this.bookingDurationTime,
    required this.numberOfPeople,
    required this.restaurantName,
    required this.restaurantPictureUrl,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      receiveDateTime: DateTime.tryParse(json['receiveDateTime'] ?? '') ?? DateTime.now(),
      bookingDurationTime: json['bookingDurationTime'] ?? '00:00:00',
      numberOfPeople: json['numberOfPeople'] ?? 0,
      restaurantName: json['restaurantName'] ?? 'N/A',
      // Assuming the backend provides this, otherwise you might need another API call.
      // For now, let's use a placeholder if it's null.
      restaurantPictureUrl: json['restaurantPictureUrl'] ?? '',
    );
  }
}