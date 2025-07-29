import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pizza_model.dart';

class PizzaService {
  static const String baseUrl = 'http://10.0.2.2/pizzahubapp/viewPizzaList.php';
  // static const String baseUrl2 = 'http://10.104.169.30/pizzahubapp/viewPizzaList.php';

  static Future<List<Pizza>> fetchPizzas(int categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {'categoryId': categoryId.toString()},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // ✅ Check for status and extract 'data'
      if (body['status'] == 'success' && body['data'] is List) {
        return List<Pizza>.from(
          (body['data'] as List).map((item) => Pizza.fromJson(item)),
        );
      } else {
        print("API returned error: ${body['message']}");
        return [];
      }
    } else {
      throw Exception('Failed to load pizzas');
    }
  }
}