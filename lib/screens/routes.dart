import 'package:bus_routes/models/bus_routes.dart';
import 'package:bus_routes/widgets/routes_list.dart';
import 'package:flutter/material.dart';
import 'package:bus_routes/service/api_service.dart';

class RoutesScreen extends StatelessWidget {
  RoutesScreen({super.key});

  final apiService = ApiService();

  // Here we get the http request data using a future builder and handle its states & pass the data to routes list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 200,
            child: AppBar(
              centerTitle: true,
              title: const Text('Routes'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
              child: FutureBuilder(
                  future: apiService.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      List<BusRoute> busRoutes = snapshot.data!;

                      return RoutesList(busRoutes: busRoutes);
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  })),
        ],
      ),
    );
  }
}
