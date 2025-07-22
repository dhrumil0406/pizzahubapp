import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
            _iconWithContainer(Icons.home, Colors.orange),
            _iconWithContainer(Icons.receipt_long, Colors.black87),
            _iconWithContainer(Icons.shopping_cart, Colors.black87),
            _iconWithContainer(Icons.person, Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _iconWithContainer(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

}
