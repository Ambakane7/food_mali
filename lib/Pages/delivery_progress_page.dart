import 'package:flutter/material.dart';
import 'package:food_mali/Accueil/Page1.dart';
import 'package:food_mali/auth/database/firestore.dart';
import 'package:food_mali/components/my_button.dart';
import 'package:food_mali/components/my_recipe.dart';
import 'package:food_mali/model/restaurants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FirestoreService db = FirestoreService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _prepareAndSaveOrder();
  }

  Future<void> _prepareAndSaveOrder() async {
    final restaurants = context.read<Restaurants>();
    final userData = await db.getUserData();

    if (userData != null) {
      restaurants.setClientInfo(
        firstName: userData['Prenom']
            ?? userData['prenom']
            ?? userData['firstName']
            ?? "",
        lastName: userData['Nom']
            ?? userData['nom']
            ?? userData['lastName']
            ?? "",
        phone: userData['Telephone']
            ?? userData['telephone']
            ?? userData['phone']
            ?? "",
        email: userData['email'] ?? "",
      );

    }

   final receipt = restaurants.displayCartReceipt();
    await db.saveOrderToDatabase(receipt);


    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MyRecipe(),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final restaurants = context.read<Restaurants>();
                  restaurants.clearCart(); // <-- Vider le panier ici

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page1()),
                  );
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepOrange,
                  ),
                  child: const Center(
                    child: Text(
                      "TERMINER",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle,
            ),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                "Assistant(e) technique",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                "FoodMali",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                ),
              ),
              const SizedBox(width: 5),
              buildButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton() {
    final number = '+22378052121';
    return ElevatedButton(
      onPressed: () async {
        final uri = Uri.parse('tel:$number');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Impossible de lancer $uri';
        }
      },
      child: const Icon(Icons.call, color: Colors.green),
    );
  }
}
