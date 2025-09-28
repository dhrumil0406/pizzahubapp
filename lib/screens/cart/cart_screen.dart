import 'package:flutter/material.dart';
import '../../screens/order/orders_screen.dart';
import '../../services/address_service.dart';
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

  // New state for selections & placing status
  String? _selectedAddressId;
  String? _selectedAddressText;
  String? _selectedPaymentMethod;
  bool _isPlacingOrder = false;

  // Addresses fetched from API
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoadingAddresses = false;

  final List<String> _paymentMethods = ['Cash', 'Card', 'UPI'];

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    userId = await UserPreferences.getUserId();

    if (userId != null) {
      await loadCartItems();
      await loadAddresses(); // fetch user addresses
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

  // New: load addresses from API
  Future<void> loadAddresses() async {
    if (userId == null) return;
    setState(() => _isLoadingAddresses = true);

    try {
      final fetched = await AddressService.fetchAddresses(int.parse(userId!));
      setState(() {
        _addresses = fetched;
      });
    } catch (e) {
      print("Error fetching addresses: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load addresses")));
    } finally {
      if (mounted) setState(() => _isLoadingAddresses = false);
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

  double get subtotal => cartItems.fold(0.0, (sum, item) {
    double price = 0;

    if (item['pizza'] != null) {
      price = item['pizza'].pizzaprice;
    } else if (item['combo'] != null) {
      price = item['combo'].comboprice;
    }

    return sum + price * item['quantity'];
  });

  double get totalDiscount => cartItems.fold(0.0, (sum, item) {
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

  // --- New helper methods for selection UI ---
  Future<void> _showAddressSelector(bool tablet) async {
    if (_isLoadingAddresses) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Loading addresses, please wait...")),
      );
      return;
    }

    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('Select Delivery Address')),
              if (_addresses.isEmpty)
                const ListTile(
                  title: Text("No addresses found"),
                  subtitle: Text("Please add a new address"),
                )
              else
                ..._addresses.map((addr) {
                  // Build formatted string from API fields
                  final formattedAddress =
                      "${addr["name"] ?? ""}, "
                              "${addr["apartmentNo"] ?? ""} "
                              "${addr["buildingName"] ?? ""}, "
                              "${addr["streetArea"] ?? ""}, "
                              "${addr["city"] ?? ""}"
                          .trim()
                          .replaceAll(RegExp(r'\s+'), ' ');

                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(formattedAddress),
                    subtitle: addr["addressType"] != null
                        ? Text(addr["addressType"])
                        : null,
                    onTap: () => Navigator.of(
                      context,
                    ).pop({'id': addr['addressid'], 'address': formattedAddress}),
                  );
                }),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add new address'),
                onTap: () {
                  Navigator.of(context).pop(null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add address flow (implement)'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedAddressId = picked['id'].toString();
        _selectedAddressText = picked['address'];
      });
    }
  }

  Future<void> _showPaymentSelector(bool tablet) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('Choose Payment Method')),
              ..._paymentMethods.map((m) {
                return ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text(m),
                  onTap: () => Navigator.of(context).pop(m),
                );
              }),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedPaymentMethod = picked;
      });
    }
  }

  // The Place Order action (currently simulated). Replace the internals with your API call.
  Future<void> _placeOrder() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cart is empty")));
      return;
    }
    if (_selectedAddressId == null || _selectedAddressText == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select delivery address")),
      );
      return;
    }
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select payment method")),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // TODO: Replace the simulated delay with your real order API call.
      // Example: await CartService.placeOrder(userId, payload)
      await Future.delayed(const Duration(seconds: 2));

      int paymentId;
      switch (_selectedPaymentMethod) {
        case 'Cash':
          paymentId = 1;
          break;
        case 'Card':
          paymentId = 2;
          break;
        case 'UPI':
          paymentId = 3;
          break;
        default:
          paymentId = 1;
      }

      final response = await CartService.placeOrder(
        userId: userId!,
        paymentId: paymentId,
        addressId: _selectedAddressId!,
        totalPrice: subtotal,
        finalAmount: finalTotal,
      );

      if (response['status'] == 'success') {
        // Clear cart locally
        setState(() => cartItems.clear());

        // ✅ If you want to show PDF link
        final pdfUrl = response['data']['pdf_url'];
        print("Invoice PDF: $pdfUrl");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully!")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Failed to place order")),
        );
      }
    } catch (e) {
      print('Place order error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to place order")));
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  Widget _selectionCard({
    required IconData leading,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool tablet,
  }) {
    // Adjusted to match item-card appearance (white background, rounded, similar shadow)
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tablet ? 20 : 14,
          vertical: tablet ? 18 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white, // match item card color per request
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2),
                ],
              ),
              child: Icon(leading, color: Colors.orange),
            ),
            SizedBox(width: tablet ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: tablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: tablet ? 15 : 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: tablet ? 18 : 14,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
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
                  bottom: tablet
                      ? 120
                      : 100, // make room for fixed bottom button
                  left: tablet ? 16 : 12,
                  right: tablet ? 16 : 12,
                ),
                children: [
                  // NOTE: selection boxes removed from top (moved into cartSummary after Total)
                  // Cart items
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

                  SizedBox(height: tablet ? 18 : 16),
                  // note: Place Order button moved to fixed bottomNavigationBar
                  SizedBox(height: tablet ? 8 : 8),
                ],
              ),

        // Fixed Place Order button at bottom
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            height: tablet ? 72 : 56,
            child: ElevatedButton(
              onPressed:
              (cartItems.isNotEmpty &&
                  _selectedAddressId != null &&
                  _selectedPaymentMethod != null &&
                  !_isPlacingOrder)
                  ? () => _showPlaceOrderDialog(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: tablet ? 18 : 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 6,
              ),
              child: _isPlacingOrder
                  ? SizedBox(
                      height: tablet ? 24 : 18,
                      width: tablet ? 24 : 18,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: tablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
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
    return Column(
      children: [
        // Total summary card (unchanged)
        Container(
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
        ),

        SizedBox(height: tablet ? 18 : 12),

        // Selection boxes OUTSIDE total box
        _selectionCard(
          leading: Icons.location_on,
          title: 'Select Delivery Address',
          subtitle: _selectedAddressText ?? 'Choose delivery address',
          onTap: () => _showAddressSelector(tablet),
          tablet: tablet,
        ),

        SizedBox(height: tablet ? 14 : 10),

        _selectionCard(
          leading: Icons.payment,
          title: 'Payment Method',
          subtitle:
              _selectedPaymentMethod ?? 'Choose payment method (Cash/Card/UPI)',
          onTap: () => _showPaymentSelector(tablet),
          tablet: tablet,
        ),
      ],
    );
  }

  // place order dialog

  void _showPlaceOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background image / card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/popup_bg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Confirm Order",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Are you sure you want to place this order?.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(height: 25),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // close dialog
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context); // close dialog first
                              await _placeOrder(); // then place order
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "Place Order",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
