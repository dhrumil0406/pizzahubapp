import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pizzahub/utils/api.dart';
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
      setState(() {
        pizzaCategories = categories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
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
    // Detect screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600; // Tablet detection

    // Grid settings based on device
    final crossAxisCount = isTablet ? 3 : 2;
    final childAspectRatio = isTablet ? 0.75 : 0.68;
    final carouselHeight = isTablet ? 250.0 : 180.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "PizzaHub",
          style: TextStyle(
            fontSize: isTablet ? 34 : 26,
            fontFamily: 'amerika',
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: IconButton(
              icon: Icon(
                Icons.search,
                size: isTablet ? 30 : 24,
                color: Colors.orange,
              ),
              onPressed: () {},
            ),
          ),
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
                    items:
                        [
                          '$baseUrl/images/b4.png',
                          '$baseUrl/images/b1.png',
                          '$baseUrl/images/b2.png',
                        ].map((imagePath) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                    options: CarouselOptions(
                      height: carouselHeight,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: isTablet ? 0.8 : 0.90,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 10,
                      bottom: 4,
                    ),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: isTablet ? 26 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: pizzaCategories.length,
                    itemBuilder: (context, index) => PizzaCard(
                      category: pizzaCategories[index],
                      allCategories: pizzaCategories,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
