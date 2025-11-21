import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pizzahub/utils/api.dart';
import 'location_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.4)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _initializeApp();
  }

  // 🟠 Step 1: Initialize app setup
  Future<void> _initializeApp() async {
    await _checkPermissions();
    await Future.delayed(const Duration(seconds: 2)); // show splash for 2s
    await _navigateAfterSplash();
  }

  // 🟢 Step 2: Check permissions
  Future<void> _checkPermissions() async {
    // Request all required permissions together
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.storage,
      Permission.notification,
    ].request();

    // Optional: Handle denied permissions
    statuses.forEach((permission, status) {
      if (status.isDenied || status.isPermanentlyDenied) {
        debugPrint('$permission was denied.');
      }
    });
  }

  // 🔵 Step 3: Navigate after permissions check
  Future<void> _navigateAfterSplash() async {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LocationScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.network(
              '$baseUrl/icons/pizzaHubLogo2.png',
              width: 280,
              height: 280,
            ),
          ),
        ),
      ),
    );
  }
}
