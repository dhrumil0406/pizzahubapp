import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
// import 'screens/home/home_screen.dart';

void main() {
  runApp(const PizzaHubApp());
}

class PizzaHubApp extends StatelessWidget {
  const PizzaHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}