import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../pizza_list/pizza_list.dart';

class PizzaCard extends StatelessWidget {
  final PizzaCategory category;
  final List<PizzaCategory> allCategories;

  const PizzaCard({
    super.key,
    required this.category,
    required this.allCategories
  });

  @override
  Widget build(BuildContext context) {
    print('Image Path: ${category.catimage}');
    return AspectRatio(
      aspectRatio: 0.68,
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 14,
              left: 22,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 10,
                      spreadRadius: 0.1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/catimages/${category.catimage}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (category.discount > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${category.discount.toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)
                  ),
                ),
              ),
            Positioned(
              bottom: 60,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.catname,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    category.catdesc,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PizzaListScreen(categoryId: category.catid.toString(), allCategories: allCategories), // ✅ Pass categoryId
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
