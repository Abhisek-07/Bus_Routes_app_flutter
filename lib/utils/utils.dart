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
    // if string contains 'hrs', it is no of hours, else it contains no of minutes
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

List<BusRoute> sortRoutesByTime(List<BusRoute> busRoutes) {
  final deviceTime = timeFormat.format(DateTime.now());

  // Sort the routes based on tripStartTime
  busRoutes.sort((a, b) {
    final tripStartTimeA = a.tripStartTime;
    final tripStartTimeB = b.tripStartTime;

    if (tripStartTimeA == null && tripStartTimeB == null) {
      return 0;
    } else if (tripStartTimeA == null) {
      return 1;
    } else if (tripStartTimeB == null) {
      return -1;
    } else {
      return timeFormat
          .parse(tripStartTimeA)
          .compareTo(timeFormat.parse(tripStartTimeB));
    }
  });

  // Filter the routes to keep only those with tripStartTime after device time
  final filteredRoutes = busRoutes.where((route) {
    final routeTime = timeFormat.parse(route.tripStartTime!);
    return routeTime.isAfter(timeFormat.parse(deviceTime));
  }).toList();

  filteredRoutes.forEach((element) {
    print(element.tripStartTime);
  });

  print(filteredRoutes.length);

  return filteredRoutes;
}

// returns remaining time from tripTime compared to currentTime
int getRemainingTimeInMinutes(String tripTime) {
  final currentTime = timeFormat.format(DateTime.now());
  final remainingTime =
      timeFormat.parse(tripTime).difference(timeFormat.parse(currentTime));

  return remainingTime.inMinutes;
}
