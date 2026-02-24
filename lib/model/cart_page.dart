import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_mali/auth/login_or_register.dart';
import 'package:food_mali/components/my_cart_tile.dart';
import 'package:food_mali/model/restaurants.dart';
import 'package:food_mali/model/cart_item.dart';
import 'package:provider/provider.dart';
import '../Pages/delivery_progress_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ==========================
  // Gestion du paiement
  // ==========================
  void userTappedPay() async {
    final user = FirebaseAuth.instance.currentUser;

    // 🔒 Si utilisateur NON connecté → redirection login
    if (user == null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginOrRegister(),
        ),
      );

      // Après retour du login
      final newUser = FirebaseAuth.instance.currentUser;

      if (newUser != null) {
        _proceedToPayment();
      }

      return;
    }

    // Si déjà connecté
    _proceedToPayment();
  }

  void _proceedToPayment() {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmer le paiement"),
          content: const Text(
              "Voulez-vous confirmer votre commande ?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler")),
            TextButton(
                child: const Text("Oui"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryProgressPage(),
                    ),
                  );
                })
          ],
        ),
      );
    }
  }

  // ==========================
  // Confirmation suppression
  // ==========================
  Future<bool> _showConfirmDialog(
      BuildContext context, String productName) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: Text(
            "Voulez-vous vraiment supprimer \"$productName\" du panier ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Oui"),
          ),
        ],
      ),
    ) ??
        false;
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurants>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Panier",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2)],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor:
            Theme.of(context).colorScheme.inversePrimary,
          ),
          body: userCart.isEmpty
              ? const Center(child: Text("Votre panier est vide"))
              : Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: userCart.length,
                    itemBuilder: (context, index) {
                      final CartItem cartItem =
                      userCart[index];

                      return Dismissible(
                        key: UniqueKey(),
                        direction:
                        DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment:
                          Alignment.centerRight,
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: const Icon(Icons.delete,
                              color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await _showConfirmDialog(
                              context,
                              cartItem.food.name);
                        },
                        onDismissed: (direction) {
                          restaurant
                              .removeFromCart(cartItem);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${cartItem.food.name} supprimé du panier"),
                            ),
                          );
                        },
                        child:
                        MyCartTile(cartItem: cartItem),
                      );
                    },
                  ),
                ),

                // ===== BOUTON VALIDER =====
                GestureDetector(
                  onTap: userTappedPay,
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(15),
                        color: Colors.deepOrange),
                    child: const Center(
                      child: Text(
                        "Valider",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}