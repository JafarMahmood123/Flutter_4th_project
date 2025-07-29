class HotelReservation {
  final String hotelId;
  final String customerId;
  final String roomId;
  final int numberOfPeople;
  final DateTime receivationStartDate;
  final DateTime receivationEndDate;

  HotelReservation({
    required this.hotelId,
    required this.customerId,
    required this.roomId,
    required this.numberOfPeople,
    required this.receivationStartDate,
    required this.receivationEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'hotelId': hotelId,
      'customerId': customerId,
      'roomId': roomId,
      'numberOfPeople': numberOfPeople,
      'receivationStartDate': receivationStartDate.toIso8601String(),
      'receivationEndDate': receivationEndDate.toIso8601String(),
    };
  }
}
