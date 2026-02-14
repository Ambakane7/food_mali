import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Pages/food_page.dart';
import '../model/food.dart';
import '../model/restaurants.dart';
import 'cart_page.dart';


class RestaurantPage extends StatelessWidget {
  final String restaurantName;

  const RestaurantPage({super.key, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    final allFoods = Provider.of<Restaurants>(context).menu;
    final filteredFoods = allFoods
        .where((food) => food.restaurantName == restaurantName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName, style: TextStyle(color: Colors.deepOrange, fontSize: 30, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4)]),),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Consumer<Restaurants>(
            builder: (context, restaurant, child) {
              final cartCount = restaurant.getTotalItemCount();

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -6,
                        right: 3,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          itemCount: filteredFoods.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 par ligne
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final food = filteredFoods[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => FoodPage(food: food)));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          food.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text("${food.price.toStringAsFixed(0)} FCFA"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
