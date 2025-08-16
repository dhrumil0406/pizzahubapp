import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/api.dart';  // <-- baseUrl is here

class UserService {
  static const String url = '${baseUrl}fetchUserData.php';

  static Future<User?> fetchUser(int userId) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final response = await http.post(
      Uri.parse(url),
      body: {'userid': userId.toString()},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['status'] == 'success' && body['data'] is List && body['data'].isNotEmpty) {
        return User.fromJson(body['data'][0]);
      } else {
        print("API error: ${body['message']}");
        return null;
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
