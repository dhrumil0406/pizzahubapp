import 'package:flutter/material.dart';
import '../../utils/user_preferences.dart';
import '../login/login_screen.dart';
import '../home/home_screen.dart';

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

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    String? userId = await UserPreferences.getUserId();

    if (!mounted) return;

    if (userId != null && userId.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/pizzaHubLogo2.png',
                  width: 280,
                  height: 280,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
