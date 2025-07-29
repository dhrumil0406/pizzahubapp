import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2/pizzahubapp/userIndex.php';
  // static const String baseUrl2 = 'http://10.104.169.30/pizzahubapp/userIndex.php';

  static Future<List<PizzaCategory>> fetchPizzaCategories(int categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {'category_id': categoryId.toString()},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // ✅ Check for status and extract 'data'
      if (body['status'] == 'success' && body['data'] is List) {
        return List<PizzaCategory>.from(
          (body['data'] as List).map((item) => PizzaCategory.fromJson(item)),
        );
      } else {
        // Optional: print error
        print("API returned error: ${body['message']}");
        return [];
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
