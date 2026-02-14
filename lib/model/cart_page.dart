import 'package:flutter/material.dart';
import 'package:food_mali/components/my_button.dart';
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
  // Déclaration du GlobalKey pour le formulaire
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // user wants to pay
  void userTappedPay() {
    if (formKey.currentState!.validate()) {
      // only show dialog if form is valid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmer le payement"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                // Tu peux ajouter ici des widgets à valider ou afficher
              ],
            ),
          ),
          actions: [
            // cancel button
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            // yes button
            TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryProgressPage(),
                      ));
                })
          ],
        ),
      );
    }
  }

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
                onPressed: () => Navigator.of(context).pop(false), // Annuler
                child: const Text("Non"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirmer
                child: const Text("Oui"),
              ),
            ],
          ),
        ) ??
        false; // En cas de retour null, on considère "non"
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurants>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;

        return Scaffold(
          appBar: AppBar(
            title: Text("Panier",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2)],
              )),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: userCart.isEmpty
              ? const Center(child: Text("Votre panier est vide"))
              // AJOUT du Form ici avec la clé formKey
              : Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: userCart.length,
                          itemBuilder: (context, index) {
                            final CartItem cartItem = userCart[index];

                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                // Afficher la boîte de confirmation
                                return await _showConfirmDialog(
                                    context, cartItem.food.name);
                              },
                              onDismissed: (direction) {
                                restaurant.removeFromCart(cartItem);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${cartItem.food.name} supprimé du panier"),
                                  ),
                                );
                              },
                              child: MyCartTile(cartItem: cartItem),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: ()=>userTappedPay(),
                        child:  Container(height: 50,width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.deepOrange
                          ),child: Center(child: Text("Valider", style: TextStyle(fontSize:15, fontWeight: FontWeight.bold, color: Colors.white),)),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
