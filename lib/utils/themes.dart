import 'package:flutter/material.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 117, 255, 144),
  brightness: Brightness.light,
);

final kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 0, 1),
  brightness: Brightness.dark,
);

final lightTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: kColorScheme,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: kColorScheme.primaryContainer),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

final darkTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: kDarkColorScheme,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(backgroundColor: kDarkColorScheme.primaryContainer),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
