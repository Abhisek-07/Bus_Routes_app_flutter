import 'dart:async';

import 'package:bus_routes/models/bus_routes.dart';
import 'package:bus_routes/utils/notification_service.dart';
import 'package:bus_routes/widgets/route_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

import 'package:bus_routes/utils/utils.dart';
import 'package:bus_routes/utils/shared_preferences_helper.dart';

// made sorted routes global variable to use in workmanager and by this screen, the busRoutes list is available, filter options to filter routes
List<String> filterOptions = ['All', 'k-11', 'k-12', 'k-14', 'R-1', 'G-12'];
List<BusRoute> sortedRoutes = [];
Workmanager workmanager = Workmanager();
final timeFormat = DateFormat('HH:mm');

// method executed by workmanager to sort and store the routes and show a notification for next bus timing...
void callbackDispatcher() {
  workmanager.executeTask((task, inputData) async {
    if (task == "sortRoutesTask") {
      sortedRoutes =
          await SharedPreferencesHelper.getSortedRoutesFromSharedPreferences();

      sortedRoutes = sortRoutesByTime(sortedRoutes);

      if (sortedRoutes.isNotEmpty && sortedRoutes[0].tripStartTime != null) {
        final remainingTime =
            getRemainingTimeInMinutes(sortedRoutes[0].tripStartTime!);
        NotificationService notificationService = NotificationService();
        await notificationService.init();
        notificationService.showNotification(
            sortedRoutes[0].name, remainingTime);
      }

      await SharedPreferencesHelper.saveSortedRoutesToSharedPreferences(
          sortedRoutes);
    }

    return Future.value(true);
  });
}

class RoutesList extends StatefulWidget {
  const RoutesList({super.key, required this.busRoutes});

  final List<BusRoute> busRoutes;

  @override
  State<RoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  // List<BusRoute> sortedRoutes = [];
  String selectedFilter = 'All';

  Timer? timer;

  NotificationService notificationService = NotificationService();

  bool isLoading = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // timer is initialised inside initstate and first call to updateData to sort the routes, also work manager is configured and notifications are initialized
  @override
  void initState() {
    super.initState();
    updateData();
    startTimer();
    configureWorkManager();
    initializeNotifications();
  }

  void initializeNotifications() async {
    await notificationService.init();
  }

  // for configuring the work manager
  void configureWorkManager() {
    workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    workmanager.registerPeriodicTask(
      "sortRoutesTask",
      "sortRoutesTask",
      frequency: const Duration(minutes: 1),
      initialDelay: const Duration(seconds: 2),
    );
  }

  // dispose method
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // updates sorted list of bus routes
  void updateData() async {
    setState(() {
      sortedRoutes = sortRoutesByTime(widget.busRoutes);
    });

    // saving sorted routes to shared preferences
    await SharedPreferencesHelper.saveSortedRoutesToSharedPreferences(
        sortedRoutes);

    // logic for showing notifications when 5 minutes till next bus
    if (sortedRoutes.isNotEmpty && sortedRoutes[0].tripStartTime != null) {
      final remainingTime =
          getRemainingTimeInMinutes(sortedRoutes[0].tripStartTime!);

      if (remainingTime == 5) {
        notificationService.showNotification(
            sortedRoutes[0].name, remainingTime);
      }
    }
  }

  // starts timer for periodic update of bus routes every minute
  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      updateData();
    });
  }

  // function to be executed on pull to refresh
  Future<void> _refreshList() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    isLoading = false;
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    List<BusRoute> filteredRoutes;

    if (selectedFilter == 'All') {
      filteredRoutes = sortedRoutes;
    } else {
      filteredRoutes =
          sortedRoutes.where((route) => route.name == selectedFilter).toList();
    }

    if (isLoading) {
      return Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1),
          duration: const Duration(milliseconds: 1500),
          builder: (context, value, _) => CircularProgressIndicator(
            value: value,
          ),
        ),
      );
    }

    if (sortedRoutes.isEmpty) {
      return const Center(
        child: Text(
          'No more trips left',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    }

    return Column(
      children: [
        DropdownButton(
          value: selectedFilter,
          items: filterOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedFilter = value!;
              // updateData();
            });
          },
        ),
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshList,
            child: ListView.builder(
                itemCount: filteredRoutes.length,
                itemBuilder: (context, index) {
                  final route = filteredRoutes[index];

                  if (route.tripStartTime == null) {
                    // returns this if route's tripstarttime is null...
                    return Container();
                  }

                  final remainingTime =
                      getRemainingTimeInMinutes(route.tripStartTime!);
                  final tripEndTime =
                      getTripEndTime(route.tripStartTime!, route.tripDuration);

                  if (remainingTime <= 0) {
                    return Container();
                  }

                  return RouteCard(
                      route: route,
                      remainingTime: remainingTime,
                      tripEndTime: tripEndTime);
                  // // widget for route card
                  // return GestureDetector(
                  //   onTap: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) => AlertDialog(
                  //               backgroundColor: Theme.of(context)
                  //                   .colorScheme
                  //                   .inversePrimary,
                  //               title: Text(
                  //                 'Bus Details',
                  //                 style: TextStyle(
                  //                     color: Theme.of(context)
                  //                         .colorScheme
                  //                         .primary),
                  //               ),
                  //               content: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   Text(
                  //                     'Source: ${route.source}',
                  //                     style: const TextStyle(fontSize: 16),
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text(
                  //                     'Destination: ${route.destination}',
                  //                     style: const TextStyle(fontSize: 16),
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text(
                  //                     'Departure Time: ${route.tripStartTime}',
                  //                     style: const TextStyle(fontSize: 16),
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text(
                  //                     'Trip Duration: ${route.tripDuration}',
                  //                     style: const TextStyle(fontSize: 16),
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text(
                  //                     'Route: ${route.name}',
                  //                     style: const TextStyle(fontSize: 16),
                  //                     textAlign: TextAlign.center,
                  //                   ),
                  //                 ],
                  //               ),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   },
                  //                   child: const Text('Close'),
                  //                 ),
                  //               ],
                  //             ));
                  //   },
                  //   child: Center(
                  //     child: Card(
                  //       margin: const EdgeInsets.only(bottom: 30),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(16)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 12, horizontal: 4),
                  //         child: SizedBox(
                  //           width: 350,
                  //           height: 200,
                  //           child: Column(
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         ListTile(
                  //                           minLeadingWidth: 10,
                  //                           leading: const IconTheme(
                  //                             data: IconThemeData(
                  //                               color: Colors.blue,
                  //                             ),
                  //                             child: Icon(Icons.location_on),
                  //                           ),
                  //                           title: Text(
                  //                             route.source,
                  //                             style:
                  //                                 const TextStyle(fontSize: 14),
                  //                           ),
                  //                           subtitle:
                  //                               Text(route.tripStartTime!),
                  //                         ),
                  //                         const SizedBox(
                  //                           height: 12,
                  //                         ),
                  //                         ListTile(
                  //                           minLeadingWidth: 10,
                  //                           leading: const IconTheme(
                  //                             data: IconThemeData(
                  //                               color: Colors.red,
                  //                             ),
                  //                             child: Icon(Icons.location_on),
                  //                           ),
                  //                           title: Text(
                  //                             route.destination,
                  //                             style:
                  //                                 const TextStyle(fontSize: 14),
                  //                           ),
                  //                           subtitle: Text(tripEndTime),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   const VerticalDivider(),
                  //                   Expanded(
                  //                     child: Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       children: [
                  //                         const Text(
                  //                           'Departure in:',
                  //                           style: TextStyle(
                  //                             fontSize: 20,
                  //                           ),
                  //                         ),
                  //                         const SizedBox(
                  //                           height: 8,
                  //                         ),
                  //                         Text.rich(
                  //                           TextSpan(
                  //                             children: [
                  //                               TextSpan(
                  //                                 text: '$remainingTime',
                  //                                 style: const TextStyle(
                  //                                     fontSize: 20,
                  //                                     fontWeight:
                  //                                         FontWeight.bold),
                  //                               ),
                  //                               const TextSpan(
                  //                                 text: 'mins',
                  //                                 style:
                  //                                     TextStyle(fontSize: 12),
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         const SizedBox(
                  //                           height: 8,
                  //                         ),
                  //                         Text(
                  //                             'Travel time: ${route.tripDuration}'),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Expanded(
                  //                 child: Row(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.center,
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   children: [
                  //                     Text(route.name),
                  //                     const SizedBox(
                  //                       width: 20,
                  //                     ),
                  //                     const Icon(
                  //                       Icons.bus_alert,
                  //                       color: Colors.lightBlue,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                }),
          ),
        ),
      ],
    );
  }
}
