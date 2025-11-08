import 'package:flutter/material.dart';
import '../../../utils/user_preferences.dart';
import '../../../services/order_service.dart';
import 'order_card.dart';
import 'order_items_card.dart';
import 'order_status_card.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Map<String, dynamic>? latestOrder;
  Map<String, dynamic>? deliveryData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchLatestOrder();
  }

  Future<void> _fetchLatestOrder() async {
    try {
      final userIdStr = await UserPreferences.getUserId();
      final userId = int.tryParse(userIdStr ?? "0") ?? 0;

      if (userId == 0) {
        setState(() {
          error = "User not logged in.";
          isLoading = false;
        });
        return;
      }

      final lastOrder = await OrderService.fetchLastOrder(userId);
      if (lastOrder == null) {
        setState(() {
          error = "No recent order found.";
          isLoading = false;
        });
        return;
      }

      final status = await OrderService.fetchDeliveryDetails(lastOrder.orderid);
      setState(() {
        latestOrder = lastOrder.toJson();
        deliveryData = status;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.orange,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Track Order",
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'amerika',
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : error != null
          ? Center(
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                children: [
                  // 🔹 Order Summary
                  SizedBox(
                    child: OrderCard(
                      orderId: latestOrder!['orderid'].toString(),
                      phone: latestOrder!['phoneno'] ?? "-",
                      address: latestOrder!['address'] ?? "-",
                      orderDate: latestOrder!['orderdate'].toString(),
                      paymentMethod: latestOrder!['paymentmethod'].toString(),
                      amount:
                          "₹${latestOrder!['discountedtotalprice'].toString()}",
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Ordered Items
                  SizedBox(
                    height: 360,
                    child: OrderItemsCard(
                      orderId: latestOrder!['orderid'].toString(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Basic Order Status Summary
                  Container(
                    width: double.infinity,
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
                        const Text(
                          "Order Status",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Text(
                          "Delivery Boy: ${deliveryData?['deliveryboyname'] ?? '-'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Phone: ${deliveryData?['deliveryboyphoneno'] ?? '-'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Delivery Date: ${deliveryData?['deliverydate'] ?? '-'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Status: ${_getStatusText(deliveryData?['orderstatus'])}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 🔹 View Full Status (Bottom Sheet)
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                builder: (_) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.9,
                                    maxChildSize: 0.95,
                                    minChildSize: 0.6,
                                    builder: (context, scrollController) {
                                      return SingleChildScrollView(
                                        controller: scrollController,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 20,
                                          ),
                                          child: OrderStatusCard(
                                            orderId: latestOrder!['orderid']
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.local_shipping,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "View Full Status",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 1:
        return "Pending";
      case 2:
        return "Confirmed";
      case 3:
        return "Preparing";
      case 4:
        return "On the Way";
      case 5:
        return "Delivered";
      case 6:
        return "Denied";
      default:
        return "Unknown";
    }
  }
}
