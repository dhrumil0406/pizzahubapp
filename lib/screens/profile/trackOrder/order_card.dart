import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final url = Uri.parse("http://10.107.214.98:8080/order-download/$orderId");
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error invoice launching: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ full width
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
          // 🔹 Title Row (Order ID + Invoice Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Details",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.file_download, color: Colors.orange),
                  onPressed: () => _downloadInvoice(orderId, context),
                ),
              ),
            ],
          ),
          const Divider(),

          const SizedBox(height: 8),

          // 🔹 Order ID
          Row(
            children: [
              const Icon(Icons.tag, size: 20, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                "Order ID: $orderId",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Phone
          Row(
            children: [
              const Icon(Icons.phone, size: 20, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                phone,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 20, color: Colors.orange),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Order Date
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                "Order On: $orderDate",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Payment Method
          Row(
            children: [
              const Icon(Icons.payment, size: 20, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                'Payment: ${paymentMethod == "1" ? "Cash On Delivery" : paymentMethod == "2" ? "Card" : "UPI"}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 💰 Price
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
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
          ),
        ],
      ),
    );
  }
}
