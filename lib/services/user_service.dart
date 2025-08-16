import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/api.dart'; // <-- baseUrl is here

class UserService {
  static const String fetchUrl = '${baseUrl}fetchUserData.php';
  static const String updateUrl = '${baseUrl}updateUser.php';

  // Existing fetchUser (unchanged)
  static Future<User?> fetchUser(int userId) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final response = await http.post(
      Uri.parse(fetchUrl),
      body: {'userid': userId.toString()},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['status'] == 'success' &&
          body['data'] is List &&
          body['data'].isNotEmpty) {
        return User.fromJson(body['data'][0]);
      } else {
        print("API error: ${body['message']}");
        return null;
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // 🔹 New function for updating user
  static Future<String> updateUser({
    required int userId,
    required String username,
    required String firstname,
    required String lastname,
    required String email,
    required String phoneno,
    String? password, // optional
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final response = await http.post(
      Uri.parse(updateUrl),
      body: {
        'userid': userId.toString(),
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phoneno': phoneno,
        if (password != null && password.isNotEmpty) 'password': password,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['message'] ?? "Unknown error";
    } else {
      throw Exception('Failed to update user');
    }
  }
}
