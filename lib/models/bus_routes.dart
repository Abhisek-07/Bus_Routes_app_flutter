import 'package:bus_routes/models/trip.dart';

// model for bus route to store each route info and it has a shortestTripStartTime property that is extracted by sorting the trips list
class BusRoute {
  BusRoute(
      {required this.id,
      required this.name,
      required this.source,
      required this.destination,
      required this.tripDuration,
      required this.icon,
      required this.trips});

  String id;
  String name;
  String source;
  String destination;
  String tripDuration;
  String icon;
  List<Trip> trips;
  String? shortestTripStartTime;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'destination': destination,
      'tripDuration': tripDuration,
      'icon': icon,
      'trips': trips.map((trip) => trip.toJson()).toList(),
      'shortestTripStartTime': shortestTripStartTime,
    };
  }
}
