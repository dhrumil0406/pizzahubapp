import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../screens/home/home_screen.dart';
import '../../models/pizza_model.dart';
import '../../services/cart_service.dart';
import 'cart_item_card.dart';
import 'combo_cart_item_card.dart';
import '../../utils/user_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  String? userId; // Nullable until loaded

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    userId = await UserPreferences.getUserId();

    if (userId != null) {
      await loadCartItems();
    }
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  Future<void> loadCartItems() async {
    try {
      final items = await CartService.fetchCartItems(int.parse(userId!));
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

    bool success = await CartService.updateQuantity(
      current['cartitemid'],
      newQty,
    );
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

      bool success = await CartService.updateQuantity(
        current['cartitemid'],
        newQty,
      );
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

    bool success = await CartService.removeFromCart(
      int.parse(userId!),
      cartItemId,
    );
    if (success) {
      setState(() {
        cartItems.removeAt(index);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item removed")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove item from cart")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

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
            margin: EdgeInsets.only(left: tablet ? 16 : 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.orange,
                size: tablet ? 26 : 24,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
          ),
          title: Text(
            "Pizza Cart",
            style: TextStyle(
              fontSize: tablet ? 32 : 26,
              fontFamily: 'amerika',
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: cartItems.isEmpty
            ? Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: tablet ? 22 : 16),
                ),
              )
            : ListView(
                padding: EdgeInsets.only(
                  bottom: tablet ? 32 : 24,
                  left: tablet ? 10 : 4,
                  right: tablet ? 10 : 4,
                ),
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

                  SizedBox(height: tablet ? 20 : 12),

                  cartSummary(
                    subtotal: subtotal,
                    totalDiscount: totalDiscount,
                    finalTotal: finalTotal,
                    tablet: tablet,
                  ),

                  SizedBox(height: tablet ? 32 : 24),
                ],
              ),
      ),
    );
  }

  Widget cartSummary({
    required double subtotal,
    required double totalDiscount,
    required double finalTotal,
    required bool tablet,
  }) {
    return Container(
      padding: EdgeInsets.all(tablet ? 24 : 16),
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _summaryRow("Subtotal", subtotal, tablet: tablet),
          _summaryRow("Delivery Charges", 0, tablet: tablet),
          _summaryRow("Total Discount", totalDiscount, tablet: tablet),
          const Divider(height: 24, thickness: 1),
          _summaryRow("Total", finalTotal, isBold: true, tablet: tablet),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String title,
    double value, {
    bool isBold = false,
    required bool tablet,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: tablet ? 18 : 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black : Colors.black87,
              fontSize: tablet ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
