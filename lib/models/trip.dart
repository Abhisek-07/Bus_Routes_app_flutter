// model for each trip
class Trip {
  Trip(
      {required this.tripStartTime,
      required this.totalSeats,
      required this.available});

  String tripStartTime;
  int totalSeats;
  int available;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripStartTime: json['tripStartTime'],
      totalSeats: json['totalSeats'],
      available: json['available'],
    );
  }
}
