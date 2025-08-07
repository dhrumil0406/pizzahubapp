import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/API.dart';

class AuthService {
  // static final String baseUrl = "http://10.0.2.2/pizzahubapp/";

  static Future<String> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulated API response
    final Uri url = Uri.parse('${baseUrl}handleUserLogin.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          // You can also return user data if needed
          print('User data: ${responseData['data']}');
          return responseData['message']; // "Login successful"
        } else {
          return responseData['message']; // "Invalid email or password"
        }
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Login error: $e');
      return 'Error occurred: ${e.toString()}';
    }
  }

  static Future<String> registerUser(Map<String, String> userData) async {
    await Future.delayed(const Duration(seconds: 2));
    final Uri url = Uri.parse('$baseUrl/handleUserSignup.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Signup error: $e');
      return 'Error occurred: ${e.toString()}';
    }
  }
}