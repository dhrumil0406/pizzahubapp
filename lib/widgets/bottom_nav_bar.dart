import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/order/orders_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/profile/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const OrdersScreen();
        break;
      case 2:
        destination = const CartScreen();
        break;
      case 3:
        destination = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
          (route) => false, // remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _iconWithContainer(Icons.home, currentIndex == 0, () => _navigate(context, 0)),
            _iconWithContainer(Icons.receipt_long, currentIndex == 1, () => _navigate(context, 1)),
            _iconWithContainer(Icons.shopping_cart, currentIndex == 2, () => _navigate(context, 2)),
            _iconWithContainer(Icons.person, currentIndex == 3, () => _navigate(context, 3)),
          ],
        ),
      ),
    );
  }

  Widget _iconWithContainer(IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: selected ? Colors.orange : Colors.black87,
          size: 28,
        ),
      ),
    );
  }
}
