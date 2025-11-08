import 'package:flutter/material.dart';
import '../../../services/order_service.dart';
import '../../../models/order_items_model.dart';

class OrderItemsCard extends StatefulWidget {
  final String orderId;

  const OrderItemsCard({super.key, required this.orderId});

  @override
  State<OrderItemsCard> createState() => _OrderItemsCardState();
}

class _OrderItemsCardState extends State<OrderItemsCard> {
  late Future<List<OrderItem>> _orderItemsFuture;

  @override
  void initState() {
    super.initState();
    _orderItemsFuture = OrderService.fetchOrderItems(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderItem>>(
      future: _orderItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
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
          return Container(
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
                  "Order Items",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item.iscombo == 1) {
                        final isFirstCombo =
                            items.indexWhere(
                              (i) => i.iscombo == 1 && i.catid == item.catid,
                            ) ==
                            index;

                        return isFirstCombo
                            ? _buildComboCard(item, items)
                            : const SizedBox.shrink();
                      } else {
                        return _buildSimpleCard(item);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
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
              child: Image.asset(
                "assets/pizzaimages/${item.pizzaimage}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/default_pizza.png",
                  width: 80,
                  height: 80,
                ),
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

  // 🔹 Combo Card
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
                  child: Image.asset(
                    "assets/catimages/${combo.catimage}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/default_combo.png",
                      width: 80,
                      height: 80,
                    ),
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
