import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../models/pizza_model.dart';
import '../../services/cart_service.dart';
import 'cart_item_card.dart';

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
          cartItems = items.map((item) => {
            'pizza': Pizza.fromJson(item),
            'quantity': int.parse(item['quantity'].toString()),
            'cartitemid': int.parse(item['cartitemid'].toString()),
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

  double get subtotal => cartItems.fold(
      0, (sum, item) => sum + item['pizza'].pizzaprice * item['quantity']);

  double get totalDiscount => cartItems.fold(
      0,
          (sum, item) =>
      sum +
          (item['pizza'].pizzaprice * item['pizza'].discount / 100) *
              item['quantity']);

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
            ? const Center(child: Text("Your cart is empty."))
            : ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ...List.generate(
              cartItems.length,
                  (index) {
                final item = cartItems[index];
                return CartItemCard(
                  pizza: item['pizza'],
                  quantity: item['quantity'],
                  onAdd: () => incrementQuantity(index),
                  onRemove: () => decrementQuantity(index),
                  onDelete: () => deleteItem(index),
                );
              },
            ),
            const SizedBox(height: 20),
            cartSummary(
              subtotal: subtotal,
              totalDiscount: totalDiscount,
              finalTotal: finalTotal,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
