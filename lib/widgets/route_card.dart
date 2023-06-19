import 'package:bus_routes/widgets/route_details_alert.dart';
import 'package:flutter/material.dart';
import 'package:bus_routes/models/bus_routes.dart';

class RouteCard extends StatelessWidget {
  const RouteCard(
      {super.key,
      required this.route,
      required this.remainingTime,
      required this.tripEndTime});

  final BusRoute route;
  final int remainingTime;
  final String tripEndTime;

  @override
  Widget build(BuildContext context) {
    if (remainingTime <= 0 || route.tripStartTime == null) {
      return Container();
    }

    // widget for route card
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => RouteDetailsAlert(route: route),
        );
      },
      child: Center(
        child: Card(
          margin: const EdgeInsets.only(bottom: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                              subtitle: Text(route.tripStartTime!),
                            ),
                            const SizedBox(
                              height: 12,
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
                                    text: '$remainingTime',
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
      ),
    );
  }
}
