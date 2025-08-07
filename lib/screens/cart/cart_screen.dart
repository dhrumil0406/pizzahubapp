import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../screens/home/home_screen.dart';
import '../../models/pizza_model.dart';
import '../../services/cart_service.dart';
import 'cart_item_card.dart';
import 'combo_cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  int userId = 1; // Replace with your session userId

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final items = await CartService.fetchCartItems(userId);
      if (items.isNotEmpty) {
        setState(() {
          cartItems = items.map((item) {
            if (item['catid'] != null && item['catid'].toString() != 'null') {
              // Item is a combo
              return {
                'combo': PizzaCategory.fromJson(item),
                'quantity': int.parse(item['quantity'].toString()),
                'cartitemid': int.parse(item['cartitemid'].toString()),
                'isCombo': true,
              };
            } else {
              // Item is a pizza
              return {
                'pizza': Pizza.fromJson(item),
                'quantity': int.parse(item['quantity'].toString()),
                'cartitemid': int.parse(item['cartitemid'].toString()),
                'isCombo': false,
              };
            }
          }).toList();
        });
      } else {
        setState(() => cartItems = []);
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }


  void incrementQuantity(int index) async {
    final current = cartItems[index];
    int newQty = current['quantity'] + 1;

    bool success = await CartService.updateQuantity(current['cartitemid'], newQty);
    if (success) {
      setState(() {
        cartItems[index]['quantity'] = newQty;
      });
    }
  }

  void decrementQuantity(int index) async {
    final current = cartItems[index];
    if (current['quantity'] > 1) {
      int newQty = current['quantity'] - 1;

      bool success = await CartService.updateQuantity(current['cartitemid'], newQty);
      if (success) {
        setState(() {
          cartItems[index]['quantity'] = newQty;
        });
      }
    }
  }

  double get subtotal => cartItems.fold(0, (sum, item) {
    double price = 0;

    if (item['pizza'] != null) {
      price = item['pizza'].pizzaprice;
    } else if (item['combo'] != null) {
      price = item['combo'].comboprice;
    }

    return sum + price * item['quantity'];
  });

  double get totalDiscount => cartItems.fold(0, (sum, item) {
    double price = 0;
    double discount = 0;

    if (item['pizza'] != null) {
      price = item['pizza'].pizzaprice ?? 0;
      discount = item['pizza'].discount ?? 0;
    } else if (item['combo'] != null) {
      price = item['combo'].comboprice ?? 0;
      discount = item['combo'].discount ?? 0;
    }

    return sum + ((price * discount / 100) * item['quantity']);
  });


  double get finalTotal => subtotal - totalDiscount;

  void deleteItem(int index) async {
    final cartItemId = cartItems[index]['cartitemid'];

    bool success = await CartService.removeFromCart(userId, cartItemId);
    if (success) {
      setState(() {
        cartItems.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove item from cart")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
        return false;
      },
      child: Scaffold(
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
              icon: const Icon(Icons.arrow_back_ios_new_outlined,
                  color: Colors.orange),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                );
              },
            ),
          ),
          title: const Text(
            "Pizza Cart",
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'amerika',
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: cartItems.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ...cartItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              if (item['isCombo'] == true) {
                final PizzaCategory? combo = item['combo'];
                if (combo == null) return const SizedBox();
                return ComboCartItemCard(
                  category: combo,
                  quantity: item['quantity'],
                  onAdd: () => incrementQuantity(index),
                  onRemove: () => decrementQuantity(index),
                  onDelete: () => deleteItem(index),
                );
              } else {
                final Pizza? pizza = item['pizza'];
                if (pizza == null) return const SizedBox();
                return CartItemCard(
                  pizza: pizza,
                  quantity: item['quantity'],
                  onAdd: () => incrementQuantity(index),
                  onRemove: () => decrementQuantity(index),
                  onDelete: () => deleteItem(index),
                );
              }
            }),

            const SizedBox(height: 12),

            // 🟢 The cart summary widget after all items
            cartSummary(
              subtotal: subtotal,
              totalDiscount: totalDiscount,
              finalTotal: finalTotal,
            ),

            const SizedBox(height: 24), // spacing at bottom
          ],
        ),
      )
    );
  }

  Widget cartSummary({
    required double subtotal,
    required double totalDiscount,
    required double finalTotal,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _summaryRow("Subtotal", subtotal),
          _summaryRow("Delivery Charges", 0),
          _summaryRow("Total Discount", totalDiscount),
          const Divider(height: 24, thickness: 1),
          _summaryRow("Total", finalTotal, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black : Colors.black87,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
