import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/login_page.dart';
import '../Pages/settings_page.dart';
import '../model/restaurants.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Map<String, dynamic>? userData;
  bool isDarkMode = false;

  // ================= FETCH USER =================
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userData = doc.data();
      });
    }
  }

  // ================= UPDATE USER =================
  Future<void> _updateUserData(Map<String, dynamic> newData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(newData);

      await _fetchUserData();

      if (newData.containsKey('address')) {
        Provider.of<Restaurants>(context, listen: false)
            .updateDeliveryAddress(newData['address']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // ================= EDIT DIALOG =================
  void _showEditDialog() {
    final firstNameController =
    TextEditingController(text: userData?['firstName'] ?? '');
    final lastNameController =
    TextEditingController(text: userData?['lastName'] ?? '');
    final phoneController =
    TextEditingController(text: userData?['phone'] ?? '');
    final addressController =
    TextEditingController(text: userData?['address'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Modifier mes informations"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: firstNameController,
                  decoration:
                  const InputDecoration(labelText: "Prénom")),
              TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Nom")),
              TextField(
                  controller: phoneController,
                  decoration:
                  const InputDecoration(labelText: "Téléphone")),
              TextField(
                  controller: addressController,
                  decoration:
                  const InputDecoration(labelText: "Adresse")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _updateUserData({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'phone': phoneController.text,
                'address': addressController.text,
              });
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
    final firstName = userData?['firstName'] ?? '';
    final lastName = userData?['lastName'] ?? '';
    final email = userData?['email'] ?? '';
    final phone = userData?['phone'] ?? '';
    final address = userData?['address'] ?? '';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ================= PROFILE =================
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      child: Text(
                        firstName.isNotEmpty
                            ? firstName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                            fontSize: 30, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$firstName $lastName",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(email,
                        style: const TextStyle(color: Colors.grey)),
                    if (phone.isNotEmpty)
                      Text(phone,
                          style:
                          const TextStyle(color: Colors.grey)),
                    if (address.isNotEmpty)
                      Text(address,
                          textAlign: TextAlign.center,
                          style:
                          const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text("Modifier"),
                    )
                  ],
                ),
              ),
            ),

            const Divider(color: Colors.grey,),

            // ================= MENU =================
            MyDrawerTile(
              text: "A C C U E I L",
              icon: Icons.home_outlined,
              ontTap: () => Navigator.pop(context),
            ),
            const Divider(color: Colors.grey,),

            MyDrawerTile(
              text: "M E S  C O M M A N D E S",
              icon: Icons.receipt_long_outlined,
              ontTap: () {
                Navigator.pop(context);
                // TODO: OrdersPage
              },
            ),
            const Divider(color: Colors.grey,),
            MyDrawerTile(
              text: "A D R E S S E  D E  L I V R A I S O N",
              icon: Icons.location_on_outlined,
              ontTap: _showEditDialog,
            ),

            const Divider(color: Colors.grey,),
            MyDrawerTile(
              text: "A I D E  &  S U P P O R T",
              icon: Icons.support_agent_outlined,
              ontTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text("Support"),
                    content: Text(
                        "Contactez-nous :\n+223 78 05 21 21 \n ambakaneguindo@yahoo.com"),
                  ),
                );
              },
            ),
            const Divider(color: Colors.grey,),
            MyDrawerTile(
              text: "À  P R O P O S",
              icon: Icons.info_outline,
              ontTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "FoodMali",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2026 LaawolDev",
                );
              },
            ),

            // ================= LOGOUT =================
            MyDrawerTile(
              text: "L O G O U T",
              icon: Icons.logout_outlined,
              ontTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoginPage()),
                      (_) => false,
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
