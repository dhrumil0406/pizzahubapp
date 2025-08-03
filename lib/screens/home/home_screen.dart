import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'filter_button.dart';
import 'category_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categoryLabels = ['All', 'Veg', 'Non-Veg', 'Combo'];
  int selectedCategoryId = 0;
  bool isLoading = true;
  List<PizzaCategory> pizzaCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories(0);
  }

  void fetchCategories(int categoryId) async {
    setState(() {
      isLoading = true;
      selectedCategoryId = categoryId;
    });
    try {
      final categories = await CategoryService.fetchPizzaCategories(categoryId);
      print("Fetched ${categories.length} categories");
      setState(() {
        pizzaCategories = categories;
      });
    } catch (e) {
      // Optionally handle error
      print("Error fetching categories: $e"); // Optional debug
    }
    setState(() => isLoading = false);
  }

  int getCategoryIdFromLabel(String label) {
    switch (label) {
      case 'Veg':
        return 1;
      case 'Non-Veg':
        return 2;
      case 'Combo':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: [
                'assets/images/b1.png',
                'assets/images/b2.png',
                'assets/images/b3.png',
              ].map((imagePath) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text("Categories",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: categoryLabels.map((label) {
                    int id = getCategoryIdFromLabel(label);
                    return FilterButton(
                      label: label,
                      isSelected: selectedCategoryId == id,
                      onTap: () => fetchCategories(id),
                    );
                  }).toList(),
                ),
              ),
            ),
            GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: pizzaCategories.length,
              itemBuilder: (context, index) =>
                  PizzaCard(category: pizzaCategories[index], allCategories: pizzaCategories),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
