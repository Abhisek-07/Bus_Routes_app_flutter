import 'package:bus_routes/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_routes/utils/themes.dart';

void main() {
  runApp(const MyApp());
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
