import 'package:flutter/material.dart';
import 'package:food_mali/model/restaurants.dart';
import 'package:provider/provider.dart';

class MyRecipe extends StatelessWidget {
  const MyRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Merci pour votre commande ! L’équipe FoodMali vous remercie", textAlign: TextAlign.center,style: TextStyle(color: Colors.deepOrange,fontSize: 22, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 1)])),
            const SizedBox(
              height: 10,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary)),
                child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Consumer<Restaurants>(
                      builder: (context, restaurant, child) =>
                          Text(restaurant.displayCartReceipt()),
                    ))),
            const SizedBox(
              height: 10,
            ),
            const Text("Vous serez appelez très bientôt pour la confirmation de votre commande.\n Merci",textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
