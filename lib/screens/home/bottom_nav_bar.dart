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
          children: const [
            Icon(Icons.home, color: Colors.orange, size: 35,),
            Icon(Icons.receipt_long, size: 35,),
            Icon(Icons.shopping_cart, size: 35,),
            Icon(Icons.person, size: 35,),
          ],
        ),
      ),
    );
  }
}
