class HotelReservation {
  final String hotelId;
  final String customerId;
  final String roomId;
  final int numberOfPeople;
  final DateTime reservationStartDate;
  final DateTime reservationEndDate;

  HotelReservation({
    required this.hotelId,
    required this.customerId,
    required this.roomId,
    required this.numberOfPeople,
    required this.reservationStartDate,
    required this.reservationEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'HotelId': hotelId,
      'CustomerId': customerId,
      'RoomId': roomId,
      'NumberOfPeople': numberOfPeople,
      'ReservationStartDate':
      "${reservationStartDate.year.toString().padLeft(4, '0')}-${reservationStartDate.month.toString().padLeft(2, '0')}-${reservationStartDate.day.toString().padLeft(2, '0')}",
      'ReservationEndDate':
      "${reservationEndDate.year.toString().padLeft(4, '0')}-${reservationEndDate.month.toString().padLeft(2, '0')}-${reservationEndDate.day.toString().padLeft(2, '0')}",
    };
  }

  factory HotelReservation.fromJson(Map<String, dynamic> json) {
    return HotelReservation(
      hotelId: json['hotelId'] ?? '',
      customerId: json['customerId'] ?? '',
      roomId: json['roomId'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? 0,
      reservationStartDate: json['reservationStartDate'] != null
          ? DateTime.parse(json['reservationStartDate'])
          : DateTime.now(),
      reservationEndDate: json['reservationEndDate'] != null
          ? DateTime.parse(json['reservationEndDate'])
          : DateTime.now(),
    );
  }
}