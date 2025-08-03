import 'package:flutter/material.dart';
import '../../screens/pizza_list/category_button.dart';
import '../../models/category_model.dart';
import '../../models/pizza_model.dart';
import '../../services/pizza_service.dart';
import 'pizza_card.dart';

class PizzaListScreen extends StatefulWidget {
  final String categoryId;
  final List<PizzaCategory> allCategories;

  const PizzaListScreen({
    super.key,
    required this.categoryId,
    required this.allCategories,
  });

  @override
  State<PizzaListScreen> createState() => _PizzaListScreenState();
}

class _PizzaListScreenState extends State<PizzaListScreen> {
  late int selectedCategoryId;
  late Future<List<Pizza>> getPizzaList;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = int.parse(widget.categoryId);
    getPizzaList = PizzaService.fetchPizzas(int.parse(widget.categoryId));
  }

  void fetchByCategory(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      getPizzaList = PizzaService.fetchPizzas(categoryId);
    });
  }

  PizzaCategory? get selectedCategory {
    return widget.allCategories.firstWhere(
      (cat) => cat.catid == selectedCategoryId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Our Menu",
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.allCategories.map((category) {
                  return CategoryButton(
                    label: category.catname,
                    isSelected: selectedCategoryId == category.catid,
                    onTap: () => fetchByCategory(category.catid),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: FutureBuilder<List<Pizza>>(
              future: getPizzaList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No pizzas found."));
                }

                final pizzas = snapshot.data!;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: pizzas.length,
                        itemBuilder: (context, index) {
                          final category = widget.allCategories.firstWhere(
                                (cat) => cat.catid == pizzas[index].catid,
                          );
                          return PizzaCard(pizza: pizzas[index], category: category);
                        },
                      ),
                    ),

                    // ✅ Show "Add to Cart" only if combo and items exist
                    if (selectedCategory?.iscombo == 1 && pizzas.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 18, bottom: 22, right: 18),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Add combo items to cart
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
