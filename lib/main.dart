import 'package:bus_routes/screens/splash_screen.dart';
import 'package:bus_routes/service/api_service.dart';
import 'package:bus_routes/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:bus_routes/utils/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:bus_routes/utils/utils.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "sortRoutesTask") {
      final container = ProviderContainer();
      var routesList = await container.read(routesProvider.future);
      routesList = sortRoutesByTime(routesList);
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    "sortRoutesTask",
    "sortRoutesTask",
    frequency: const Duration(minutes: 1),
  );
  await NotificationService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      title: 'Bus Routes',
      home: const SplashScreen(),
    );
  }
}
