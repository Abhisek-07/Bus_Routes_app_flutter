import 'dart:async';

import 'package:bus_routes/models/bus_routes.dart';
import 'package:bus_routes/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:bus_routes/utils/utils.dart';

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
  NotificationService notificationService = NotificationService();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // timer and notification settings are initialised inside initstate
  @override
  void initState() {
    super.initState();
    updateData();
    startTimer();

    // const initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // const initializationSettingsIOS = DarwinInitializationSettings();
    // const initializationSettings = InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsIOS,
    // );

    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    // );
  }

  @override
  void dispose() {
    timer?.cancel();
    notificationService.dispose();
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

  // // For handling notification permissions
  // Future<bool> requestNotificationPermission() async {
  //   PermissionStatus status = await Permission.notification.status;
  //   if (!status.isGranted) {
  //     status = await Permission.notification.request();
  //   }
  //   return status.isGranted;
  // }

  // // For showing notification
  // Future<void> showNotification() async {
  //   final permissionGranted = await requestNotificationPermission();

  //   if (!permissionGranted) {
  //     return;
  //   }

  //   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'channel_id',
  //     'channel_name',
  //     channelDescription: 'channel_description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );

  //   const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

  //   const platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Bus Reminder',
  //     'Your bus will arrive in 5 minutes!',
  //     platformChannelSpecifics,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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

          if (remainingTime.inMinutes == 80) {
            notificationService.showNotification();
          }

          return Center(
            child: Card(
              margin: const EdgeInsets.only(bottom: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                                  title: Text(
                                    route.source,
                                    style: const TextStyle(fontSize: 14),
                                  ),
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
                                  title: Text(
                                    route.destination,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(tripEndTime),
                                )
                              ],
                            ),
                          ),
                          // Expanded(
                          //     child: Divider(
                          //   height: 50,
                          // )),
                          const VerticalDivider(),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Departure in:',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${remainingTime.inMinutes}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: 'mins',
                                        style: TextStyle(fontSize: 12),
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
                            const Icon(
                              Icons.bus_alert,
                              color: Colors.lightBlue,
                            ),
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
