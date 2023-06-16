// import 'package:bus_routes/models/trip.dart';

// model for bus route to store each route info and it has a shortestTripStartTime property that is extracted by sorting the trips list
class BusRoute {
  BusRoute({
    required this.id,
    required this.name,
    required this.source,
    required this.destination,
    required this.tripDuration,
    required this.icon,
    this.tripStartTime,
    this.totalSeats,
    this.available,
    // required this.trips,
  });

  String id;
  String name;
  String source;
  String destination;
  String tripDuration;
  String icon;
  // List<Trip> trips;
  String? tripStartTime;
  int? totalSeats;
  int? available;

  factory BusRoute.fromJson(Map<String, dynamic> json, String? tripStartTime,
      int? totalSeats, int? available) {
    return BusRoute(
      id: json['id'],
      name: json['name'],
      source: json['source'],
      tripDuration: json['tripDuration'],
      destination: json['destination'],
      icon: json['icon'],
      tripStartTime: tripStartTime,
      totalSeats: totalSeats,
      available: available,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'destination': destination,
      'tripDuration': tripDuration,
      'icon': icon,
      'tripStartTime': tripStartTime,
      'totalSeats': totalSeats,
      'available': available,
      // 'trips': trips.map((trip) => trip.toJson()).toList(),
      // 'shortestTripStartTime': shortestTripStartTime,
    };
  }
}
