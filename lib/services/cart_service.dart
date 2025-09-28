import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';

class CartService {
  // static const String baseUrl = "http://10.0.2.2/pizzahubapp/";

  static Future<List<Map<String, dynamic>>> fetchCartItems(int userId) async {
    final response = await http.get(
      Uri.parse("${baseUrl}showCart.php?userid=$userId"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  static Future<bool> updateQuantity(int cartItemId, int newQuantity) async {
    final response = await http.post(
      Uri.parse("${baseUrl}updateQuantity.php"),
      body: {
        'cartitemid': cartItemId.toString(),
        'quantity': newQuantity.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['status'] == 'success';
    }
    return false;
  }

  static Future<bool> removeFromCart(int userId, int cartItemId) async {
    final url = Uri.parse("${baseUrl}removeFromCart.php");
    final response = await http.post(
      url,
      body: {'userid': userId.toString(), 'cartitemid': cartItemId.toString()},
    );

    final data = jsonDecode(response.body);
    return data['status'] == 'success';
  }

  static Future<Map<String, dynamic>> addToCart(int userId, int pizzaId) async {
    final url = Uri.parse("${baseUrl}addToCart.php");
    final response = await http.post(
      url,
      body: {'userid': userId.toString(), 'pizzaid': pizzaId.toString()},
    );

    final data = jsonDecode(response.body);
    return {'status': data['status'], 'message': data['message']};
  }

  static Future<Map<String, dynamic>> addComboToCart(
    int userId,
    int catId,
  ) async {
    final url = Uri.parse('${baseUrl}addToCart2.php');

    final response = await http.post(
      url,
      body: {'userid': userId.toString(), 'catid': catId.toString()},
    );

    final data = jsonDecode(response.body);
    return {'status': data['status'], 'message': data['message']};
  }

  static Future<Map<String, dynamic>> placeOrder({
    required String userId,
    required int paymentId,
    required String addressId,
    required double totalPrice,
    required double finalAmount,
  }) async {
    final url = Uri.parse('${baseUrl}place_order.php');

    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'paymentid': paymentId.toString(),
        'addressid': addressId,
        'totalprice': totalPrice.toStringAsFixed(2),
        'finalamount': finalAmount.toStringAsFixed(2),
      },
    );

    final data = jsonDecode(response.body);
    return data; // {'status': 'success', 'message': '...', 'data': {...}}
  }
}
