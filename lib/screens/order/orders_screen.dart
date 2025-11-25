import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../services/order_service.dart';
import '../../utils/user_preferences.dart';
import '../../models/orders_model.dart';
import 'order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    // Set a default future first
    _ordersFuture = Future.value([]);
    _loadOrders();
  }

  void _loadOrders() async {
    final userIdStr = await UserPreferences.getUserId();
    final userId = int.tryParse(userIdStr ?? "0") ?? 0;

    if (userId == 0) {
      // Handle case if userId is not set
      setState(() {
        _ordersFuture = Future.error("User not logged in");
      });
      return;
    }

    setState(() {
      _ordersFuture = OrderService.fetchOrders(userId);
    });
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome();
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
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.orange,
                size: 24,
              ),
              onPressed: _navigateToHome,
            ),
          ),
          title: const Text(
            "Your Orders",
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'amerika',
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.orange),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No orders found.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              final orders = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(6),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(
                    orderId: order.orderid,
                    phone: order.phoneno,
                    address: order.address,
                    orderDate: order.orderdate.toString(),
                    paymentMethod: order.paymentmethod.toString(),
                    amount: "₹${order.discountedtotalprice}",
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}