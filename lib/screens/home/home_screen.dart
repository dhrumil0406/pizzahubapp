import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'category_button.dart';
import 'pizza_card.dart';
import 'bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Veg', 'Non-Veg', 'Combo'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("PizzaHub",
            style: TextStyle(
                fontSize: 26,
                fontFamily: 'amerika',
                color: Colors.orange,
                fontWeight: FontWeight.bold)),
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
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80), // So content isn't hidden behind bottom bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/About.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    CategoryButton(label: categories[index]),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 800,
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6, // Total number of PizzaCards
                itemBuilder: (context, index) => const PizzaCard(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
