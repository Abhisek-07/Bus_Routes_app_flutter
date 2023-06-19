import 'dart:convert';

import 'package:bus_routes/models/bus_routes.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// api_service to fetch json data and return list of Bus routes
class ApiService {
  Future<List<BusRoute>> getData() async {
    const url =
        'https://d080ce76-38ec-4b9b-aca2-6b6f0bf3b176.mock.pstmn.io/bus_routes';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    final data = response.body;

    final Map<String, dynamic> busData = json.decode(data);

    List<BusRoute> busRoutes = [];

    // list of bus routes
    List<dynamic> routesInfo = busData['routeInfo'];
    final Map<String, dynamic> routeTimings = busData['routeTimings'];

    routesInfo.forEach((route) {
      final String routeId = route['id'];
      final List<dynamic> trips = routeTimings[routeId]!;

      trips.forEach((trip) {
        if (trip != null && trip is Map<String, dynamic> && trip.isNotEmpty) {
          final String? tripStartTime = trip['tripStartTime'];
          final int? totalSeats = trip['totalSeats'];
          final int? available = trip['avaiable'];

          final BusRoute busRoute =
              BusRoute.fromJson(route, tripStartTime, totalSeats, available);

          busRoutes.add(busRoute);
        }
      });
    });

    print(jsonEncode(busRoutes[0].toJson()));

    return busRoutes;
  }
}

final routesProvider = FutureProvider<List<BusRoute>>((ref) async {
  ApiService apiService = ApiService();
  final busRoutes = await apiService.getData();
  return busRoutes;
});
