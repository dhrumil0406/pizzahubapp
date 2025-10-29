import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../utils/user_preferences.dart';

class ContactService {
  static const String _sendContactUrl = '${baseUrl}contactus.php';
  static const String _fetchUserContactUrl = '${baseUrl}fetchUserContacts.php';
  static const String _fetchReplyUrl = '${baseUrl}fetchContactReply.php';

  static Future<Map<String, dynamic>> sendContact({
    required String orderId,
    required String email,
    required String phoneNo,
    required String password,
    required String message,
  }) async {
    try {
      final userId = await UserPreferences.getUserId();

      if (userId == null) {
        return {
          'status': 'error',
          'message': 'User not logged in. Please login again.',
        };
      }

      final response = await http.post(
        Uri.parse(_sendContactUrl),
        body: {
          'userid': userId,
          'orderid': orderId,
          'email': email,
          'phoneno': phoneNo,
          'password': password,
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          'status': data['status'] ?? 'error',
          'message': data['message'] ?? 'Something went wrong',
        };
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to send contact request: $e',
      };
    }
  }

  // 🔹 Fetch All Contact Messages
  static Future<Map<String, dynamic>> fetchUserContacts() async {
    try {
      final userId = await UserPreferences.getUserId();

      if (userId == null) {
        return {
          'status': 'error',
          'message': 'User not logged in. Please login again.',
        };
      }

      final response = await http.post(
        Uri.parse(_fetchUserContactUrl),
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'status': data['status'] ?? 'error',
          'message': data['message'] ?? '',
          'data': data['data'] ?? [],
        };
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to fetch contacts: $e',
        'data': [],
      };
    }
  }

  // 🔹 Fetch Replies for a Specific Contact
  static Future<Map<String, dynamic>> fetchContactReply({
    required String contactId,
  }) async {
    try {
      final userId = await UserPreferences.getUserId();

      if (userId == null) {
        return {
          'status': 'error',
          'message': 'User not logged in. Please login again.',
          'data': [],
        };
      }

      final response = await http.post(
        Uri.parse(_fetchReplyUrl),
        body: {
          'userid': userId,
          'contactid': contactId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'status': data['status'] ?? 'error',
          'message': data['message'] ?? '',
          'data': data['data'] ?? [],
        };
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to fetch contact replies: $e',
        'data': [],
      };
    }
  }
}
