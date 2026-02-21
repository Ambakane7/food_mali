import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:food_mali/model/cart_item.dart';
import 'cart_item.dart';
import 'food.dart';

class Restaurants extends ChangeNotifier {
  // ====== MENU ======
  final List<Food> _menu = [
    // 🍔 BURGERS
    // 🥤 KFC JUNIOR
    Food(
        "KFC 12 PCS",
        "",
        "lib/images/kfc_junior/kfc_12_pcs.jpeg",
        10000,
        FoodCategory.KFC,
        [
          Addon(name: "2 BOISSONS", price:0),
          Addon(name: "FRITTES", price: 0),
        ],
        "KFC JUNIOR"
    ),
    Food(
        "NEMS",
        "",
        "lib/images/kfc_junior/4_nems.jpeg",
        2000,
        FoodCategory.KFC,
        [
          Addon(name: "", price: 0),
          Addon(name: "", price: 0),
        ],
        "KFC JUNIOR"
    ),
    Food(
        "Chawarma Viande",
        "",
        "lib/images/kfc_junior/chawarma.jpeg",
        2000,
        FoodCategory.KFC,
        [
          Addon(name: "", price: 0),
          Addon(name: "", price: 0),
        ],
        "KFC JUNIOR"
    ),
    Food(
        "Sandwich Viande",
        "",
        "lib/images/kfc_junior/sandwish.jpeg",
        1000,
        FoodCategory.KFC,
        [],
        "KFC JUNIOR"
    ),
    Food(
        "Chawarma Poulet",
        "",
        "lib/images/kfc_junior/chawarma.jpeg",
        2500,
        FoodCategory.KFC,
        [
          Addon(name: "", price: 0),
          Addon(name: "", price: 0),
        ],
        "KFC JUNIOR"
    ),
    /////
    Food(
        "KFC 8 PCS",
        "",
        "lib/images/kfc_junior/kfc_8.jpeg",
        2000,
        FoodCategory.KFC,
        [
          Addon(name: "Frittes", price: 0),
          Addon(name: "1 Boisson", price: 0),
        ],
        "KFC JUNIOR"
    ),
    Food(
        "KFC 3 PCS",
        "",
        "lib/images/kfc_junior/kfc_3_pcs.jpeg",
        4000,
        FoodCategory.KFC,
        [Addon(name: "Frittes", price: 0)],
        "KFC JUNIOR"
    ),
    Food(
        "Tacos Poulet",
        "",
        "lib/images/kfc_junior/Tacos_poulet.jpeg",
        4000,
        FoodCategory.KFC,
        [
          Addon(name: "", price: 0),
          Addon(name: "", price: 0),
        ],
        "KFC JUNIOR"
    ),
    //////
    Food(
        "KFC 5 PCS",
        "",
        "lib/images/kfc_junior/kfc_5_pcs.jpeg",
        5000,
        FoodCategory.KFC,
        [
          Addon(name: "Frittes", price: 0),
        ],
        "KFC JUNIOR"
    ),
    // ajout nouvelle
    Food(
        "Pizza viande hachée",
        "",
        "lib/images/kfc_junior/pizza viande hachée.jpeg",
        5000,
        FoodCategory.KFC,
        [],
        "KFC JUNIOR"
    ),
    Food(
        "Plat de Nems",
        "",
        "lib/images/kfc_junior/plat_nem.jpeg",
        5000,
        FoodCategory.KFC,
        [],
        "KFC JUNIOR"
    ),
    Food(
        "Petit Four 30 Pieces",
        "",
        "lib/images/kfc_junior/petit_four_30.jpeg",
        12500,
        FoodCategory.KFC,
        [
        ],
        "KFC JUNIOR"
    ),
    Food(
        "Petit Four 25 Pieces",
        "",
        "lib/images/kfc_junior/petit_four_25.jpeg",
        10000,
        FoodCategory.KFC,
        [],
        "KFC JUNIOR"
    ),
    Food(
        "Petit Four 15 Pieces",
        "",
        "lib/images/kfc_junior/petit_four15.jpeg",
        5000,
        FoodCategory.KFC,
        [
        ],
        "KFC JUNIOR"
    ),
    // fin ajout nouvelle

    Food(
        "Sandwich Poulet",
        "",
        "lib/images/kfc_junior/Tacos_poulet.jpeg",
        1500,
        FoodCategory.KFC,
        [
        ],
        "KFC JUNIOR"
    ),
    Food(
        "KFC 5 PCS",
        "",
        "lib/images/kfc_junior/kfc_5_pcs.jpeg",
        7000,
        FoodCategory.KFC,
        [
          Addon(name: "Frittes", price: 0),
          Addon(name: "1 Boisson", price: 0)
        ],
        "KFC JUNIOR"
    ),
    // 🍕 PIZZAS
    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv1_30000.jpeg",
        30000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Forêt Drip",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/forêt_drip_20k.jpeg",
        20000,
        FoodCategory.Gateau,
        [],
        "Delights by KADIDIA"
    ),

    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_2_30000.jpeg",
        30000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_3_30000.jpeg",
        30000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),


    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_9_20000.jpeg",
        20000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),

    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_8_50000.jpeg",
        50000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),


    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_6_25000.jpeg",
        25000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),


    /////
    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_2_30000.jpeg",
        30000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),


    Food(
        "Gâteau Mariage",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/maria/gateau_mariage_1_150000.jpeg",
        150000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Gâteau Mariage",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/maria/gateau_mariage_2_80000.jpeg",
        80000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),


    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_10_25k.jpeg",
        25000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_10_25k.jpeg",
        25000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Gâteau Personnaliser",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/gateau_personnalisé_2_20k.jpeg",
        25000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Cake  Personnaliser",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/cake_personnalisé.jpeg",
        20000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    // 1
    Food(
        "Gâteau Mariage",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/maria/gateau_mariage_180000.jpeg",
        180000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Gâteau Mariage",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/maria/gateau_mariage_70000.jpeg",
        70000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),
    Food(
        "Gâteau Mariage",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/maria/gateau_mariage_60000.jpeg",
        60000,
        FoodCategory.Gateau,
        [
        ],
        "Delights by KADIDIA"
    ),

    // BOBO'S HOUSE
    Food(
        "Plat à l'Aubergine",
        "Aubergine, fromage, viande hachée",
        "lib/images/bobohouse/aubergine.webp",
        7000,
        FoodCategory.Special,
        [
          Addon(name: "Avocat", price: 0),
          Addon(name: "Pain", price: 0),
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Burrito",
        "Tortillas, viande hachée, avocat",
        "lib/images/bobohouse/burrito.webp",
        8000,
        FoodCategory.Special,
        [
          Addon(name: "salade", price: 0),
          Addon(name: "Fruite de pomme de terre", price: 0),
          Addon(name: "Patate douce", price: 0)
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Burrito avec poulet",
        "Tortillas, viande hachée, avocat",
        "lib/images/bobohouse/burrito.webp",
        9000,
        FoodCategory.Special,
        [
          Addon(name: "salade", price: 0),
          Addon(name: "Fruite de pomme de terre", price: 0),
          Addon(name: "Patate douce", price: 0)
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Quesadillas",
        "Tortillas, viande hachée, fromage",
        "lib/images/bobohouse/quesadillas.webp",
        6000,
        FoodCategory.Special,
        [
          Addon(name: "salade de choux", price: 0),
          Addon(name: "Patate douce", price: 0)
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Quesadillas avec poulet",
        "Tortillas, viande hachée, fromage",
        "lib/images/bobohouse/quesadillas.webp",
        7000,
        FoodCategory.Special,
        [
          Addon(name: "salade de choux", price: 0),
          Addon(name: "Patate douce", price: 0)
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Déjeuner Turque",
        "Oeuf, paprika, Tomate, baguette",
        "lib/images/bobohouse/dejeuner_turque.webp",
        4000,
        FoodCategory.Special,
        [
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Mexico City",
        "Patate douce, pomme de terre, viande hachée, oeuf, fromage",
        "lib/images/bobohouse/mexico_city.webp",
        7000,
        FoodCategory.Special,
        [
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Dr Keb",
        "salade de choux, pain brioche, viande hachée, fromage",
        "lib/images/bobohouse/dr_keb.webp",
        8000,
        FoodCategory.Special,
        [
          Addon(name: "Patate douce", price: 500),
          Addon(name: "Avocat", price: 1000),
          Addon(name: "Fritte", price: 1000)
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Burger",
        "Pain burger, fromage, steak, salade, sauce, oeuf",
        "lib/images/bobohouse/burger.webp",
        9000,
        FoodCategory.burgers,
        [
          Addon(name: "Avocat", price: 1000),
          Addon(name: "Patate douce", price: 500),
          Addon(name: "Pomme fritte", price: 1000)
        ],
        "BOBO'S HOUSE"
    ),
    Food(
        "Patate Fourée",
        "Patate, poulet, fromage, beurre",
        "lib/images/bobohouse/patate_fouréz.webp",
        6000,
        FoodCategory.Special,
        [
        ],
        "BOBO'S HOUSE"
    ),


    // ALLO PIZZA
    Food(
        "Pizza Vegetarienne",
        "",
        "lib/images/allo_pizza/vegetarienne.webp",
        6000,
        FoodCategory.Pizza,
        [],
        "ALLO PIZZA"
    ),
    Food(
        "Pizza Fromage",
        "",
        "lib/images/allo_pizza/fromage.webp",
        8000,
        FoodCategory.Pizza,
        [],
        "ALLO PIZZA"
    ),
    Food(
        "Pizza Margherita",
        "",
        "lib/images/allo_pizza/margherita.webp",
        6000,
        FoodCategory.Pizza,
        [
        ],
        "ALLO PIZZA"
    ),
    Food(
        "Pizza Poulet",
        "",
        "lib/images/allo_pizza/poulet.webp",
        7000,
        FoodCategory.Pizza,
        [],
        "ALLO PIZZA"
    ),
    ////
    Food(
        "Pizza Oriental",
        "",
        "lib/images/allo_pizza/pizza_oriental.jpg",
        6000,
        FoodCategory.Pizza,
        [
        ],
        "ALLO PIZZA"
    ),
    Food(
        "Pizza Royal",
        "",
        "lib/images/allo_pizza/pizza_royal.jpeg",
        7000,
        FoodCategory.Pizza,
        [],
        "ALLO PIZZA"
    ),

    Food(
        "Pizza Reine",
        "",
        "lib/images/allo_pizza/pizza_reine2.jpg",
        6500,
        FoodCategory.Pizza,
        [],
        "ALLO PIZZA"
    ),
    ////
    Food(
        "Pizza Bolognaise",
        "",
        "lib/images/allo_pizza/bolognaise.webp",
        6000,
        FoodCategory.Pizza,
        [
        ],
        "ALLO PIZZA"
    ),
    Food(
        "Pizza Armenienne",
        "",
        "lib/images/allo_pizza/armerienne.webp",
        7000,
        FoodCategory.Pizza,
        [],
        "ALLO PIZZA"
    ),

    ////
    Food(
        "Dr Keb",
        "salade de choux, pain brioche, viande hachée, fromage",
        "lib/images/bobohouse/dr_keb.webp",
        8000,
        FoodCategory.Special,
        [
          Addon(name: "Patate douce", price: 500),
          Addon(name: "Avocat", price: 1000),
          Addon(name: "Fritte", price: 1000)
        ],
        "Best Seller"
    ),
    Food(
        "Patate Fourée",
        "Patate, poulet, fromage, beurre",
        "lib/images/bobohouse/patate_fouréz.webp",
        6000,
        FoodCategory.Special,
        [
        ],
        "Best Seller"
    ),


    Food(
        "Quesadillas avec poulet",
        "Tortillas, viande hachée, fromage",
        "lib/images/bobohouse/quesadillas.webp",
        7000,
        FoodCategory.Special,
        [
          Addon(name: "salade de choux", price: 0),
          Addon(name: "Patate douce", price: 0)
        ],
        "Best Seller"
    ),
    Food(
        "Gâteau Anniversaire",
        "Saveur chocolat recouvert et crème nature totalement personnalisable",
        "lib/images/kadi/anniv/gateau_anniv_10_25k.jpeg",
        25000,
        FoodCategory.Gateau,
        [
        ],
        "Best Seller"
    ),

  ];




  // ====== GETTERS ======
  List<Food> get menu => _menu;

  List<CartItem> get cart => _cart;

  String get deliveryAddress => _deliveryAddress;

  // ====== CART ======
  final List<CartItem> _cart = [];

  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = const ListEquality().equals(
          item.selectedAddons, selectedAddons);
      return isSameFood && isSameAddons;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(
          CartItem(food: food, selectedAddons: selectedAddons, quantity: 1));
    }

    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    if (_cart.contains(cartItem)) {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        _cart.remove(cartItem);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void removeFromMenu(Food food) {
    _menu.remove(food);
    notifyListeners();
  }

  // ====== DELIVERY & CLIENT INFOS ======
  String _deliveryAddress = "Tapez votre localisation";
  String _clientFirstName = "";
  String _clientLastName = "";
  String _clientPhone = "";
  String _clientEmail = "";
  void setClientInfo({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) {
    _clientFirstName = firstName;
    _clientLastName  = lastName;
    _clientPhone     = phone;
    _clientEmail     = email;
    // element rajouté
    notifyListeners();
  }

// methode ajouté
  Map<String, dynamic> buildOrderData() {
    return {
      'createdAt': DateTime.now(),
      'totalPrice': getTotalPrice(),
      'totalItems': getTotalItemCount(),
      'deliveryAddress': _deliveryAddress,
      'client': {
        'firstName': _clientFirstName,
        'lastName': _clientLastName,
        'phone': _clientPhone,
        'email': _clientEmail,
      },
      'items': _cart.map((cartItem) {
        return {
          'name': cartItem.food.name,
          'restaurant': cartItem.food.restaurantName,
          'price': cartItem.food.price,
          'quantity': cartItem.quantity,
          'addons': cartItem.selectedAddons.map((addon) {
            return {
              'name': addon.name,
              'price': addon.price,
            };
          }).toList(),
        };
      }).toList(),
    };
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  set clientFirstName(String value) {
    _clientFirstName = value;
    notifyListeners();
  }

  set clientLastName(String value) {
    _clientLastName = value;
    notifyListeners();
  }

  set clientPhone(String value) {
    _clientPhone = value;
    notifyListeners();
  }

  set clientEmail(String value) {
    _clientEmail = value;
    notifyListeners();
  }

  // ====== CALCULATIONS ======

  double getTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;
      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;
    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Voici votre reçu.");
    receipt.writeln();

    String formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(
        DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln("---------");

    // 🧾 Parcours des éléments du panier
    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(
              cartItem.food.price)}");

      // 👇 Ajout du nom du restaurant
      receipt.writeln("  Restaurant : ${cartItem.food.restaurantName}");

      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln("  Complements: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("----------------");
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln("adresse de livraison: $_deliveryAddress");
    receipt.writeln();
    receipt.writeln("Client: $_clientFirstName $_clientLastName");
    receipt.writeln("Phone: $_clientPhone");
    receipt.writeln("Email: $_clientEmail");

    return receipt.toString();
  }
}

// ====== FORMAT HELPERS ======

String _formatPrice(double price) {
  return "${price.toStringAsFixed(2)} FCFA";
}

String _formatAddons(List<Addon> addons) {
  return addons.map((addon) => "${addon.name} (${_formatPrice(addon.price)})").join(", ");
}
