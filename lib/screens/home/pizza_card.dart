import 'package:flutter/material.dart';

class PizzaCard extends StatelessWidget {
  const PizzaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 20,
            child: Image.asset('assets/images/pizza-1.png', width: 120),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('-5%', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          Positioned(
            bottom: 55,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Margherita", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Classic cheese pizza", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.orange,
              ),
              child: const Text("View All", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}
