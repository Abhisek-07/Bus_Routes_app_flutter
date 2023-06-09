import 'dart:async';

import 'package:bus_routes/models/bus_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bus_routes/service/utils.dart';

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    updateData();
    startTimer();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //onSelectNotification: onSelectNotification,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // updates sorted list of bus routes
  void updateData() {
    sortedRoutes = sortRoutesByTime(widget.busRoutes);
  }

  // starts timer for periodic update of bus routes every minute
  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      setState(() {
        updateData();
      });
    });
  }

  // For handling notification permissions
  Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  // For showing notification
  Future<void> showNotification() async {
    final permissionGranted = await requestNotificationPermission();

    if (!permissionGranted) {
      return;
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Bus Reminder',
      'Your bus will arrive in 5 minutes!',
      platformChannelSpecifics,
    );
  }

  // String getTripEndTime(String tripStartTime, String tripDuration) {
  //   // Parse the trip start time
  //   final startTime = timeFormat.parse(tripStartTime);

  //   // Split the trip duration into parts

  //   final durationParts = tripDuration.split(' ');

  //   int hours = 0;
  //   int minutes = 0;

  //   for (final part in durationParts) {
  //     if (part.contains('hrs')) {
  //       final value = int.tryParse(part.split('hrs')[0]);
  //       if (value != null) {
  //         hours = value;
  //       }
  //     } else {
  //       final value = int.tryParse(part);
  //       if (value != null) {
  //         minutes = value;
  //       }
  //     }
  //   }

  //   DateTime endTime = startTime.add(Duration(hours: hours, minutes: minutes));
  //   final formattedEndTime = timeFormat.format(endTime);

  //   return formattedEndTime;
  // }

  // List<BusRoute> sortRoutesByTime(List<BusRoute> routes) {
  //   final deviceTime = timeFormat.format(DateTime.now());

  //   routes.forEach((route) {
  //     if (route.trips.isNotEmpty) {
  //       final upcomingTrips = route.trips
  //           .where((trip) => timeFormat
  //               .parse(trip.tripStartTime)
  //               .isAfter(timeFormat.parse(deviceTime)))
  //           .toList();

  //       if (upcomingTrips.isNotEmpty) {
  //         upcomingTrips.sort((a, b) => timeFormat
  //             .parse(a.tripStartTime)
  //             .compareTo(timeFormat.parse(b.tripStartTime)));

  //         route.shortestTripStartTime = upcomingTrips[0].tripStartTime;
  //       }
  //     }
  //   });

  //   routes.sort((a, b) {
  //     if (a.shortestTripStartTime == null || b.shortestTripStartTime == null) {
  //       return 0;
  //     }

  //     return timeFormat
  //         .parse(a.shortestTripStartTime!)
  //         .compareTo(timeFormat.parse(b.shortestTripStartTime!));
  //   });

  //   return routes;
  // }

  @override
  Widget build(BuildContext context) {
    // List<BusRoute> sortedRoutes = sortRoutesByTime(widget.busRoutes);

    // count to check if no more trips are remaining in any route, then to return a center widget with no more trips
    int routesWithNoUpcomingTrips = 0;
    return ListView.builder(
        itemCount: sortedRoutes.length,
        itemBuilder: (context, index) {
          final route = sortedRoutes[index];

          if (route.shortestTripStartTime == null) {
            routesWithNoUpcomingTrips++;
            if (routesWithNoUpcomingTrips == sortedRoutes.length) {
              return const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text('No more trips'),
                ),
              );
            }
            return Container();
          }

          final currentTime = timeFormat.format(DateTime.now());
          final remainingTime = timeFormat
              .parse(route.shortestTripStartTime!)
              .difference(timeFormat.parse(currentTime));
          final tripEndTime =
              getTripEndTime(route.shortestTripStartTime!, route.tripDuration);

          if (remainingTime.inMinutes <= 0) {
            return Container();
          }

          if (remainingTime.inMinutes == 5) {
            showNotification();
          }

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
                                  title: Text(route.source),
                                  subtitle: Text(route.shortestTripStartTime!),
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
                                  title: Text(route.destination),
                                  subtitle: Text(tripEndTime),
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
                                  'Departure in:',
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
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const TextSpan(
                                        text: 'mins',
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text('Travel time: ${route.tripDuration}'),
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
                            Text(route.name),
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
