import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/order_service.dart';
import '../../../utils/location_prefrences.dart';

class OrderStatusCard extends StatefulWidget {
  final String orderId;

  const OrderStatusCard({super.key, required this.orderId});

  @override
  State<OrderStatusCard> createState() => _OrderStatusCardState();
}

class _OrderStatusCardState extends State<OrderStatusCard> {
  Map<String, dynamic>? deliveryData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDeliveryData();
  }

  Future<void> fetchDeliveryData() async {
    try {
      final data = await OrderService.fetchDeliveryDetails(widget.orderId);
      setState(() {
        deliveryData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _openLiveLocation() async {
    final double? userLat = await LocationPreferences.getLatitude();
    final double? userLng = await LocationPreferences.getLongitude();

    final double startLat = LocationPreferences.getDefaultLatitude();
    final double startLng = LocationPreferences.getDefaultLongitude();

    try {
      final Uri url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$userLat,$userLng&travelmode=two_wheeler",
      );
      await launchUrl(url, mode: LaunchMode.platformDefault);
    } catch (e) {
      debugPrint("Primary launch failed: $e");

      const String chromePackage = "com.android.chrome";
      final Uri intentUri = Uri.parse(
        "intent://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$userLat,$userLng&travelmode=two_wheeler#Intent;scheme=https;package=$chromePackage;end",
      );

      try {
        await launchUrl(intentUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint("Fallback intent failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to open Google Maps")),
        );
      }
    }
  }

  Widget _buildStatusStep(int stepNumber, String title) {
    final int status = deliveryData?['orderstatus'] ?? 0;

    if (status == 6) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 3, color: Colors.black)),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
              Expanded(child: Container(height: 3, color: Colors.black)),
            ],
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Order Denied",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    bool isCompleted = stepNumber < status;
    bool isActive = stepNumber == status;

    IconData icon;
    switch (stepNumber) {
      case 1:
        icon = Icons.pending_actions;
        break;
      case 2:
        icon = Icons.check_circle;
        break;
      case 3:
        icon = Icons.local_pizza;
        break;
      case 4:
        icon = Icons.local_shipping;
        break;
      case 5:
        icon = Icons.inventory_2;
        break;
      default:
        icon = Icons.circle;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? Colors.orange
                    : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : icon,
                color: isCompleted || isActive ? Colors.white : Colors.black45,
                size: 22,
              ),
            ),
            if (stepNumber != 5)
              Container(width: 3, height: 50, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive || isCompleted ? Colors.orange : Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }
    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Order Info
          Text(
            "Order ID : ${widget.orderId}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text("Tracking ID : ${deliveryData?['trackid'] ?? '-'}"),
          Text("Delivery Boy : ${deliveryData?['deliveryboyname'] ?? '-'}"),
          Text("Contact : ${deliveryData?['deliveryboyphoneno'] ?? '-'}"),
          Text("Estimated Delivery Time : ⏱ ${deliveryData?['deliverytime'] ?? '-'}"),
          Text("Delivery Date : ${deliveryData?['deliverydate'] ?? '-'}"),

          const SizedBox(height: 20),

          // 🔹 Status Steps
          if (deliveryData?['orderstatus'] == 6)
            _buildStatusStep(6, "Order Denied")
          else ...[
            _buildStatusStep(1, "Order Pending"),
            _buildStatusStep(2, "Order Confirmed"),
            _buildStatusStep(3, "Preparing your Order"),
            _buildStatusStep(4, "On the Way"),
            _buildStatusStep(5, "Order Delivered"),
          ],

          const SizedBox(height: 30),

          // 🔹 Live Location Button
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: (deliveryData?['orderstatus'] == 5 ||
                    deliveryData?['orderstatus'] == 6)
                    ? Colors.grey
                    : Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
              onPressed: (deliveryData?['orderstatus'] == 5 ||
                  deliveryData?['orderstatus'] == 6)
                  ? null
                  : _openLiveLocation,
              icon: const Icon(Icons.location_on, color: Colors.white),
              label: const Text(
                "Check Live Location",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
