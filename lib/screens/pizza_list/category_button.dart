import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.white,
          borderRadius: BorderRadius.circular(30), // Full rounded
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
