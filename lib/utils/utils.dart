import 'package:bus_routes/models/bus_routes.dart';

import 'package:intl/intl.dart';

final timeFormat = DateFormat('HH:mm');

// returns trips end time using trip start time and duration
String getTripEndTime(String tripStartTime, String tripDuration) {
  // Parse the trip start time
  final startTime = timeFormat.parse(tripStartTime);

  // Split the trip duration into parts

  final durationParts = tripDuration.split(' ');

  int hours = 0;
  int minutes = 0;

  for (final part in durationParts) {
    if (part.contains('hrs')) {
      final value = int.tryParse(part.split('hrs')[0]);
      if (value != null) {
        hours = value;
      }
    } else {
      final value = int.tryParse(part);
      if (value != null) {
        minutes = value;
      }
    }
  }

  DateTime endTime = startTime.add(Duration(hours: hours, minutes: minutes));
  final formattedEndTime = timeFormat.format(endTime);

  return formattedEndTime;
}

// sorts the trips of each route (only upcoming trips) and then sorts the routes based on the shortest remaining time(first entry of upcoming trips) of each route
List<BusRoute> sortRoutesByTime(List<BusRoute> busRoutes) {
  List<BusRoute> routes = busRoutes;
  final deviceTime = timeFormat.format(DateTime.now());

  routes.forEach((route) {
    if (route.trips.isNotEmpty) {
      final upcomingTrips = route.trips
          .where((trip) => timeFormat
              .parse(trip.tripStartTime)
              .isAfter(timeFormat.parse(deviceTime)))
          .toList();

      if (upcomingTrips.isNotEmpty) {
        upcomingTrips.sort((a, b) => timeFormat
            .parse(a.tripStartTime)
            .compareTo(timeFormat.parse(b.tripStartTime)));

        route.shortestTripStartTime = upcomingTrips[0].tripStartTime;
      }
    }
  });

  // routes.sort((a, b) {
  //   if (a.shortestTripStartTime == null || b.shortestTripStartTime == null) {
  //     return 0;
  //   }

  //   return timeFormat
  //       .parse(a.shortestTripStartTime!)
  //       .compareTo(timeFormat.parse(b.shortestTripStartTime!));
  // });

  routes.sort((a, b) {
    final shortestStartTimeA = a.shortestTripStartTime != null
        ? timeFormat.parse(a.shortestTripStartTime!)
        : null;
    final shortestStartTimeB = b.shortestTripStartTime != null
        ? timeFormat.parse(b.shortestTripStartTime!)
        : null;

    if (shortestStartTimeA != null && shortestStartTimeB != null) {
      return shortestStartTimeA.compareTo(shortestStartTimeB);
    } else if (shortestStartTimeA != null) {
      return -1;
    } else if (shortestStartTimeB != null) {
      return 1;
    } else {
      return 0;
    }
  });

  routes.forEach((element) {
    print(element.shortestTripStartTime);
  });

  return routes;
}
