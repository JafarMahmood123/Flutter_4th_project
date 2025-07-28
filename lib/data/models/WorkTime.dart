class WorkTime {
  final String dayOfWeek;
  final String openingTime;
  final String closingTime;

  WorkTime({required this.dayOfWeek, required this.openingTime, required this.closingTime});

  factory WorkTime.fromJson(Map<String, dynamic> json) {
    return WorkTime(
      dayOfWeek: json['dayOfWeek'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
    );
  }
}