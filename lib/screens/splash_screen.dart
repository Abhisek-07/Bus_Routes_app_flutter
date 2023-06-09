import 'package:bus_routes/screens/routes.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset(
            'assets/images/bus.png',
            width: 150,
            height: 84,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Bus Routes',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      nextScreen: RoutesScreen(),
      splashIconSize: 150,
      splashTransition: SplashTransition.slideTransition,
      duration: 2000,
    );
  }
}
