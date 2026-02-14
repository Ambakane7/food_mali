import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/restaurants.dart'; // Assure-toi que le chemin est correct

class MyCurrentLocation extends StatelessWidget {
  const MyCurrentLocation({super.key});

  void openLocationSearchBox(BuildContext context) {
    final restaurantProvider = Provider.of<Restaurants>(context, listen: false);
    final TextEditingController controller =
    TextEditingController(text: restaurantProvider.deliveryAddress);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Votre adresse de livraison"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Ex: Banankabougou ZRNY",
          ),
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),

          // save button
          ElevatedButton(
            onPressed: () async {
              final newAddress = controller.text.trim();

              if (newAddress.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Veuillez entrer une adresse")),
                );
                return; // Stop ici
              }

              // 🔄 Mise à jour Provider
              restaurantProvider.updateDeliveryAddress(newAddress);

              // 🔄 Mise à jour Firestore
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({'address': newAddress});
              }

              // ✅ Ferme le pop après sauvegarde
              Navigator.pop(context);
            },
            child: const Text("Enregistrer"),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<Restaurants>(context);

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Adresse de Livraison",
            style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold, fontSize: 20),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    restaurantProvider.deliveryAddress,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          )
        ],
      ),
    );
  }
}
