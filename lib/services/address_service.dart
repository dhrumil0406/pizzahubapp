import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';

class AddressService {
  static const String addUrl = '${baseUrl}addAddress.php';
  static const String fetchUrl = '${baseUrl}fetchAddress.php';
  static const String removeUrl = '${baseUrl}removeAddress.php';

  // ✅ Add Address
  static Future<Map<String, dynamic>> addAddress({
    required int userid,
    required String addressType,
    required String name,
    String? apartmentNo,
    String? buildingName,
    String? streetArea,
    required String city,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final body = json.encode({
      'userid': userid,
      'addressType': addressType,
      'name': name,
      'apartmentNo': apartmentNo,
      'buildingName': buildingName,
      'streetArea': streetArea,
      'city': city,
    });

    final response = await http.post(
      Uri.parse(addUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to add address: ${response.statusCode}");
    }
  }

  // ✅ Fetch Address
  static Future<List<Map<String, dynamic>>> fetchAddresses(int userid) async {
    final response = await http.get(
      Uri.parse("$fetchUrl?userid=$userid"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch addresses: ${response.statusCode}");
    }
  }

  // ✅ Remove Address
  static Future<Map<String, dynamic>> removeAddress(int addressid) async {
    final body = json.encode({'addressid': addressid});

    final response = await http.post(
      Uri.parse(removeUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to remove address: ${response.statusCode}");
    }
  }
}
