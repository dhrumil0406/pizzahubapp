import 'package:flutter/material.dart';
import '../../utils/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'order_items_screen.dart';
import 'order_status_screen.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String phone;
  final String address;
  final String orderDate;
  final String paymentMethod;
  final String amount;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.phone,
    required this.address,
    required this.orderDate,
    required this.paymentMethod,
    required this.amount,
  });

  Future<void> _downloadInvoice(String orderId, BuildContext context) async {
    final url = Uri.parse("$baseUrl2/order-download/$orderId");

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Always open in browser
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error invoice launching: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // ✅ Make card clickable
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderItemsScreen(orderId: orderId)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔝 Top Row: Order ID + Details Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: $orderId",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.file_download, color: Colors.orange),
                    onPressed: () => _downloadInvoice(orderId, context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 📞 Phone
            Row(
              children: [
                const Icon(Icons.phone, size: 20, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  phone,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 📍 Address
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.orange),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 📅 Order Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  "Order On: $orderDate",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 💳 Payment Method
            Row(
              children: [
                const Icon(Icons.payment, size: 20, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  'Payment: ${paymentMethod == "1"
                      ? "Cash On Delivery"
                      : paymentMethod == "2"
                      ? "Card"
                      : "UPI"}',
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🟠 Order Status Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Colors.orange, width: 1.5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderStatusScreen(orderId: orderId),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.local_shipping,
                    color: Colors.orange,
                    size: 20,
                  ),
                  label: const Text(
                    "Order Status",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                // 💰 Price Container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
