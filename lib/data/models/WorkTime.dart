class WorkTime {
  final String dayOfWeek;
  final String openingTime;
  final String closingTime;

  WorkTime({required this.dayOfWeek, required this.openingTime, required this.closingTime});

  factory WorkTime.fromJson(Map<String, dynamic> json) {
    return WorkTime(
      dayOfWeek: _getDayOfWeek(json['dayOfWeek']),
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
    );
  }

  static String _getDayOfWeek(int day) {
    switch (day) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Unknown';
    }
  }
}