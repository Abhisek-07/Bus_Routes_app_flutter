import 'package:bus_routes/models/trip.dart';

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

  // factory BusRoute.fromJson(Map<String, dynamic> json) {
  //   var tripList = json['trips'] as List<dynamic>;
  //   List<Trip> trips = tripList.map((trip) => Trip.fromJson(trip)).toList();

  //   return BusRoute(
  //     id: json['id'],
  //     name: json['name'],
  //     source: json['source'],
  //     destination: json['destination'],
  //     tripDuration: json['tripDuration'],
  //     icon: json['icon'],
  //     trips: trips,
  //   );
  // }
}
