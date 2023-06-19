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
    // widget for route card
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(
                    'Bus Details',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Source: ${route.source}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Destination: ${route.destination}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Departure Time: ${route.tripStartTime}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Trip Duration: ${route.tripDuration}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Route: ${route.name}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ));
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
