import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../utils/user_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await UserPreferences.logoutUserData(); // clear userid
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
        return false; // block default back button
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.orange),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                );
              },
            ),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'amerika',
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.orange),
                onPressed: () {},
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Profile Screen",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
