import 'package:flutter/material.dart';
import 'package:bus_routes/models/bus_routes.dart';

class RouteDetailsAlert extends StatelessWidget {
  const RouteDetailsAlert({super.key, required this.route});

  final BusRoute route;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(
        'Bus Details',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
    );
  }
}
