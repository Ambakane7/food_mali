import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_mali/components/My_current_location.dart';
import 'package:food_mali/components/my_food_tile.dart';
import 'package:food_mali/components/my_tab_bar.dart';
import 'package:food_mali/model/food.dart';
import 'package:food_mali/model/restaurants.dart';
import 'package:food_mali/Pages/food_page.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../components/my_drawer.dart';
import '../model/cart_page.dart';
import '../model/food.dart';
import '../model/restaurants_page.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;

  String _liveVoiceText = "";
  late SpeechToText _speech;
  bool _isListening = false;

  final List<String> imagePaths = [
    "lib/images/bobohouse/mexico_city.webp",
    'lib/images/burger/chipotle_burger.jpg',
    'lib/images/salads/chiken_salld.jpg',
    "lib/images/kadi/anniv/gateau_anniv_10_25k.jpeg",
    "lib/images/kfc_junior/kfc_12_pcs.jpeg",
  ];

  String firstName = "";
  String lastName = "";
  Future<void> _loadDeliveryAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final address = doc.data()?['address'] ?? '';
      if (address.isNotEmpty) {
        Provider.of<Restaurants>(context, listen: false).updateDeliveryAddress(address);
      }
    }
  }


  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      setState(() {
        firstName = data?['firstName'] ?? "";
        lastName = data?['lastName'] ?? "";
      });
    }
  }

  String searchQuery = "";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);
    _speech = SpeechToText();
    _searchController = TextEditingController();
    _loadUserData();
    _loadDeliveryAddress(); // 🔥 synchronisation au lancement
  }
  void _jumpToCategoryIfNeeded(List<Food> menu, String query) {
    if (query.isEmpty) return;

    try {
      final Food foundFood = menu.firstWhere(
            (food) =>
            food.name.toLowerCase().contains(query.toLowerCase()),
      );

      final int categoryIndex =
      FoodCategory.values.indexOf(foundFood.category);

      if (categoryIndex != _tabController.index) {
        _tabController.animateTo(categoryIndex);
      }
    } catch (e) {
      // Aucun plat trouvé → on ne fait rien
    }
  }

  final Map<String, List<String>> _synonyms = {
    "burger": [
      "hamburger",
      "cheeseburger",
      "burger boeuf",
      "burger poulet",
      "sandwich burger",
    ],
    "poulet": [
      "chicken",
      "poulet grille",
      "poulet grile",
      "poulet frit",
    ],
    "pizza": [
      "piza",
      "pizza fromage",
      "pizza viande",
    ],
    "boisson": [
      "drink",
      "soda",
      "jus",
      "boire",
    ],
    "salade": [
      "salad",
      "salade verte",
      "salade composee",
    ],
  };
  Future<void> _startVoiceSearch() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (_) {
        setState(() => _isListening = false);
        _showVoiceError(
          "La reconnaissance vocale a échoué. Veuillez réessayer.",
        );
      },
    );

    if (!available) {
      _showVoiceError(
        "La reconnaissance vocale n’est pas disponible sur cet appareil.",
      );
      return;
    }

    setState(() => _isListening = true);

    _speech.listen(
      localeId: 'fr_FR',
      onResult: (result) {
        final text = result.recognizedWords.trim();

        // 🔄 TEXTE EN DIRECT (PARTIEL)
        if (!result.finalResult) {
          setState(() {
            _liveVoiceText = text;
            _searchController.text = text;
            _searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: _searchController.text.length),
            );
          });
          return;
        }


        // ✅ TEXTE FINAL
        if (text.isEmpty) {
          _showVoiceError("Aucun mot reconnu.");
          return;
        }

        setState(() {
          _liveVoiceText = "";
          searchQuery = text;
          _isListening = false;
          _searchController.text = text;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        });


        final restaurant =
        Provider.of<Restaurants>(context, listen: false);

        _jumpToCategoryIfNeeded(restaurant.menu, text);
      },
    );

  }
  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }
  void _showVoiceError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâä]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .trim();
  }
  bool _matchWithSynonyms(Food food, String query) {
    if (query.isEmpty) return true;

    final normalizedQuery = _normalize(query);
    final normalizedName = _normalize(food.name);

    // 1️⃣ Match direct
    if (normalizedName.contains(normalizedQuery)) {
      return true;
    }

    // 2️⃣ Match via synonymes
    for (final entry in _synonyms.entries) {
      final key = _normalize(entry.key);

      if (normalizedName.contains(key)) {
        for (final synonym in entry.value) {
          if (_normalize(synonym).contains(normalizedQuery)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();
      setState(() {
        firstName = userDoc.data()?['firstName'] ?? "";
      });
    }
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu
        .where(
          (food) =>
          food.category == category &&
              _matchWithSynonyms(food, searchQuery)

    )
        .toList();
  }

  List<Widget> _buildFoodTabs(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
        itemCount: categoryMenu.length,
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return FoodTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodPage(food: food)),
            ),
            food: food,
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "FoodMali",
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 2)],
            ),
          ),
          actions: [

            Consumer<Restaurants>(
              builder: (context, restaurant, child) {
                final cartCount = restaurant.getTotalItemCount();

                return Padding(
                  padding: const EdgeInsets.all(14.0),
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

          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        drawer: MyDrawer(),
        body: Consumer<Restaurants>(
          builder: (context, restaurant, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {

                        setState(() {
                          searchQuery = query;
                        });

                        final restaurant =
                        Provider.of<Restaurants>(context, listen: false);

                        _jumpToCategoryIfNeeded(restaurant.menu, query);
                      },

                      decoration: InputDecoration(
                        hintText: 'Rechercher un produit...',
                        prefixIcon: const Icon(Icons.search),

                        // 🎤 MICRO À DROITE DANS LE CHAMP
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: Colors.deepOrange,
                            size: 40,
                          ),
                          onPressed: _isListening
                              ? _stopListening
                              : _startVoiceSearch,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 6),
                    child: Text(
                      (firstName.isEmpty)
                          ? "Bonjour..."
                          : "Bonjour $firstName", // ou "Bonjour $firstName $lastName" si tu veux complet
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      ),
                    ),
                  ),


                  MyCurrentLocation(),
                  const SizedBox(height: 8),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      aspectRatio: 16 / 9,
                    ),
                    items: imagePaths.map((path) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          path,
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  ),


                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Nos Recommandations",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Nouvelle liste horizontale des restaurants
                  Builder(
                    builder: (context) {
                      final List<Food> menu = restaurant.menu;

                      // Regrouper les produits par restaurantName
                      final Map<String, List<Food>> restaurantsMap = {};
                      for (var food in menu) {
                        restaurantsMap
                            .putIfAbsent(food.restaurantName, () => [])
                            .add(food);
                      }

                      final List<String> restaurantNames = restaurantsMap.keys
                          .toList();


                        return SizedBox(
                        height: 105,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restaurantNames.length,
                          itemBuilder: (context, index) {
                            final String restaurantName = restaurantNames[index];
                            final Food sampleFood = restaurantsMap[restaurantName]![0];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantPage(restaurantName: restaurantName),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: Image.asset(
                                            sampleFood.imagePath,
                                            height: 80,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Badge "Promo" ou "⭐"

                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        restaurantName,
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),


                      );
                    },
                  ),

                  const SizedBox(height: 6),
                  MyTabBar(tabController: _tabController),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 300, // ajustable selon le besoin
                    child: TabBarView(
                      controller: _tabController,
                      children: _buildFoodTabs(restaurant.menu),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
