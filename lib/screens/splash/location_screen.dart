import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/location_prefrences.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import '../../utils/user_preferences.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isForward = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 🟠 Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // 🟡 Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // 🟢 Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // ✅ Save to LocationPreferences
    await LocationPreferences.saveLocation(position.latitude, position.longitude);
    debugPrint('Latitude: ${position.latitude}');
    debugPrint('Longitude: ${position.longitude}');

    // 🔵 Check login state
    String? userId = await UserPreferences.getUserId();

    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 1)); // small delay for UX

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🗺️ Background Image
          Image.asset(
            'assets/icons/locationbg.jpg',
            fit: BoxFit.cover,
          ),

          // 🌍 Center Location Icon + Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🌟 Continuous Scaling Animation
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: _isForward ? 0.6 : 1.2,
                  end: _isForward ? 1.2 : 0.6,
                ),
                duration: const Duration(milliseconds: 1200),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                onEnd: () {
                  // 🔁 Reverse the direction for infinite loop
                  if (mounted) {
                    setState(() {
                      _isForward = !_isForward;
                    });
                  }
                },
                child: Image.asset(
                  'assets/icons/location.png',
                  width: 130,
                  height: 130,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Setting Your Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
