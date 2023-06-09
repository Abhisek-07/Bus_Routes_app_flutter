import 'dart:async';

import 'package:bus_routes/models/bus_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final timeFormat = DateFormat('HH:mm');

class RoutesList extends StatefulWidget {
  const RoutesList({super.key, required this.busRoutes});

  final List<BusRoute> busRoutes;

  @override
  State<RoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  Timer? timer;
  List<BusRoute> sortedRoutes = [];

  void updateData() {
    sortedRoutes = sortRoutesByTime(widget.busRoutes);
  }

  @override
  void initState() {
    super.initState();
    updateData();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      setState(() {
        updateData();
      });
    });
  }

  List<BusRoute> sortRoutesByTime(List<BusRoute> routes) {
    final deviceTime = DateFormat('HH:mm').format(DateTime.now());

    // routes.forEach((route) {
    //   route.trips.sort((a, b) {
    //     final timeA = timeFormat.parse(a.tripStartTime);
    //     final timeB = timeFormat.parse(b.tripStartTime);
    //     final differenceA =
    //         timeA.difference(timeFormat.parse(deviceTime)).abs();
    //     final differenceB =
    //         timeB.difference(timeFormat.parse(deviceTime)).abs();
    //     return differenceA.compareTo(differenceB);
    //   });
    // });
    routes.forEach((route) {
      if (route.trips.isNotEmpty) {
        final upcomingTrips = route.trips
            .where((trip) => DateFormat('HH:mm')
                .parse(trip.tripStartTime)
                .isAfter(DateFormat('HH:mm').parse(deviceTime)))
            .toList();

        if (upcomingTrips.isNotEmpty) {
          upcomingTrips.sort((a, b) => DateFormat('HH:mm')
              .parse(a.tripStartTime)
              .compareTo(DateFormat('HH:mm').parse(b.tripStartTime)));

          route.shortestTripStartTime = upcomingTrips[0].tripStartTime;
        }
      }
    });

    routes.sort((a, b) {
      // if (a.trips.isEmpty || b.trips.isEmpty) {
      //   return 0;
      // }

      // final smallestTimeA = timeFormat.parse(a.trips[0].tripStartTime);
      // final smallestTimeB = timeFormat.parse(b.trips[0].tripStartTime);
      // final differenceA =
      //     smallestTimeA.difference(timeFormat.parse(deviceTime)).abs();
      // final differenceB =
      //     smallestTimeB.difference(timeFormat.parse(deviceTime)).abs();
      // return differenceA.compareTo(differenceB);

      if (a.shortestTripStartTime == null || b.shortestTripStartTime == null) {
        return 0;
      }

      return DateFormat('HH:mm')
          .parse(a.shortestTripStartTime!)
          .compareTo(DateFormat('HH:mm').parse(b.shortestTripStartTime!));
    });

    return routes;
  }

  @override
  Widget build(BuildContext context) {
    // List<BusRoute> sortedRoutes = sortRoutesByTime(widget.busRoutes);

    return ListView.builder(
        itemCount: widget.busRoutes.length,
        itemBuilder: (context, index) {
          final route = sortedRoutes[index];

          if (route.shortestTripStartTime == null) {
            return Container();
          }

          // if (route.shortestTripStartTime == null) {
          //   return Center(
          //     child: Card(
          //       margin: const EdgeInsets.only(bottom: 30),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(16)),
          //       child: const Padding(
          //         padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
          //         child: SizedBox(
          //           width: 350,
          //           height: 200,
          //           child: Text('No trips available'),
          //         ),
          //       ),
          //     ),
          //   );
          // }

          // final smallestTime =
          //     DateFormat('HH:mm').parse(route.shortestTripStartTime!);
          // final remainingTime = smallestTime.difference(
          //     timeFormat.parse(DateFormat('HH:mm').format(DateTime.now())));

          final currentTime = DateFormat('HH:mm').format(DateTime.now());
          final remainingTime = DateFormat('HH:mm')
              .parse(route.shortestTripStartTime!)
              .difference(DateFormat('HH:mm').parse(currentTime));

          return Center(
            child: Card(
              margin: const EdgeInsets.only(bottom: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: SizedBox(
                  width: 350,
                  height: 200,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: const IconTheme(
                                    data: IconThemeData(
                                      color: Colors.blue,
                                    ),
                                    child: Icon(Icons.location_on),
                                  ),
                                  title: Text(widget.busRoutes[index].source),
                                  subtitle: Text('date & time to be added'),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ListTile(
                                  minLeadingWidth: 10,
                                  leading: const IconTheme(
                                    data: IconThemeData(
                                      color: Colors.red,
                                    ),
                                    child: Icon(Icons.location_on),
                                  ),
                                  title:
                                      Text(widget.busRoutes[index].destination),
                                  subtitle: Text('date & time to be added'),
                                )
                              ],
                            ),
                          ),
                          // Expanded(
                          //     child: Divider(
                          //   height: 50,
                          // )),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Departure on:',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${remainingTime.inMinutes}',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const TextSpan(
                                        text: 'mins',
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.busRoutes[index].name),
                            const SizedBox(
                              width: 20,
                            ),
                            const Icon(Icons.bus_alert),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
