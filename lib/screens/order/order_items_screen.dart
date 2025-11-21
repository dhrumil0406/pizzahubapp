import 'package:flutter/material.dart';
import '../../utils/api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/order_service.dart';
import '../../models/order_items_model.dart';

class OrderItemsScreen extends StatefulWidget {
  final String orderId;

  const OrderItemsScreen({super.key, required this.orderId});

  @override
  State<OrderItemsScreen> createState() => _OrderItemsScreenState();
}

class _OrderItemsScreenState extends State<OrderItemsScreen> {
  late Future<List<OrderItem>> _orderItemsFuture;

  @override
  void initState() {
    super.initState();
    _orderItemsFuture = OrderService.fetchOrderItems(widget.orderId);
  }

  Future<void> _downloadInvoice() async {
    final url = Uri.parse("$baseUrl2/order-download/${widget.orderId}");

    try {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // Always open in browser
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error invoice launching: $e")));
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
          "Order Items",
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'amerika',
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Order ID + Download button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: ${widget.orderId}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _downloadInvoice,
                  icon: const Icon(
                    Icons.file_download,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Invoice",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, color: Colors.black12),

          // 🔹 List of items
          Expanded(
            child: FutureBuilder<List<OrderItem>>(
              future: _orderItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No items found for this order.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  final items = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item.iscombo == 1) {
                        // check if this combo already shown
                        final isFirstCombo =
                            items.indexWhere(
                              (i) => i.iscombo == 1 && i.catid == item.catid,
                            ) ==
                            index;

                        // only render card for the first occurrence
                        if (isFirstCombo) {
                          return _buildComboCard(item, items);
                        } else {
                          return const SizedBox.shrink(); // skip duplicates
                        }
                      } else {
                        return _buildSimpleCard(item);
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Simple Pizza Card
  Widget _buildSimpleCard(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "$baseUrl/pizzaimages/${item.pizzaimage}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.pizzaname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Price: ₹${item.pizzaprice}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    "Discounted: ₹${item.discountedPrice}",
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Qty: ${item.quantity}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Combo Card (groups pizzas under same combo)
  Widget _buildComboCard(OrderItem combo, List<OrderItem> allItems) {
    final comboPizzas = allItems
        .where((i) => i.iscombo == 1 && i.catid == combo.catid)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "$baseUrl/catimages/${combo.catimage}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        combo.catname ?? "Combo",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Combo Price: ₹${combo.comboprice}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Discounted: ₹${combo.discountedPrice}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Qty: ${combo.quantity}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, color: Colors.black26),
            ...comboPizzas.map(
              (pizza) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "🍕 ${pizza.pizzaname}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
