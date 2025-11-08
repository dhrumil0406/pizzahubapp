import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';
import '../models/order_items_model.dart';
import '../utils/api.dart'; // <-- baseUrl is here

class OrderService {
  static const String fetchOrderUrl = "${baseUrl}fetchOrders.php";
  static const String fetchLastOrderUrl = "${baseUrl}fetchLastOrder.php";
  static const String fetchOrderItemsUrl = "${baseUrl}fetchOrderItems.php";
  static const String fetchDeliveryDetailsUrl =
      "${baseUrl}fetchDeliveryDetails.php";

  // Fetch orders for a user
  static Future<List<Order>> fetchOrders(int userId) async {
    final response = await http.post(
      Uri.parse(fetchOrderUrl),
      body: {'userid': userId.toString()},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['status'] == 'success' && body['data'] is List) {
        return (body['data'] as List)
            .map((json) => Order.fromJson(json))
            .toList();
      } else {
        throw Exception("API Error: ${body['message']}");
      }
    } else {
      throw Exception("Failed to fetch orders");
    }
  }

  // ✅ Fetch only the last (most recent) order for a user
  static Future<Order?> fetchLastOrder(int userId) async {
    final response = await http.post(
      Uri.parse(fetchLastOrderUrl),
      body: {'userid': userId.toString()},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['status'] == 'success' && body['data'] != null) {
        return Order.fromJson(body['data']); // Single object
      } else {
        return null; // No recent order
      }
    } else {
      throw Exception("Failed to fetch last order");
    }
  }

  // ✅ Fetch items for a specific order (orderid is alphanumeric like "O2944")
  static Future<List<OrderItem>> fetchOrderItems(String orderId) async {
    final response = await http.get(
      Uri.parse("$fetchOrderItemsUrl?orderid=$orderId"),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['status'] == 'success' && body['data'] is List) {
        return (body['data'] as List)
            .map((json) => OrderItem.fromJson(json))
            .toList();
      } else {
        throw Exception("API Error: ${body['message']}");
      }
    } else {
      throw Exception("Failed to fetch order items");
    }
  }

  static Future<Map<String, dynamic>> fetchDeliveryDetails(
    String orderId,
  ) async {
    final response = await http.get(
      Uri.parse("$fetchDeliveryDetailsUrl?orderid=$orderId"),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body['status'] == 'success' &&
          body['data'] is List &&
          body['data'].isNotEmpty) {
        return body['data'][0]; // Return the first record
      } else {
        throw Exception("No delivery details found.");
      }
    } else {
      throw Exception("Failed to fetch delivery details");
    }
  }
}
